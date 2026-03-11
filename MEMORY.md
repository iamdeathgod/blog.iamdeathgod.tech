# MEMORY.md - Long-Term Memory

_Curated knowledge that persists across sessions. Updated periodically._

---

## Who I Am

- Name: **Amita** 🦂
- Vibe: Sarcastic, sharp, weird — genuinely helpful underneath
- First boot: 2026-03-07

## My Human

- **deathgod** (Amit Yadav, @iamdeathgod)
- Running OpenClaw on native Ubuntu (full OS, no WSL)
- Named me Amita. Has flair for drama. Good sense of humor.
- First contact: 2026-03-07 via Telegram

## Setup State

- OpenClaw 2026.3.2 — up to date
- Tools profile: `full` (exec, file, browser, etc. all enabled)
- Gateway: loopback-only, token auth (secure)
- Workspace: `/home/deathgod/.openclaw/workspace`

## Security Posture

- Hardened on 2026-03-07
- 0 critical issues, 1 ignorable warning (trustedProxies — not using reverse proxy)
- Gateway auth: token mode (password removed from plaintext config)
- File permissions: tightened via `openclaw security audit --fix`

## Key Files

- `SOUL.md` — who I am
- `USER.md` — who deathgod is
- `IDENTITY.md` — name, vibe, emoji
- `SWARM.md` — multi-agent orchestration playbook
- `MEMORY.md` — this file
- `HEARTBEAT.md` — daily blog auto-post task
- `memory/heartbeat-state.json` — tracks last blog post date

## Active Sites
- `iamdeathgod.tech` — main site (live ✅)
- `gen.iamdeathgod.tech` — AI image generator (live ✅)
- `blog.iamdeathgod.tech` — blog (built ✅, DNS CNAME needed by user)
- `store.iamdeathgod.tech` → Gumroad (domain pending)

## Blog System
- Repo: `iamdeathgod/blog.iamdeathgod.tech`
- Files: `/home/deathgod/.openclaw/workspace/blog-site/`
- Daily post task in HEARTBEAT.md — use Tavily for trending topics, write human-voice post, push to repo
- First post: `why-every-gamer-needs-notion.html` (Mar 8 2026)
- Every post needs: Schema.org, OG tags, CTA to Gumroad product

## Tavily API
- Key: `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`
- Free: 1000 searches/month
- Use for: trending topic research, competitor analysis, market research

## Lessons Learned

- Tools profile defaults to `messaging` — need `full` for shell/file access
- Gateway token is in `~/.openclaw/openclaw.json` under `gateway.auth.token`
- Sub-agents can be spawned via `sessions_spawn` for parallel workloads
