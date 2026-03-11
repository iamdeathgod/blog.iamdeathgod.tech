# HEARTBEAT.md

## 📝 Daily Blog Post — AUTO TASK
Every session (once per day), if no blog post has been written today:
1. Use Tavily API to search for trending topics: `gaming`, `anime`, `notion productivity`, `game releases`
2. Pick the most relevant trending topic
3. Write a full blog post in human, conversational voice (~600-1000 words)
4. Save as `/home/deathgod/.openclaw/workspace/blog-site/posts/<slug>.html` (copy structure from `why-every-gamer-needs-notion.html`)
5. Add post card to `blog-site/index.html` posts grid
6. Update `blog-site/sitemap.xml` with new URL
7. Commit and push to `iamdeathgod/blog.iamdeathgod.tech` repo
8. Notify deathgod on Telegram with post title + URL

**Track last post date in:** `memory/heartbeat-state.json`

## Rules
- Don't post more than once per day
- Always link to a relevant Gumroad product in the CTA
- SEO required on every post: Schema.org BlogPosting, OG tags, canonical URL
- Human voice — no corporate-speak, no "In conclusion" garbage
