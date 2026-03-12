# MVP2-Android: Market Requirements Document (MRD)

## Target User
**Primary:** deathgod (Amit Yadav)
- Already uses OpenClaw daily for blog management, research, coding, notifications
- Needs mobile access to maintain productivity while away from desk
- Comfortable with technical tools, values efficiency
- Single user, no onboarding complexity

**Secondary:** None (not targeted for public release at this time)

## Problem Statement
The assistant is currently accessible via:
- Desktop web interface (OpenClaw dashboard)
- Telegram bot

Neither provides a native Android experience with voice I/O and deep system integration. The user wants:
- Quick voice queries (like "check blog stats", "draft a tweet")
- Hands-free operation
- Push alerts for time-sensitive items
- Same tool capabilities as desktop

## Competitor Analysis
| Competitor | Strengths | Weaknesses | Why we win |
|------------|-----------|------------|-----------|
| ChatGPT mobile app | Polished UI, voice, plugins | No custom tool integrations, subscription cost | We connect to our own OpenClaw with full access to our tools |
| Claude mobile (Codex) | Strong reasoning | Limited to Anthropic's model, no custom backend | We route to any OpenRouter model, use our own Gateway |
| Standard Telegram bot | Already works | No voice I/O, limited UI, no native notifications | Native app with rich interface and voice |
| Custom Tasker/Automate scripts | Flexible | Fragmented, UI building hard | Unified, maintainable app |

## User Needs & Pain Points
- **Need:** Seamless continuation of desktop workflows on mobile
- **Pain:** Having to switch to Telegram which lacks rich formatting and tool access
- **Need:** Voice input for quick commands while driving/ cooking
- **Pain:** No push notifications for important events (e.g., "your blog post finished publishing")
- **Need:** Offline capability — drafts saved locally, sync when back online

## Value Proposition
A single Android app that puts your full OpenClaw assistant in your pocket with voice, notifications, and zero compromise on tool integrations. Works with your existing setup, no extra accounts, no middleman cloud.

## Market Size
Single-user internal tool. Not applicable for TAM/SAM/SOM.

## Positioning
"Your OpenClaw assistant, native on Android — voice, chat, tools, everywhere."

## Release Criteria
- Must have: Text chat with full tool access, secure gateway connection
- Should have: Voice input + TTS output, push notifications
- Nice to have: Widget for quick prompt, voice activation ("Hey Claw"), multi-language support

## Open Questions
- Should the app use a local LLM fallback when offline? (Probably no for MVP2)
- Voice model: device STT/TTS or cloud? (Cloud gives better quality, may need internet)
- Notification triggers: which events? (Configurable, default: errors, completed long tasks, scheduled reminders)

---

**Next:** FRD — detailed feature list and user stories.
