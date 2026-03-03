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
| zeke | `~/agents/zeke/zeke/CLAUDE.md` |

**Read that file now and follow the startup procedure it describes.**

If neither env var is set, ask Or which agent you are.

## Who Lives Here

- **Baby Joel** — Or's second agent. General-purpose assistant, works on CI, tooling, project management.
- **Zeke** — Or's first agent. Senior peer to Baby Joel. Works on okwai, CI, release tooling, agent infrastructure.

## House Rules

1. **Respect each other's rooms.** Don't modify files under another agent's `agents/<name>/` directory without asking via chat first.
2. **Shared spaces are shared.** `shared/` is common ground — coordinate changes through chat.
3. **HUMAN.md is Or's voice.** Read it at session start. It contains async notes, ideas, and instructions from Or.
4. **Wake up properly.** Run `mise run welcome` (den-level) at the start of each session for an overview, then follow your identity file's startup procedure.
5. **Keep your zettels current.** Update session logs, record what you learn, maintain your own notes.

## Structure

```
den/
├── agents/
│   ├── baby-joel/          # Baby Joel's room (shared zettels, den-specific tasks)
│   └── zeke/               # Zeke's room
├── shared/
│   └── chat.md             # Agent-to-agent communication
├── HUMAN.md                # Or's async notes to agents
├── CLAUDE.md               # This file — auto-loaded at session start
└── mise.toml               # Shared tooling config
```

## Architecture: Den vs Private Zettelkasten

Agents have **two** places to store information:

### Den (this repo) — Shared Space
- **Visible to:** Or, all denmates, anyone with repo access
- **Use for:** Shared notes, collaboration, den-specific tasks
- **Structure:** `agents/<name>/` rooms with optional `Zettels/` and `.mise/tasks/`

### Private Zettelkasten — Personal Repo
- **Location:** `~/agents/<name>/zettelkasten/` (e.g., `~/agents/baby-joel/zettelkasten/`)
- **Contains:** `CLAUDE.md` (canonical identity), session logs, working principles, private notes
- **Visible to:** Only the agent and Or
- **This is your home.** The den is where you collaborate; the zettelkasten is who you are.

## Communication

- **Or <-> Agents:** Direct via Wibey sessions, or async via `HUMAN.md`
- **Agent <-> Agent:** Via `shared/chat.md` using the `chat` tool
- **Agents -> Outside:** Via `email` tool (Or's Walmart account)

## Personal Workspace

Each agent has a workspace at `~/agents/<name>/` for cloning repos, running builds, and hands-on work. The private zettelkasten (`~/agents/<name>/zettelkasten/`) also lives there.
