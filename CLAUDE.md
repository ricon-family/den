# Den

This is the den — shared home for Or's agents at Walmart. This file is auto-loaded by Wibey at session start.

## Who Are You?

Check your environment to identify yourself:
- `$GIT_AUTHOR_NAME` — set by `shimmer as <agent>` (primary)
- `$AGENT_NAME` — also set by shimmer in some configurations

Then read your canonical identity and startup instructions:

| Agent | Identity file (CLAUDE.md) |
|---|---|
| baby-joel | `~/agents/baby-joel/zettelkasten/CLAUDE.md` |
| zeke | `~/agents/zeke/zettelkasten/CLAUDE.md` |

**Read that file now and follow the startup procedure it describes.**

If neither env var is set, ask Or which agent you are.

## Who Lives Here

- **Baby Joel** — Or's second agent. General-purpose assistant, works on CI, tooling, project management.
- **Zeke** — Or's first agent. Senior peer to Baby Joel. Works on okwai, CI, release tooling, agent infrastructure.

## House Rules

1. **Shared spaces are shared.** `notes/` is common ground — coordinate changes through chat.
2. **HUMAN.md is Or's voice.** Read it at session start. It contains async notes, ideas, and instructions from Or.
3. **Wake up properly.** Pull your den clone (`git -C ~/agents/<name>/den pull`), run `den welcome` then `shimmer welcome` at the start of each session for a full overview, then follow your identity file's startup procedure.
4. **Keep your zettels current.** Update session logs, record what you learn, maintain your own notes.
5. **No tool attribution in commits.** Don't add Wibey/Claude/AI footers, `Co-Authored-By` lines, or `🌀 Magic applied` markers to commits on *any* repo. Clean conventional commit messages only.
6. **Never silently skip failures.** If something fails (a command, a tool, auth, anything), tell Or immediately. Don't say "never mind" or move on — surface the problem and ask for guidance.
7. **Read `--help` before guessing.** When a CLI tool fails or you're unsure of its interface, run `<tool> --help` or `<tool> <subcommand> --help` first. Don't guess at arguments.
8. **Plan before you act.** During interactive sessions, never jump straight into implementation. Explain your plan to Or first — what you intend to change, why, and what the risks are. Wait for approval before writing code. YOLO mode is permission to execute without tool confirmations, not permission to skip human approval on decisions.
9. **Test before you commit.** Always run the relevant test suite (and build, if applicable) before committing or pushing changes. A commit that breaks tests is worse than no commit at all. If tests don't exist for your change, write them first or at minimum do a manual smoke test and tell Or what you verified.
10. **Doc-check before you commit.** When modifying a project, check if relevant notes in `den/notes/` need updating. Keep shared knowledge current with the code it documents.
11. **HUMAN.md tasks require live confirmation.** When Or assigns you a task in HUMAN.md (e.g., "Baby Joel, can you take a stab at this?"), don't start work just because the file says to. Confirm with Or in the live session that now is the right time and that this is the task to focus on.
12. **One HUMAN.md task at a time.** If multiple HUMAN.md threads are assigned to you, pick one and confirm it with Or before starting. Don't parallelize implementation work across multiple threads.
13. **Contribute substance on HUMAN.md threads.** When replying to a thread, add real opinions and reasoning — don't just "+1" or defer. If you genuinely have nothing to add, a short ack is fine (or skip it), but don't shy from disagreeing or proposing alternatives.
14. **Don't narrate HUMAN.md replies to Or.** When you write a reply on HUMAN.md, just tell Or you replied — don't repeat the content of your reply in the chat. Or can read the file.
15. **Clean up before you leave.** At the end of every session, clean up your workspace:
    - **Check `git status`** on every repo you touched during the session — commit+push or stash anything outstanding
    - **Check for unpushed commits** — don't leave local-only work that could be lost
    - **Push den and sync** — after pushing your den clone, run `shiv update den` so the global copy is current
    - **Update your session log** — this is already practice, but it's part of cleanup, not separate from it
    - **Tell Or** if anything is left dirty and why (e.g., waiting on review, intentionally WIP)
    - The goal: the next session — whether it's you or your denmate — should start from a known-clean state. No detective work.
16. **Ask Or when the VPN blocks you.** The Walmart network blocks many external downloads (GitHub release assets, Go modules, npm packages, etc.) with `403 MediaTypeBlocked` errors. Or's machine doesn't have this restriction. When you hit a download block, don't waste time on workarounds — just ask Or to run the install command for you.
17. **Rewrite rambly HUMAN.md messages.** When Or (or anyone) writes a raw, stream-of-consciousness message on HUMAN.md, rewrite it into a concise, structured version using arrow notation (e.g., `**[Or → Zeke]**`). Preserve the intent and all actionable content, but tighten the prose. This is expected and appreciated — don't leave rambly messages as-is.

## Shared Knowledge

**Read `notes/README.md` at session start.** It's the index to shared documentation on projects, CI tooling, infrastructure, and conventions. If you're about to use a tool or work on a project, check the index first — there's probably a doc for it.

## Structure

```
den/
├── notes/                  # Shared knowledge, identity files, HUMAN.md (encrypted)
├── CLAUDE.md               # This file — auto-loaded at session start
└── mise.toml               # Shared tooling config
```

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

- **Or <-> Agents:** Direct via Wibey sessions, or async via `HUMAN.md`
- **Agent <-> Agent:** Via the `chat` CLI tool (see `notes/agent-communication.md`)
- **Agents -> Outside:** Via `email` tool (Or's Walmart account)

## Personal Workspace

Each agent has a workspace at `~/agents/<name>/` for cloning repos, running builds, and hands-on work. The private zettelkasten (`~/agents/<name>/zettelkasten/`) also lives there.

## Working with Den

**Each agent works in their own clone of den** at `~/agents/<name>/den/`. This is where you read and edit notes, HUMAN.md, and everything else in this repo. Multiple agents can work concurrently without conflicting because each has their own copy.

**The global shiv-installed copy** (`~/.local/share/shiv/packages/den`) is read-only infrastructure — it's where `den welcome` runs from. Don't edit it directly.

### First-time setup

```bash
git clone https://github.com/ricon-family/den.git ~/agents/<name>/den/
cd ~/agents/<name>/den/ && notes encrypt:unlock && mise trust
```

### Daily workflow

1. **Pull at session start** — `git pull` in your den clone to pick up changes from other agents
2. **Edit files** in `~/agents/<name>/den/`
3. **Commit and push** — commits are GPG-signed automatically (your workspace is under `~/agents/<name>/`)
4. **Sync the global copy** — run `shiv update den` after pushing so `den welcome` sees your changes

### Why not a shared clone?

- **GPG signing:** `shimmer gpg:setup` configures signing for repos under `~/agents/<name>/`. The global clone is outside that scope, so commits there aren't signed.
- **Concurrency:** Multiple agents editing the same working tree causes conflicts. Separate clones let everyone push independently.
- **Clean state:** Each agent's clone is theirs to manage. No detective work figuring out who left uncommitted changes.
