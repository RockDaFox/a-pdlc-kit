# ADR-0022 — The product is named A-PDLC Kit again, slug `a-pdlc-kit`, skills prefixed `a-pdlc-`

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-11-09 |
| **Supersedes** | [ADR-0016](0016-product-named-ag-pdlc-kit.md) |

## Context

[ADR-0016](0016-product-named-ag-pdlc-kit.md) renamed the product Ag-PDLC Kit, slug `ag-pdlc-kit`, so that the name matched the repository directory and the remote. The maintainer now wants the name A-PDLC Kit, the one [ADR-0006](0006-product-named-a-pdlc-kit.md) settled.

## Decision

The display name is **A-PDLC Kit**. The manifest slug is `a-pdlc-kit`, so installation reads `/plugin install a-pdlc-kit@a-pdlc-kit`. The six skills take the prefix `a-pdlc-`, matching the slug: `a-pdlc-init`, `a-pdlc-feature`, `a-pdlc-decide`, `a-pdlc-build`, `a-pdlc-review` and `a-pdlc-report`, each in a directory and a `name:` of that name. The shared directory stays `skills/_pdlc-shared/`, since it is not a skill and no one types it, and the spec files keep their names `docs/specs/pdlc-*.md`, because earlier ADRs link to them and an ADR is not edited. The `owner` and `author` fields keep the account name decided in ADR-0016; only the name and the slug change.

The identifiers the AI-notice hook writes into a project repository keep their current form: the `# ag-pdlc-kit` tag in the pre-commit hook and the `ag-pdlc-kit-notice-check.sh` file in the git directory. They are how an installed hook is recognised, and renaming them would leave every repository where `pdlc-init` already installed it with a hook the next install no longer recognises.

## Alternatives weighed

- **Display name only, slug kept as `ag-pdlc-kit`** — rejected: the identifier would differ from the name people say, the gap ADR-0006 and ADR-0016 both closed.
- **Skills keeping the prefix `pdlc-`** — rejected: ADR-0006 and ADR-0016 chose the short prefix to save four characters per invocation, and the maintainer now prefers the skill names to carry the product name.
- **Renaming the hook's tag and file as well** — rejected: a second install on a repository that already has the hook would add a second call beside the old one instead of recognising it.

## Consequences

- Anyone who installed `ag-pdlc-kit` has the old marketplace and plugin entries. As with the two earlier renames, there is no upgrade path: they uninstall and reinstall under `a-pdlc-kit@a-pdlc-kit`.
- The GitHub remote is still `ag-pdlc-kit`, and the `marketplace add` line in `README.md` still points at it. It changes when the remote is renamed, which this record does not do.
- Every invocation changes, `/pdlc-init` becoming `/a-pdlc-init` and so on, and a person or document still using the old names finds no skill under them. The ADRs written before this one keep the old names in their text.
- A spec file's name no longer matches its skill's: `docs/specs/pdlc-init.md` describes `a-pdlc-init`.
- ADR-0016 and ADR-0018 keep the former name in their text; each is accurate about its date.
- The hook's tag and file name carry the former slug, so the product's name and these two identifiers disagree.
