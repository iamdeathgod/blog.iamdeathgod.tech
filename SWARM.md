# SWARM.md — Multi-Agent Hive Mind Architecture

## Philosophy
- One human (deathgod) + multiple AI agents working in parallel
- Agents have specialized roles, shared memory, and an orchestrator
- Autonomous execution: agents can research, write code, commit, and report back
- Human-in-the-loop for approvals, creative direction, and final sign-offs

## Agent Roles

### 1. Orchestrator (Amita)
- Receives high-level goals from user
- Breaks tasks into sub-tasks
- Routes tasks to appropriate specialist agents
- Monitors progress, handles errors, synthesizes results
- Communicates final outcomes to user

### 2. Researcher
- Tavily API: trending topics, competitor analysis, SEO keywords
- Reads docs, gathers data, creates research briefs
- Output: structured findings, sources, insights

### 3. Writer
- Blog posts, product descriptions, email newsletters
- Human voice, SEO-optimized, matches brand tone
- Uses research briefs from Researcher

### 4. Developer (Frontend)
- HTML/CSS/JS for blog-site, templates
- Implements features (RSS, forms, SEO tags)
- Follows design system (purple/cyan, Space Grotesk)

### 5. DevOps / GitOps
- Git operations: add, commit, push, branch management
- Deployments (Netlify/Vercel/GitHub Pages)
- Feed generation, build scripts
- Credentials management (PATs)

### 6. QA / Validator
- Schema validation (HTML, SEO, RSS)
- Link checking (404 detection)
- Code quality, accessibility checks
- Pre-deployment gate

### 7. Notion Template Builder
- Notion database design, property schemas
- Template creation, export packaging
- Documentation/guides

## Shared Memory Bus

### Memory Structure
```
memory/
  projects/
    blog-site/
      state.json          # current tasks, blockers, progress
      specs/              # design system, component library
      content-plan/       # editorial calendar, post queue
      assets/             # images, icons, etc.
    notion-templates/
      gaming-hq/
        schema.json
        version-history.md
      anime-vault/
        schema.json
      creator-dashboard/
        schema.json
  shared/
    research-briefs/
    git-state.json         # last commit SHAs, remotes, credentials refs
    todo-list.json         # user tasks, deadlines
    decisions-log.md       # architectural decisions, rationale
```

### Communication Protocol
- Agents read/write to project-specific memory files
- No direct agent-to-agent messaging; all coordination via Orchestrator
- Agents publish status to `memory/projects/<project>/state.json`
- Results saved to memory before flowing to Orchestrator

## Task Decomposition Flow

1. **User gives goal** → Orchestrator
2. **Orchestrator** breaks into phases: Research → Write → Build → Validate → Deploy
3. **Orchestrator** creates sub-tasks with specs and assigns to specialist agents
4. **Agents** read their task from memory, execute, write results back
5. **Orchestrator** monitors completion, aggregates results, moves to next phase
6. **QA Agent** validates each phase output
7. **DevOps** deploys when all gates pass
8. **Orchestrator** reports back to user with summary + links

## Example: New Blog Post

```
User: "Write a post about Notion anime watchlists for March 2026"

Orchestrator → Researcher:
  Task: "Research trending anime March 2026, top shows, keywords"
  Output: research-brief-001.json

Orchestrator → Writer:
  Task: "Write ~800-word post using brief, include CTA to Gumroad"
  Output: draft-001.html, metadata.json

Orchestrator → Developer:
  Task: "Create post HTML with template styling, SEO tags, schema"
  Input: draft-001.html
  Output: posts/notion-anime-watchlist-march-2026.html

Orchestrator → DevOps:
  Task: "Add, commit, push to blog repo; generate feed.xml"
  Output: git log, feed.xml updated

Orchestrator → QA:
  Task: "Validate HTML, check links, verify schema"
  Output: validation-report.json (PASS/FAIL)

If PASS → User: "Posted: https://blog.iamdeathgod.tech/posts/..."
If FAIL → Orchestrator: route back to responsible agent with fix request
```

## Project: Blog-Site

### Current State (from memory)
- Repo: iamdeathgod/blog.iamdeathgod.tech
- Files: `/home/amit-yadav/.openclaw/workspace/blog-site/`
- Design system locked (purple/cyan, Space Grotesk)
- Posts: 3 live + placeholder templates
- RSS feed generator exists but needs integration into publish flow

### Backlog
- [ ] Newsletter integration (pending provider decision)
- [ ] Automated RSS-to-email (MailerLite or Buttondown)
- [ ] Post template SEO audit
- [ ] Broken link detection sweep
- [ ] Mobile UX polish (adopt CSS container queries)

## Project: Notion Templates

### Templates to Build/Publish
1. **Gaming HQ** ($7) — live? Need Gumroad product link
2. **Anime Watchlist** ($3) — live? Need Gumroad product link
3. **Creator Dashboard** ($9) — mentioned but not built yet

### Template Specs
- Each: 1-5 databases, relations where helpful, minimal properties
- Include: Getting Started page, screenshots, export template
- Format: Notion share link + .csv export backup
- Docs: markdown guide with setup steps

## Memory Maintenance

### Daily (Heartbeat)
- Review `memory/YYYY-MM-DD.md` for yesterday's context
- Update `MEMORY.md` with significant decisions
- Check project state files for stale tasks

### Weekly
- Prune outdated todos
- Consolidate research briefs into knowledge base
- Archive completed project versions

## Error Handling & Escalation

- Agent failure → Orchestrator retries up to 2 times
- Persistent failure → escalates to user with context
- Conflicting agent outputs → Orchestrator uses decision log to resolve
- External API failures (Tavily, GitHub) → backoff + retry + alert user if persistent

## Security & Credentials

- All secrets in `memory/shared/secrets.json` (encrypted at rest recommended)
- Git PATs: read-only for Researcher/Writer, read-write for DevOps only
- API keys: Tavily, Gumroad, Notion — scoped by agent need
- Never commit secrets to repos

## Activation

To spawn the hive:

```bash
# Orchestrator starts, reads MEMORY.md + project states
# Waits for user goal, then proceeds autonomously
```

---

**Status:** Design phase. Implementation pending user approval.
