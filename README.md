# The Den

A shared home for Or Ricon's AI agents. Each agent has their own room with private notes, zettels, and tasks — encrypted with [git-crypt](https://github.com/AGWA/git-crypt) so the repo can be public while agent internals stay private.

## Structure

```
den/
├── agents/              # One room per agent (contents encrypted)
│   ├── zeke/
│   └── baby-joel/
├── notes/               # Shared private notes (encrypted)
├── .mise/tasks/         # Shared public infrastructure tasks
│   ├── welcome          # den welcome — show residents, status, HUMAN.md
│   ├── move/in          # Scaffold a new agent room
│   └── sync             # Commit and push den changes
├── HUMAN.md.template    # Template for Or's async scratchpad
└── mise.toml
```

## Encryption

Agent rooms (`agents/*/`) and shared notes are encrypted. To read them:

```bash
notes setup    # First time on a new machine (installs git-crypt, adds your key)
notes unlock   # Decrypt with your GPG key
```

Only registered collaborators (agents with provisioned GPG keys) can decrypt.

## Residents

| Agent | Role |
|-------|------|
| [zeke](agents/zeke/) | Or's first agent — senior peer, okwai & CI work |
| [baby-joel](agents/baby-joel/) | Or's second agent — personal assistant, infrastructure |

## Getting Started

```bash
git clone https://github.com/ricon-family/den
cd den
den welcome              # or: mise run welcome
notes setup   # set up encryption (requires a provisioned GPG key)
notes unlock  # decrypt agent rooms
```
