# ADR-0023 — `a-pdlc-init` may copy the kit's skills into a project, on a yes, and refreshes the copy

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-11-09 |
| **Supersedes** | — |

## Context

[ADR-0001](0001-distribution-as-claude-code-plugin.md) copied nothing into a target repository, so that no project froze the version it was installed with. [ADR-0003](0003-provider-neutral-skills-layout.md) kept that line and rejected vendoring a directory of the kit into every target repository, for the same reason: it pins a vintage per project, and both hosts install globally.

The user asked for the opposite property: a repository that works for a teammate who has not installed the kit. With the plugin alone, the skills exist on the machine of whoever installed it, and `AGENTS.md` names skills that a clone on another machine does not have.

The hosts do not agree on a project path for skills. Claude Code reads `.claude/skills/` and not `.agents/skills/`; GitHub Copilot reads `.github/skills/`, `.claude/skills/` and `.agents/skills/`; Vibe reads `.vibe/skills/` and `.agents/skills/`. No directory is read by all three. This was read in each host's documentation on 2026-11-09.

## Decision

**`a-pdlc-init` offers to copy the kit's skills into the project, and does so only on a yes.** The six skills and `_pdlc-shared/` are written, as siblings, into the project skills directory of the host the session runs in: `.claude/skills/`, `.github/skills/` or `.vibe/skills/`. The skill names its host and asks when it cannot tell. The same yes adds two lines to `AGENTS.md` saying where the copy is and which skill to use for what. The skill commits nothing.

**The copy carries its version, and running the skill again refreshes it, on a yes.** The version is written to `_pdlc-shared/version`. A refresh replaces the kit's own directories and touches nothing else in the destination. A skill of the project's own with a kit skill's name is not overwritten. This is what answers ADR-0003's reason for rejecting vendoring: the vintage is visible, and there is a path to move it.

ADR-0003's decision stands. The plugin remains the way the kit is distributed, and `skills/` remains the one copy of every instruction in this repository; what is reopened is only its rejected alternative, in a narrower form: opt-in, versioned, refreshable.

The rule that nothing under `skills/` names a host is kept for how bundled files are reached. `a-pdlc-init` names the three project directories, because choosing the destination is its job.

## Alternatives weighed

- **`.agents/skills/` as the one destination** — chosen first, then dropped: Claude Code, the host the kit is built on, does not read it.
- **A copy in every host's directory** — rejected by the user in favour of detecting the host: identical copies in one repository diverge when one is edited by hand.
- **A symbolic link from `.agents/skills` to `.claude/skills`** — not chosen: links are unreliable on Windows and in some CI checkouts.
- **Copying by default** — rejected: the files are versioned and seen by every contributor, and a project that relies on the plugin should not gain them unasked.
- **A copy that is never refreshed** — rejected: it is the frozen vintage ADR-0003 rejected.
- **A script that makes the copy** — not written: the copy is a directory copy with one version file, and `AGENTS.md` keeps the product's executables to the one check of [ADR-0019](0019-the-kit-ships-one-check-that-runs-on-a-documented-repository.md). The agent follows the skill's text.
- **A skill of its own for the copy** — rejected by the user in favour of a question at the end of `a-pdlc-init`.

## Consequences

- A repository that took the copy carries the kit's text and `notice-check.sh` in its tree, under version control. Auditing what the product put there means reading those files, and a hand edit to them is lost at the next refresh.
- A project with the plugin installed and a copy in the repository lists the skills twice, under two names.
- A copy is as old as its last refresh. Nothing tells a team that a newer kit exists; the version file lets a person compare.
- The `.vibe/skills/` path comes from Vibe's documentation and has not been tried. It is settled when a Vibe user opens a copy.
- No test covers the copy: the repository has none. Five of the behavior lines were replayed by hand in throwaway directories, and the others are what an agent does when it follows the text.
