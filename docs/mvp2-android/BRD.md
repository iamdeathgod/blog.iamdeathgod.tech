# MVP2-Android: Business Requirements Document (BRD)

## Project Overview
Build an Android application that connects to the user's existing OpenClaw server via the Gateway API, providing full access to the assistant's capabilities (text chat, voice input/output, notifications, tool integrations) in a mobile interface.

## Business Context
- **Stakeholder:** deathgod (Amit Yadav) — sole user
- **Problem:** Current access to OpenClaw assistant is limited to desktop/Telegram; need mobile native app for on-the-go usage with voice capabilities
- **Goal:** Port the full desktop experience to Android without compromise
- **Success:** All existing workflows (blog management, Gumroad, research, coding, etc.) available on mobile

## Objectives & Scope
- **In Scope:**
  - Android app (native or cross-platform) that communicates with OpenClaw Gateway
  - Text-based chat interface mirroring desktop experience
  - Voice input (speech-to-text) and voice output (TTS)
  - Push notifications for important events (user-defined triggers)
  - Integration with all OpenClaw tools (exec, file, browser, API calls)
  - Authentication using OpenClaw token system
  - Offline mode with sync when reconnected
- **Out of Scope:**
  - Multi-user support
  - iOS version
  - Server-side changes (OpenClaw already provides Gateway)
  - New assistant capabilities beyond what already exists

## Key Performance Indicators (KPIs)
- App launch time < 2 seconds
- Chat message send/receive latency < 500ms (on good network)
- Voice input accuracy comparable to Google Speech (WER < 15%)
- Battery impact < 5% per hour of active use
- Crash-free sessions > 99.5%

## Assumptions & Dependencies
- OpenClaw Gateway is reachable (Tailscale or public URL) and stable
- Gateway token auth is secure and can be stored safely on device
- Android device runs API level 29+ (Android 10)
- User is willing to grant microphone and notification permissions
- No firewall/NAT issues prevent gateway connectivity

## Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| Gateway unreachable on mobile network | High | Use Tailscale exit node or ngrok tunnel; implement offline queue |
| Token leakage from device storage | Critical | Use Android Keystore, encrypted SharedPreferences, obfuscation |
| Voice TTS quality poor on device | Medium | Use high-quality TTS engine (Google/Edge) with caching |
| Background restrictions killing sync | High | Use WorkManager for reliable background tasks |
| OpenClaw API changes break app | Medium | Version API in URL, adapter layer, monitor upstream |

## Timeline & Milestones
- **M1:** Requirements sign-off (today)
- **M2:** Architecture & design complete (2 days)
- **M3:** MVP build (text chat + auth) (1 week)
- **M4:** Voice I/O + notifications (1 week)
- **M5:** Testing, polish, release (3 days)
- **M6:** Deploy to user

## Approval
- Owner: deathgod
- Status: Draft → Ready for review
