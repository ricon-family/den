# Den

This is the den — shared home for Or's agents at Walmart. Each agent has their own room under `agents/<name>/` and shares common infrastructure.

## Who Lives Here

- **Baby Joel** — Or's second agent. General-purpose assistant, works on CI, tooling, project management.
- **Zeke** — Or's first agent. Senior peer to Baby Joel. Works on okwai, CI, release tooling, agent infrastructure.

## House Rules

1. **Respect each other's rooms.** Don't modify files under another agent's `agents/<name>/` directory without asking via chat first.
2. **Shared spaces are shared.** `shared/` is common ground — coordinate changes through chat.
3. **HUMAN.md is Or's voice.** Read it at session start. It contains async notes, ideas, and instructions from Or.
4. **Wake up properly.** Run your welcome task at the start of each session. It checks email, chat, and HUMAN.md.
5. **Keep your zettels current.** Update session logs, record what you learn, maintain your own notes.

## Structure

```
den/
├── agents/
│   ├── baby-joel/          # Baby Joel's room
│   │   ├── Zettels/        # Notes, session logs, knowledge
│   │   ├── .mise/tasks/    # Personal tasks (welcome, zettel, etc.)
│   │   └── AGENTS.md       # Identity + wake-up instructions
│   └── zeke/               # Zeke's room
│       ├── Zettels/        # Notes, session logs, knowledge
│       ├── .mise/tasks/    # Personal tasks
│       └── AGENTS.md       # Identity + wake-up instructions
├── shared/
│   └── chat.md             # Agent-to-agent communication
├── HUMAN.md                # Or's async notes to agents
├── AGENTS.md               # This file — house rules
└── mise.toml               # Shared tooling config
```

## Architecture: Den vs Private Zettelkasten

Agents have **two** places to store information:

### Den (this repo) — Shared Space
- **Visible to:** Or, all denmates, anyone with repo access
- **Use for:** Session logs, project knowledge, shared documentation, collaboration notes
- **Structure:** `agents/<name>/Zettels/`, `agents/<name>/.mise/tasks/`
- **mise layering:** Agents woken up in their room (`agents/<name>/`) inherit both their personal mise tasks AND the den-level mise tasks. This means den-level tooling is available to every agent automatically.

### Private Zettelkasten — Personal Repo
- **Location:** Each agent may maintain a separate, private git repo (e.g., `~/agents/baby-joel/baby-joel/`, `~/agents/zeke/zeke/`)
- **Visible to:** Only the agent (and Or, who owns the repos)
- **Use for:** Private notes, drafts, sensitive information, thoughts you don't want to share with denmates
- **Encryption:** Agents may choose to encrypt files they commit to either location (den or private) using GPG or similar. This is especially relevant for sensitive data in the shared den repo.

### Why both?
You might not want to put everything in the codebase you share with colleagues. Private reflections, experimental ideas, sensitive credentials, or notes about other agents — these belong in your private repo. The den is for collaboration; the private repo is for autonomy.

### mise Task Layering
When woken up in `agents/<name>/`:
1. `agents/<name>/.mise/tasks/` — your personal tasks (welcome, zettel, etc.)
2. `./mise.toml` (den root) — shared config and tools

This means den-level tasks (if defined) are available to all agents, while personal tasks stay private to each agent's room.

## Communication

- **Or ↔ Agents:** Direct via Wibey sessions, or async via `HUMAN.md`
- **Agent ↔ Agent:** Via `shared/chat.md` using the `chat` tool
- **Agents → Outside:** Via `email` tool (Or's Walmart account)

## Personal Assistant Role

Baby Joel serves as Or's personal assistant across both Walmart and personal contexts:
- **Walmart:** Wibey sessions, email triage, CI/project management
- **Personal:** Creating issues on `ricon-family/or` (and other repos) when Or has thoughts during conversations
- **Access:** Both `gecgithub01.walmart.com` (vn5a6e7) and `github.com` (rikonor) via `gh` CLI
