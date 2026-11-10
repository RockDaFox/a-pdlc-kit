---
name: a-pdlc-review
description: Review a change or a spec. A change is reviewed the way an experienced tech lead would — code quality, the repository's own conventions, correct use of the libraries in play, readability and maintainability for a human, whether the change stayed inside what its spec authorised, and whether its tests assert what the spec states — by an agent independent of the one that built it, then the selected corrections are applied and the repository's own checks run. A spec is read by one fresh agent in two passes — as business analyst first, without reading any code, then as tech lead — and the two lists are shown together, unmerged. Findings are graded blocking, to fix and detail, and only those the user selects are applied. Invoked on demand, on the uncommitted working tree or on a target given; a path under the specs directory is reviewed as a spec. Use when a change is ready to be looked over before it is committed, when a spec is ready to be looked over before its go-ahead, or when the user invokes /a-pdlc-review.
---

# Review a change

A review is worth what it refuses to say. Asked to look at a diff, a model will always find something, and a list that raises everything at equal weight is read once and skipped thereafter. This skill reviews against what the repository has already written down — its conventions, the spec the work was authorised against, the versions of the libraries actually installed — and grades what it finds, so that the reader's decision is which findings to act on rather than which ones to believe.

Read [`doc-discipline.md`](../_pdlc-shared/doc-discipline.md) first: it resolves `{docs_root}` and holds the routing test, which the last step needs. Read [`build-loop.md`](../_pdlc-shared/build-loop.md) later, and only once the user has selected something — that file is what applies the corrections, and a review the user closes without selecting any has no use for it.

This skill is invoked on demand, and nothing calls it automatically: [`a-pdlc-build`](../a-pdlc-build/SKILL.md) ends on its own evidence block and its own ask, and a review before that commit is the user's decision to make, not a gate the kit imposes. The relation runs the other way round — a review does not sit inside the loop, it reaches into it once the user has chosen what to correct.

## Code or a spec

The target is code unless it is a spec. A path under `{docs_root}/specs/`, or a file the user says is a spec, is a spec. Any other path, a branch, a range and the working tree are code. Given no target, review the uncommitted working tree as code, and never infer a spec from it. [`a-pdlc-feature`](../a-pdlc-feature/SKILL.md) names the spec's path when it launches this review, and never relies on the default.

Stop before anything runs in three cases:

- **The path does not exist, or the file is not a spec** — it has no `Status` in its header. Say which, and run nothing.
- **The user says "the spec" and no file matches, or several do.** Ask for the path.
- **A range holds both code and spec changes.** Ask which to review.

