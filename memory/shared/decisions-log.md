# Decisions Log

## 2026-03-11

### Newsletter Provider Selection
- **Issue:** Beehiiv RSS-to-email automation locked behind paid plan
- **Decision:** Pause newsletter integration; switch evaluation to MailerLite (free tier, RSS automation available)
- **Status:** DNS setup in progress; newsletter sections temporarily removed from site

### Gumroad Links Fix
- **Issue:** Product-specific links (`/l/gamingnotion`, `/l/anime-watchlist-notion`) 404 because products not created
- **Decision:** Point all CTAs to Gumroad store root (`iamdeathgod.gumroad.com`) until products are uploaded
- **Impact:** Eliminates 4xx errors from Cloudflare analytics

### RSS Feed Architecture
- **Decision:** Generate static `feed.xml` via Node script (`generate-feed.js`) from post HTML files
- **Rationale:** No CMS; pure static site; feed regenerated on demand or during publish workflow
- **TODO:** Integrate into heartbeat/publish flow

### Multi-Agent Hive Mind Design
- **Decision:** Formalize agent roles (Orchestrator, Researcher, Writer, Developer, DevOps, QA, Notion Builder)
- **Communication:** Shared memory bus under `memory/` with project state files
- **Next:** Implement first automated workflow (e.g., research → write → publish)

## 2026-03-10

### Blog Post Topic (March 11)
- **Chosen:** "How to Build a Notion Anime Watchlist That Actually Helps You Keep Up"
- **Reasoning:** March 2026 stacked anime season; aligns with audience (gamers who watch anime); promotes Anime Watchlist template ($3)
- **Outcome:** Published 2026-03-11

### Environment Update
- **Note:** User's OpenClaw running on native Ubuntu (not WSL as previously recorded)
- **Updated:** MEMORY.md to reflect native Ubuntu

## 2026-03-08

### First Blog Launch
- **Tech:** Pure HTML/CSS/JS static site, GitHub Pages
- **Design:** Custom dark theme, Space Grotesk font, purple/cyan accents
- **Deployed:** blog.iamdeathgod.tech via CNAME
