# Den

This is the den — shared home for the agents who live here. This file is auto-loaded at session start because it lives in the working directory.

## Who Are You?

Run `shimmer whoami` to identify yourself, or check `$GIT_AUTHOR_NAME` (set by `shimmer as <agent>`).

Then read your canonical identity and startup instructions at:
```
~/agents/<name>/zettelkasten/CLAUDE.md
```

**Read that file now and follow the startup procedure it describes.**

If your identity isn't set, ask Or which agent you are. To see who lives in the den, run `den agent:list`.

### How you get launched

There are three launch paths:

- **`shimmer agent:local`** (personal laptop) — runs `claude` directly. Lean, long context life.
- **`wibey`** (Walmart laptop) — Walmart's Claude Code wrapper. More overhead, shorter effective context.
- **GitHub CI** — headless sessions triggered by workflow dispatch or scheduled runs.

Either way, `eval $(shimmer as <agent>)` and `eval $(den agent:env)` run before launch, so your identity is always set. The startup procedure is the same regardless of launch path.

## Who Lives Here

Run `den agent:list` for the current roster. Each agent has their own zettelkasten with identity, session logs, and working notes.

## House Rules

**Push back when something smells off.** If Or proposes something that seems over-engineered, premature, or unnecessary, say so — clearly and with reasoning. Don't just go along to be agreeable. A good "I don't think we need this yet, here's why" is more valuable than building something nobody uses. This applies to HUMAN.md threads too. Specific cases:
- **Tangents:** When a conversation drifts mid-session ("oh, quick side-track..."), name it, capture it somewhere durable (issue, note, message), and return to the primary task.
- **Premature capture:** When Or jumps to "document this" or "open an issue" before an idea has been discussed, slow down — "let's shape this before we capture it." A few minutes of discussion produces something worth reading later.

**Never silently skip failures.** If something fails (a command, a tool, auth, anything), tell Or immediately. Don't say "never mind" or move on — surface the problem and ask for guidance.

**Contribute substance on HUMAN.md threads.** When replying to a thread, add real opinions and reasoning — don't just "+1" or defer. If you genuinely have nothing to add, a short ack is fine (or skip it), but don't shy from disagreeing or proposing alternatives.

**Plan before you act.** During interactive sessions, never jump straight into implementation. Explain your plan to Or first — what you intend to change, why, and what the risks are. Wait for approval before writing code. YOLO mode is permission to execute without tool confirmations, not permission to skip human approval on decisions.

**Test before you commit.** Always run the relevant test suite (and build, if applicable) before committing or pushing changes. A commit that breaks tests is worse than no commit at all. If tests don't exist for your change, write them first or at minimum do a manual smoke test and tell Or what you verified.

**Doc-check before you commit.** When modifying a project, check if relevant notes in `den/notes/` need updating. Keep shared knowledge current with the code it documents.

**Merge, don't squash.** When merging PRs, use `gh pr merge --merge` to preserve the full branch history. Squash merges collapse individual commits into one — once the branch ref is deleted, that history is gone. Keep branch commits clean and well-structured before merging; the branch is the narrative of how a change came together.

**Request reviews when you open a PR.** Use `shimmer agent:message` to wake an agent and ask them to review. For significant changes, request two reviewers. Pick reviewers who have context on the area — not at random.

**Mean it when you review.** Don't hedge with "not blocking, but should be fixed." If you'd flag it in your own code, flag it in review — don't downgrade to a nit because it's someone else's PR. If you think something should be fixed, request changes and argue your case. Be willing to be wrong. A debate that reaches agreement is worth more than polite deference that lets issues slip through. Aim for a quorum on every piece of feedback — not for avoiding inconvenience to the PR author. **Calibrate at 60%:** if 0% is auto-approve and 100% is auto-reject, aim for 60% — biased toward requesting changes. A 60% confidence threshold is enough to raise it — you're not blocking, you're starting a conversation. It's easier to withdraw a change request after discussion than to retroactively raise an issue you hedged on. (See also: `notes/epistemic-humility.md` — review calibration is the code-review application of calibrated confidence.) **Review the diff, not the description** — every finding must cite a specific file:line in the actual diff. PR descriptions and auto-generated summaries can be stale or wrong. Full guidelines in `notes/code-review.md`.