A spec is reviewed as [Reviewing a spec](#reviewing-a-spec) states, at the end of this file; the sections between here and there are the review of code. An OpenSpec change is not taken as a spec target: say so, and offer the review of code instead.

## Who reads the change

The review is made by an agent that did not write the change and has not seen the conversation that produced it. The session that wrote the tests is the worst judge of them: it knows what they were meant to say, and reads that into what they say.

Where this session wrote, discussed or planned the change, hand the reading to a fresh agent — a subagent where the host offers one. Give it the target, the path of the spec when one governs the change (in a repository that uses OpenSpec, the path of the change and the resolved path of `openspec.md`), and this file's sections from What is reviewed to Grading, to follow as written. Give it nothing else: not the build's evidence block, not a summary of the change, not the reasons for a choice in it, because each of those carries the author's reading across with it. It reads and reports; it edits nothing and runs nothing. Where the host cannot start one, say so and ask the user to run this skill again in a new session, rather than reviewing from here and presenting it as independent. A session with no memory of the change, a new one, reviews directly.

The invoking session relays the findings as returned: numbered, graded, the unverified ones marked. It does not drop, regrade or soften one; a disagreement is stated beside the finding, and the decision stays with the user. Everything from After the report on is done by this session, because it is the one that holds the conversation with the user and the build loop.

## What is reviewed

The uncommitted working tree by default — staged and unstaged together, which is the state the moment before a commit. A target given instead is honoured: a branch against the trunk, a commit range, a path.

Read the diff in full and read enough of the code around it to judge each change in place. A hunk read as a fragment produces findings about the fragment.

## What it is reviewed against

Four sources, in this order. Name at the start which of them the repository does not have — a review that silently ran on three sources reads exactly like one that ran on four.

**The conventions**, from the code style zone of `AGENTS.md` and from what the surrounding code actually does. Nothing here ships a quality checklist: a bundled one contradicts the repository the day the two disagree, and it goes stale without anyone noticing. Where the repository has written nothing down, say so and review against the surrounding code rather than declining to run.

**The spec that authorised the work**, `{docs_root}/specs/<feature>.md`, on three questions no style guide answers: whether the diff reaches beyond what was authorised, whether every line of its Behavior section has a test, and whether each of those tests asserts the result its line states. Read the tests themselves, not the evidence block's account of them: that block is the account of the agent that wrote the tests, and this is the one reading of them made by someone else. A test that checks a call made, an internal structure or a mock's own answer covers nothing, and is a finding. So is a test that cites no line, a test found beyond the spec that sits inside its non-goals, and a result the spec leaves open that the code or a test decided instead of reporting it as a proposed line. A spec with no Behavior section has no lines to hold the tests to: say that, and do not write them from the code. Where no spec governs the change, skip this axis and say it was skipped. Never reconstruct a contract from the code in order to have something to compare against — that is how a plausible invented record gets made.

In a repository that uses OpenSpec — `doc-discipline.md` says how to tell — the spec is the change under `openspec/changes/` that the diff builds, open or archived in the diff itself, and [`openspec.md`](../_pdlc-shared/openspec.md) maps its parts: its proposal's scope is what was authorised, its scenarios are the lines. Where several changes are open and nothing in the diff tells which one it builds, ask.

**The libraries the change calls into**, standard and third party alike, judged on what the installed version provides. See below; this is the axis that needs the most care.

**Tech-lead judgement**, where none of the three settles it: whether a human who did not write this will follow it, whether the next change to it will be safe, whether the shape matches what it is doing.

## Libraries

Establish what the installed version provides before judging a call: the dependency manifest and the lockfile for the version in play, then the installed source, type definitions or docstrings the repository already carries, then the library's published documentation for that version where the tree holds nothing readable.

This is where a review is most dangerous. A misremembered API produces the most confident wrong finding a model can emit, and it reads exactly like a grounded one. So every finding of this kind names what it is grounded in, and a finding that cannot be grounded is reported as unverified rather than asserted. Correcting working code into broken code costs more than having said nothing.

The call that fails is the easy case. The one worth looking for is the call that works while ignoring what the library already provides: a helper written by hand that the standard library has, an entry point the installed version deprecates, a resource left to chance where the documented idiom manages it, an option passed that this version quietly ignores.

## Grading

Every finding carries a grade and fits on one line: where it is, what is wrong, what the correction would be.

- **Blocking** — it should not be committed in this state.
- **To fix** — it should change, and the change can wait for a decision.
- **Detail** — it is worth one line and nothing more.

The grade is the bar, not decoration. It forces the question of how much a finding matters to be answered rather than left to the reader, and the one-line budget is what keeps a detail from being argued over a paragraph. A finding that will not fit in one line is one that needs the user's judgement before anything else — grade it accordingly rather than expanding it.

Number the findings so they can be selected by number.

## After the report

Change nothing until the user has answered. This skill reviews; it does not arbitrate.

**Every selected finding enters the build loop, and none is applied beside it.** This skill chooses and sequences; [`build-loop.md`](../_pdlc-shared/build-loop.md) is what changes the code and what proves the change. A correction is a unit of work there exactly as a behavior is: it takes its own pass through that loop's steps 1 to 5, and the closing steps — the repository's lint, typecheck and build, the diff inspected, the evidence block — run once over the whole set. This skill runs no command on its own authority.

What a correction carries decides what its pass holds. One that changes behavior brings a new expected failure with it and takes the pass as written, so it arrives with a test. One that changes no behavior has no failure to state; say so, and what it owes instead is that the tests already covering that code are green afterwards for the same reasons they were before.

Nothing outside the selected findings changes. Anything noticed along the way and not selected is a finding for the next review, not an edit smuggled into a diff the user believes they scoped.

A substantive finding the user declined goes into the governing spec's Known gaps, with the condition that should bring it back. Without a trace it returns at every later review, which is the re-opening of settled questions this kit exists to prevent. Declined details leave nothing behind: a Known gaps table padded with every nit somebody waved off stops being read, and then the gaps that mattered go with it. Where no spec governs the change, write nothing and say so rather than inventing somewhere to put it. In a repository that uses OpenSpec, the Known gaps are those of the change's `design.md`; a change archived in an earlier commit is history, so write nothing there and say so.

## Finishing

Report the loop's evidence block, then what was declined and where it was recorded. Findings left unverified are named again here, as unverified — that is the state they are in, not a reservation to bury in the body.

This skill commits nothing. The review ends on a working tree, and the commit stays with whoever owns it: `a-pdlc-build`'s own ask, `a-pdlc-feature`'s step 7, or the user directly.

Remind the user that the findings and any Known gaps entry written here were AI-drafted and need review before they are treated as authoritative.

## Reviewing a spec

A spec is read by one fresh agent in two passes, each through one lens: the business analyst first, then the tech lead. It is read against what the repository has already decided, not against code conventions, so the conventions and libraries axes do not apply.

The order is the point. The business analyst pass is written out in full before any code, ADR or architecture is opened: a model that has read the code judges the spec by how the code works, and nothing read can be taken back out of its context. The tech lead pass comes after, reads what it needs, and does not revise the first list.

Start the agent, a subagent where the host offers one. Give it the spec's path, the blocks from [Both lenses](#both-lenses) to [Tech lead lens](#tech-lead-lens) in that order, and the resolved path of [`decision-records.md`](../_pdlc-shared/decision-records.md), because an excerpt of this file carries no base directory for a relative link — nothing else: not the request, not the conversation, not a summary of the spec. It reads and reports; it edits nothing and runs nothing.

Where the host cannot start an agent, a session that wrote or discussed the spec says so and asks the user to run this review in a new session. A session with no memory of the spec makes the two passes itself, in the same order.

### Both lenses

Read the spec in full. Name at the start which of your sources the repository does not have, such as an empty `adr/`.

A difference from `PRODUCT.md`, another spec or the code that the spec announces as a change — new behavior, or the supersession of a decision — is not a finding. A spec with no Behavior section, or one that is empty or unnumbered, is reported as such, and no lines are written for it. Whether the feature should exist is not yours to judge: the user settled it before the spec was written.

Each finding fits on one line: the place it cites — a Behavior line, a decision or a section — what is wrong, and what the correction would be. Number the findings. Each carries a grade:

- **Blocking** — you recommend against approving the spec in this state.
- **To fix** — it should change, and the change can wait for a decision.
- **Detail** — it is worth one line and nothing more.

And a kind:

- **Wording fix** — a correction to the text, written out.
- **Open question** — a choice the spec leaves open, for the user to make.
- **Other** — named: an ADR to write, a contradiction with another spec.

A finding is a recommendation, and the grade is the weight you recommend. State no verdict on the spec: the user decides. If you find nothing, say "no findings" and name the sources you read.

### Business analyst lens

This is the first pass. Read the spec, `{docs_root}/PRODUCT.md`, and the other specs that cover the same ground: collect every spec's `Covers` line with one search for `^> Covers:`, search the specs for this one's domain terms, and open those that turn up. Read no code, no ADR and no architecture until this pass is written out, so that how the system happens to work does not lead you. A finding of this pass cites none of them.

Stay on the functional side: what the feature does for its user, and whether that is complete and clearly worded. Do not judge how it is built; a doubt about that is reported as a recommendation like any other. Ask:

- Does the spec state what the user sees and can do, with the empty and error states?
- Is each rule complete, with no case left to guess?
- Does a word allow two readings?
- Is a functional decision implied and not written?
- Does a non-goal contradict a behavior or a decision?
- Does anything contradict `PRODUCT.md` or another spec, beyond what the spec announces as a change?

### Tech lead lens

This is the second pass, made once the first is written out; leave the first list as it stands. Read the Architecture section of `AGENTS.md`, the ADRs under `{docs_root}/adr/`, `decision-records.md` at the path you were given, and the code the spec touches. Find that code from the spec's prose and from the architecture, because a spec lists no files. A spec for new behavior has no code yet: check it against the structures it would extend, and say so if it names none.

Take the functional behavior as given, and do not re-judge the functional choices; a functional doubt is reported as such, as a recommendation. Open this pass with one line: whether the functional behavior can be built in the solution as it stands, or needs a structural change, naming the structure that would change — or that the spec names no existing structure. Then ask:

- Does it fit the architecture and contradict no ADR?
- Is each Behavior line a result a test can assert from outside?
- Is a structural decision hidden, or does a decision pass the ADR tests in `decision-records.md` and so call for an ADR?
- Does the spec disagree with what the code does today, beyond what it announces as a change?

### The report

Relay the two lists one after the other, the business analyst's first, the numbering running on across both, each finding tagged with its lens and kept as returned. Drop, regrade, reword or merge none: deciding that two findings are one point rewrites them. Where a finding cites the same place in the spec as an earlier one, add "same place as N" — a match on the citation, never on a reading of the two sentences.

Where the lenses diverge, show both at equal weight. Prefer neither, mark neither as right, and offer no tie-break. State no verdict: a blocking finding does not stop the go-ahead, and the user can apply, decline or ignore any finding.

Name the sources each pass lacked, and say that the conventions and libraries axes were skipped. An agent that fails, or returns one pass without the other, is reported as such, the review is not presented as done, and a rerun is offered. A pass that finds nothing is reported as "no findings", with its lens and the sources it read.

### After the spec review

Ask which findings to apply, and edit nothing before the answer.

- **A selected wording fix** is applied to the spec.
- **A selected open question** is put to the user, and this skill settles nothing. The answer is written into the spec as a decision, with the rejected options if the user gave them.
- **A selected finding of another kind** is referred, and nothing is written: an ADR to [`a-pdlc-decide`](../a-pdlc-decide/SKILL.md), a contradiction with another spec to the user.

Edit no file other than the reviewed spec. A spec has no code to change and no test to fail, so a spec review reads no `build-loop.md`, runs no git or repository command, and commits nothing. In the `a-pdlc-feature` flow, the revised draft is committed at that skill's step 5, after the go-ahead on it.

A declined finding graded blocking or to fix, and an open question the user does not answer, go into the spec's Known gaps, with a condition you propose and the user can correct. A declined detail leaves nothing.

Close by stating what was applied, what went to Known gaps, and which open questions remain. Remind the user that the findings and anything written into the spec were AI-drafted and need review before they are treated as authoritative.
