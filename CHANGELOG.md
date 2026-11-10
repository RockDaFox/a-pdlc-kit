# Changelog

What changed for someone using the kit, newest first. Dates are those of the
version bump. Each entry is written with the bump, in the same commit. The
reasons are in [`docs/adr/`](docs/adr/) and
[`docs/specs/`](docs/specs/).

## 1.1.0 — 2026-11-10

- `a-pdlc-feature` asks, every time, which spec the work goes in: an existing
  one it amends, or a new one. A request that changes a spec's behavior,
  reverses one of its decisions or lifts one of its non-goals amends that
  spec.
- An amended `Shipped` spec returns to `Draft` until it is reconciled, with
  one line naming what is not yet shipped.
- Specs carry a one-line `Covers` in their header. `a-pdlc-feature` finds the
  specs a request touches by searching, never by reading them one by one.
  Specs written before this line are still found by the search.
- `a-pdlc-review` reviews a spec. One fresh agent reads it in two passes: a
  business analyst pass, written before any code is opened, then a tech lead
  pass. Findings are wording fixes, open questions or referrals.
- After writing a spec, `a-pdlc-feature` asks whether to have it reviewed,
  and writes out the command.

## 1.0.0 — 2026-11-09

- The kit is named A-PDLC Kit again, and every skill is prefixed `a-pdlc-`
  ([ADR-0022](docs/adr/0022-product-named-a-pdlc-kit-again.md)). Reinstall
  the plugin under its new name.
- `a-pdlc-init` offers to copy the skills into the project skills directory
  of each host, so a repository works for a teammate who has not installed
  the kit ([ADR-0023](docs/adr/0023-the-kit-may-copy-its-skills-into-a-project.md)).

## 0.12.0 — 2026-11-05

- A repository with an `openspec/` directory keeps its feature specs in
  OpenSpec. `pdlc-feature` hands over to OpenSpec's propose command,
  `pdlc-build` builds an open change and archives it at the commit,
  `pdlc-review`, `pdlc-decide` and `pdlc-report` read the change, and
  `pdlc-init` offers rules for `openspec/config.yaml`
  ([ADR-0021](docs/adr/0021-a-repository-that-uses-openspec-keeps-its-specs-there.md)).

## 0.11.1 — 2026-10-30

- The kit is licensed under MIT, and the manifests declare it.

## 0.11.0 — 2026-10-21

- New skill `pdlc-report`: a dated report for readers who do not read the
  repository — a sponsor, the end users, the team — as Markdown, a one-page
  HTML document or HTML slides
  ([ADR-0020](docs/adr/0020-generated-slides-may-carry-navigation-script.md)).

## 0.10.0 — 2026-10-21

- `pdlc-init` offers a pre-commit hook that refuses a commit carrying an
  unreviewed AI notice.
- Every generated document ends with the same AI notice, under an `ai-draft`
  marker.
- The kit is described as the toolbox of a whole product team, across the
  product development life cycle
  ([ADR-0018](docs/adr/0018-the-kit-serves-the-whole-product-team.md)).

## 0.9.0 — 2026-10-20

- Specification of the review of a spec, offered by `pdlc-feature` after the
  draft. Built in 1.1.0.

## 0.8.2 — 2026-10-10

- A spec is never split for its size: 500 lines is a readability target, and
  a spec past it is rewritten more plainly.

## 0.8.1 — 2026-10-09

- Fix: the Claude Code manifest prefixes the skills path with `./`, so it
  validates.
- The README is rewritten around install, use and what the kit writes.

## 0.8.0 — 2026-10-09

- A spec states its behavior as numbered, observable lines. The build writes
  at least one test per line and reports one evidence row per line, and
  `pdlc-review` reads the tests against those lines in an agent that did not
  write them ([ADR-0017](docs/adr/0017-a-spec-states-its-behavior-as-testable-lines.md)).
- The plugin is renamed `ag-pdlc-kit`
  ([ADR-0016](docs/adr/0016-product-named-ag-pdlc-kit.md), since superseded).
- Vibe installs from the Claude Code manifest; the separate Vibe manifest pair
  is dropped.

## 0.7.1 — 2026-10-01

- Generated specs are kept short and plainly worded.

## 0.7.0 — 2026-09-29

- New skill `pdlc-review`: a tech-lead review of a change against the
  repository's conventions, its spec and the installed library versions,
  with graded findings. Selected corrections go through the build loop
  ([ADR-0015](docs/adr/0015-review-corrections-enter-the-build-loop.md)).

## 0.6.3 — 2026-09-28

- The build loop stays silent through its expected red, and reports once, in
  the evidence block.

## 0.6.2 — 2026-09-17

- `pdlc-build` and `pdlc-feature` ask before committing.

## 0.6.1 — 2026-09-17

- A draft spec is committed only once the user has reviewed and approved it.

## 0.6.0 — 2026-09-16

- New skill `pdlc-build`: builds a spec test-first and reports an evidence
  block. `pdlc-feature` runs the same loop at its implementation step.

## 0.5.0 — 2026-09-16

- Wording corrections across the reference files and `pdlc-decide`.

## 0.4.0 — 2026-09-16

- A spec is written before the implementation it governs, and reconciled with
  what shipped after it
  ([ADR-0012](docs/adr/0012-a-spec-precedes-the-implementation-it-governs.md)).
- An ADR's AI notice is removed by the review, before the commit that makes
  the ADR immutable
  ([ADR-0013](docs/adr/0013-notice-removed-by-the-review-before-commit.md)).
- The shared reference is split by need, so a skill loads only what it uses
  ([ADR-0010](docs/adr/0010-shared-reference-split-by-need.md)).

## 0.3.1 and earlier — 2026-09-14 to 2026-09-15

- First skills: `pdlc-init` writes `AGENTS.md` and `PRODUCT.md` from the code
  and the git history, `pdlc-feature` turns a request into a spec and code,
  `pdlc-decide` records a decision as an ADR or a spec entry.
- One set of files for Claude Code and GitHub Copilot, each host with its own
  manifest pair ([ADR-0003](docs/adr/0003-provider-neutral-skills-layout.md)).
- Decision records are written forward from installation, never backfilled
  ([ADR-0004](docs/adr/0004-decision-records-are-written-forward.md)); ADRs
  are append-only ([ADR-0011](docs/adr/0011-append-only-binds-the-decision.md)).