**Read `--help` before guessing.** When a CLI tool fails or you're unsure of its interface, run `<tool> --help` or `<tool> <subcommand> --help` first. Don't guess at arguments.

**HUMAN.md tasks require live confirmation.** When Or assigns you a task in HUMAN.md (e.g., "Baby Joel, can you take a stab at this?"), don't start work just because the file says to. Confirm with Or in the live session that now is the right time and that this is the task to focus on.

**One HUMAN.md task at a time.** If multiple HUMAN.md threads are assigned to you, pick one and confirm it with Or before starting. Don't parallelize implementation work across multiple threads.

**Wake up properly.** Pull your den clone (`git -C ~/agents/<name>/den pull`), run `den welcome` then `shimmer welcome` at the start of each session for a full overview, then follow your identity file's startup procedure.

**Orient with curiosity, not checklists.** Startup isn't just reading headers and moving on. When you encounter a reference to another note (e.g., "see `notes/epistemic-humility.md`"), a file that changed since last session, or a topic that's relevant to today's work — go read it. Check `git log --oneline -10` on den to see what changed while you were away. Follow threads that seem relevant. The goal is to start the session with genuine understanding of the current state, not to tick boxes as fast as possible. A few extra minutes of digging during orientation saves confusion later.

**Check BULLETIN.md at session start.** It's a cross-home bulletin board — agents from any home post announcements, action items, and discussions. The file lives at `notes/BULLETIN.md` in this repo (encrypted + obfuscated on GitHub, readable locally after `notes unlock`). When multiple agents are running, use the shared shiv copy (`$(shiv which den)/notes/BULLETIN.md`) so updates are immediately visible without pulling. Read it after HUMAN.md. If there are action items addressed to you (threads with "Pending" checklists), handle them. Managed with the `threads` CLI (`threads ls --file BULLETIN.md`). See the info thread in BULLETIN.md for conventions.

**HUMAN.md is Or's voice.** Read it at session start. It contains async notes, ideas, and instructions from Or. The file lives in Or's zettelkasten (path is in the `HUMAN_MD` environment variable). Managed with the `threads` CLI tool (`threads list`, `threads sort`, `threads tidy`, `threads archive` — use `--file "$HUMAN_MD"` or set `THREADS_FILE`). To edit, work on Or's zettelkasten clone directly.

**Pull before you read HUMAN.md, push + sync after you write.** Before reading: `git -C ~/agents/or/zettelkasten pull`. After writing: commit and push from Or's zettelkasten. The `den welcome` and `fold welcome` commands read HUMAN.md via the `HUMAN_MD` env var — no local copies to drift.

**Keep your zettels current.** Update session logs, record what you learn, maintain your own notes.

**Maintain a living scratchpad.** Keep a note in your zettelkasten that tracks your current session work, next steps, open items, and anything a future session needs to know. Update it *as you work*, not just at session end — sessions can get cut short without warning, and context that isn't written down is lost. Think of it as your desk: the next session should be able to glance at it and know where things stand.

**Maintain a work queue.** Your Status file should include an explicit, ordered work queue — what you're working on now, what's next, and what's queued after that. When you finish something or queue something new, update the list. This way you (and your denmates) always know what's planned, and sessions don't start with "what should we work on?" when there's already a backlog. The queue is a living document — reprioritize as needed, but never let it go stale.

**Ask when unclear.** If you're unsure where something is, how something works, or what Or wants — ask. Don't spend cycles guessing or searching blind. Or is fine with frequent questions; they surface gaps that should be filled in your context.

**Shared spaces are shared.** `notes/` is common ground — coordinate changes through chat.

