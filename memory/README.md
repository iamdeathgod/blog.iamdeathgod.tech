# Memory Directory Structure

This directory holds the long-term memory and project state for the OpenClaw agent.

## Layout

```
memory/
├─ projects/
│  ├─ blog-site/
│  │  ├─ state.json                # current project status, commits
│  │  ├─ specs/
│  │  │   └─ design-system.md      # colors, typography, components
│  │  ├─ content-plan/
│  │  │   └─ calendar.json         # editorial calendar, post queue
│  │  └─ assets/                   # images, icons for blog
│  └─ notion-templates/
│     ├─ gaming-hq/
│     │  ├─ schema.json            # database structure
│     │  └─ version-history.md
│     ├─ anime-vault/
│     │  ├─ schema.json
│     │  └─ version-history.md
│     └─ creator-dashboard/
│        ├─ schema.json
│        └─ version-history.md
└─ shared/
   ├─ research-briefs/
   │   └─ (topic-specific JSON briefs)
   ├─ git-state.json               # last SHAs, remotes, credentials
   ├─ todo-list.json               # user tasks, deadlines
   └─ decisions-log.md             # architectural decisions over time

├─ YYYY-MM-DD.md                   # daily logs (raw)
└─ MEMORY.md                       # curated long-term memory
```

## Usage

- Agents read/write to these files to coordinate
- Do not edit `state.json` manually; agents own it
- Human may edit `decisions-log.md` and `todo-list.json` directly
- `MEMORY.md` updated periodically from daily logs
