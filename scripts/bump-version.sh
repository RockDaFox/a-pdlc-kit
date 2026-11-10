#!/bin/sh
#
# Bumps the version in both plugin.json manifests together, so a release
# never advances one and forgets the other — the omission scripts/check.sh
# can only notice after the fact. Opens the new version's entry at the top of
# CHANGELOG.md in the same run, listing the feat: and fix: commit subjects
# since the previous bump, for a human to edit before the commit.
#
# Usage:  sh scripts/bump-version.sh major|minor|patch|X.Y.Z
# Exit:   0 on success, 1 on a bad argument or a manifest it cannot read
#
# POSIX sh, no dependency, same textual reads as scripts/check.sh: sh has no
# JSON parser and a dependency would defeat the point of a script this small.

set -u

cd "$(dirname "$0")/.." || exit 1

_cc_p=.claude-plugin/plugin.json
_gh_p=.github/plugin/plugin.json

field() {
	sed -n "s/.*\"$2\"[ ]*:[ ]*\"\([^\"]*\)\".*/\1/p" "$1" | sed -n 1p
}

_cur=$(field "$_cc_p" version)
if [ -z "$_cur" ]; then
	echo "cannot read \"version\" from $_cc_p — shape changed, refusing to guess"
	exit 1
fi

case "$_cur" in
[0-9]*.[0-9]*.[0-9]*) ;;
*)
	echo "$_cc_p  version \"$_cur\" is not major.minor.patch, refusing to bump it"
	exit 1
	;;
esac

_major=${_cur%%.*}
_rest=${_cur#*.}
_minor=${_rest%%.*}
_patch=${_rest#*.}

case "${1:-}" in
major)
	_new="$((_major + 1)).0.0"
	;;
minor)
	_new="$_major.$((_minor + 1)).0"
	;;
patch)
	_new="$_major.$_minor.$((_patch + 1))"
	;;
[0-9]*.[0-9]*.[0-9]*)
	_new="$1"
	;;
*)
	echo "usage: sh scripts/bump-version.sh major|minor|patch|X.Y.Z"
	exit 1
	;;
esac

for m in "$_cc_p" "$_gh_p"; do
	[ -f "$m" ] || {
		echo "$m  missing"
		exit 1
	}
	_have=$(field "$m" version)
	[ "$_have" = "$_cur" ] || {
		echo "$m  version is \"$_have\", expected \"$_cur\" — already disagreeing, run scripts/check.sh first"
		exit 1
	}
done

_log=CHANGELOG.md
if grep -q "^## $_new " "$_log" 2>/dev/null; then
	echo "$_log  already has an entry for $_new, refusing to write a second"
	exit 1
fi

for m in "$_cc_p" "$_gh_p"; do
	sed -i.bak "s/\"version\": \"$_cur\"/\"version\": \"$_new\"/" "$m" && rm -f "$m.bak"
done

# The previous bump is the last commit that changed the version line. Its
# subjects are the draft, not the entry: a commit message is written for a
# maintainer, a changelog for someone using the kit.
_last=$(git log -1 --format=%H -G'"version"' -- "$_cc_p" 2>/dev/null)
_items=""
[ -n "$_last" ] &&
	_items=$(git log --reverse --format=%s "$_last"..HEAD |
		sed -n -e 's/^feat[^:]*: \(.*\)/- \1/p' -e 's/^fix[^:]*: \(.*\)/- Fix: \1/p')
[ -n "$_items" ] || _items="- "

[ -f "$_log" ] || printf '# Changelog\n' >"$_log"
block="## $_new — $(date +%Y-%m-%d)

$_items" awk '
	!done && /^## / { print ENVIRON["block"]; print ""; done = 1 }
	{ print }
	END { if (!done) { print ""; print ENVIRON["block"] } }
' "$_log" >"$_log.tmp" && mv "$_log.tmp" "$_log"

echo "$_cur -> $_new in $_cc_p and $_gh_p"
echo "$_log  entry for $_new opened from the commit subjects — edit it before the commit"