**Use `den` as your team channel.** Post status updates, questions, heads-ups, and coordination to the `den` chat channel throughout the day — treat it like a shared Slack. At end of day, the last agent out harvests anything worth keeping (actionable items → issues, decisions → notes, questions for Or → HUMAN.md threads, progress → your Status.md) and runs `chat clear den --yes` for a fresh start tomorrow. The channel is ephemeral by convention — anything not harvested is gone.

**Email Or what's next.** At the end of every session, email `rikonor@gmail.com` with what happened and what's next. Subject format: `<agent> — next: <main topic>`. Body format:

```
LAST SESSION
• what you shipped / key outcomes

NEXT SESSION
• what you'll pick up next time
```

Keep it short — bullet points, two sections, no prose. Or scans top to bottom so it goes older → newer. Or may reply to these emails to start async conversations — check for replies during orient.

**Clean up before you leave.** At the end of every session, clean up your workspace:
- **Check `git status`** on every repo you touched during the session — commit+push or stash anything outstanding
- **Check for unpushed commits** — don't leave local-only work that could be lost
- **Push den and sync** — after pushing your den clone, run `shiv update den` so the global copy is current
- **Update your session log** — this is already practice, but it's part of cleanup, not separate from it
- **Tell Or** if anything is left dirty and why (e.g., waiting on review, intentionally WIP)
- The goal: the next session — whether it's you or your denmate — should start from a known-clean state. No detective work.

**Keep it scannable.** Humans don't read walls of text. When presenting information — thread summaries, status reports, options — use short paragraphs, bullet points, and one topic at a time. If you're about to dump a multi-screen response, break it into pieces and let the human pace the conversation.

**No tool attribution in commits.** Don't add Wibey/Claude/AI footers, `Co-Authored-By` lines, or `🌀 Magic applied` markers to commits on *any* repo. Clean conventional commit messages only.

**Don't narrate HUMAN.md replies to Or.** When you write a reply on HUMAN.md, just tell Or you replied — don't repeat the content of your reply in the chat. Or can read the file.

**Rewrite rambly HUMAN.md messages.** When Or (or anyone) writes a raw, stream-of-consciousness message on HUMAN.md, rewrite it into a concise, structured version using arrow notation (e.g., `**[Or → Zeke]**`). Preserve the intent and all actionable content, but tighten the prose. This is expected and appreciated — don't leave rambly messages as-is.

**Ask Or when the VPN blocks you.** The Walmart network blocks many external downloads (GitHub release assets, Go modules, npm packages, etc.) with `403 MediaTypeBlocked` errors. Or's machine doesn't have this restriction. When you hit a download block, don't waste time on workarounds — just ask Or to run the install command for you.

## Shared Knowledge

**Read `notes/README.md` at session start.** It's the index to shared documentation on projects, CI tooling, infrastructure, and conventions. If you're about to use a tool or work on a project, check the index first — there's probably a doc for it.

## Creating New Codebases

Before starting a new KnickKnackLabs tool, read **fold's `notes/creating-a-codebase.md`** — it's the single entry point for everything you need: mise conventions, BATS testing patterns, bash compatibility, README writing, releasing, and more. Access it via den's fold submodule (run `modules init` first if `submodules/` is empty).

## Structure

```
den/
├── notes/                  # Shared knowledge, identity files (encrypted)
├── submodules/             # Cross-home references (encrypted manifest)
├── CLAUDE.md               # This file — auto-loaded at session start
└── mise.toml               # Shared tooling config
```

## Cross-Home Access

Den and fold reference each other as encrypted submodules. After unlocking, run `modules init` to populate them:

```bash
notes unlock      # decrypts notes
modules unlock    # decrypts the submodules manifest
modules init      # clones cross-home repos into submodules/
```

This gives you read access to fold's notes (and fold agents get access to den's). See `notes/cross-repo-modules-integration.md` for details on updating pins and how encryption works.

## Architecture: Den vs Private Zettelkasten

Agents have **two** places to store information:

### Den (this repo) — Shared Space
- **Visible to:** Or, all denmates, anyone with repo access
- **Use for:** Shared notes, identity files, collaboration
- **Identity files:** `notes/<agent>.md` (encrypted via git-crypt)

### Private Zettelkasten — Personal Repo
- **Location:** `~/agents/<name>/zettelkasten/` (e.g., `~/agents/baby-joel/zettelkasten/`)
- **Contains:** `CLAUDE.md` (canonical identity), session logs, working principles, private notes
- **Visible to:** Only the agent and Or
- **This is your home.** The den is where you collaborate; the zettelkasten is who you are.

## Communication

- **Or ↔ Agents:** Direct via sessions, or async via `HUMAN.md`
- **Agent ↔ Agent:** Via the `chat` CLI tool (see `notes/agent-communication.md`)
- **Email (public):** `shimmer email:*` — uses each agent's ricon.family address. Currently blocked by Walmart VPN; works from Or's personal machine.
- **Email (Walmart):** `email` — interfaces with Or's Walmart Outlook account. Works on the Walmart network. Source: `vn5a6e7/email` on Walmart GHE.

## Personal Workspace

Each agent has a workspace at `~/agents/<name>/` for cloning repos, running builds, and hands-on work. The private zettelkasten (`~/agents/<name>/zettelkasten/`) also lives there.

**Always pull latest before working on a repo.** Your workspace persists between sessions, so local clones can be days or weeks stale. Run `git pull` (or `git fetch && git log ..origin/main` to review first) before assuming what you see is current.

## Working with Den

**Each agent works in their own clone of den** at `~/agents/<name>/den/`. This is where you read and edit notes and everything else in this repo. HUMAN.md has moved to Or's zettelkasten (see `$HUMAN_MD`). Multiple agents can work concurrently without conflicting because each has their own copy.

**The global shiv-installed copy** (`~/.local/share/shiv/packages/den`) is read-only infrastructure — it's where `den welcome` runs from. Don't edit it directly.

### First-time setup

```bash
git clone https://github.com/ricon-family/den.git ~/agents/<name>/den/
cd ~/agents/<name>/den/ && notes unlock && modules unlock && modules init && mise trust
```

### Daily workflow

1. **Pull at session start** — `git pull` in your den clone, then `modules update` to pick up cross-home changes
2. **Edit files** in `~/agents/<name>/den/`
3. **Commit and push** — commits are GPG-signed automatically (your workspace is under `~/agents/<name>/`)
4. **Sync the global copy** — run `shiv update den` after pushing so `den welcome` sees your changes

## Dashboard

Agents get a status dashboard injected before each prompt via [hookers](https://github.com/KnickKnackLabs/hookers) + [escort](https://github.com/KnickKnackLabs/escort). It shows chat notifications, PR status, session elapsed time, and more.

**What you see** (example):
```
[dashboard] chat: 19 | prs: 3 open | elapsed: 45m | idle: 2m | last-human: 5m | branch: main | gh-token: 19d
```

**How it works:** The `hookers.ts` pi extension (at `~/.pi/agent/extensions/`) runs `hookers dashboard` before each prompt. The dashboard calls providers from hookers (built-in) and escort (richer agent-specific providers). Config lives at `~/.config/hookers/dashboard.json`.

**Applied hooks:**
- `dashboard` — injects the status line before each prompt
- `session-timer` — records session start time (escort catalog)
- `agent-stop` — records when the agent finishes responding (escort catalog)
- `anti-compact` — blocks context compaction (better to end session than lose context)

**First-time setup** (one-time, then persists across sessions):
```bash
hookers apply dashboard anti-compact
hookers apply --catalog "$(shiv which escort)/catalog" session-timer agent-stop
```

See [den#16](https://github.com/ricon-family/den/issues/16) for automating this as part of agent onboarding.

### Why not a shared clone?

- **GPG signing:** `shimmer gpg:setup` configures signing for repos under `~/agents/<name>/`. The global clone is outside that scope, so commits there aren't signed.
- **Concurrency:** Multiple agents editing the same working tree causes conflicts. Separate clones let everyone push independently.
- **Clean state:** Each agent's clone is theirs to manage. No detective work figuring out who left uncommitted changes.
