# MVP2-Android: Product Requirements Document (PRD)

## Product Vision
A native Android application that provides seamless, full-featured access to the user's OpenClaw assistant, matching the desktop experience with the added convenience of voice I/O and mobile notifications.

## Target User
deathgod (Amit Yadav) — power user of OpenClaw for blog management, research, coding, and content creation.

## Scope

### In Scope (MVP2)
- Text chat with OpenClaw assistant via Gateway API
- Full tool execution (exec, file, browser, etc.) from mobile
- Voice input (STT) and text-to-speech (TTS) output
- Push notifications for assistant-triggered events
- Offline message queuing and local history
- Secure token storage (Android Keystore)
- Settings for gateway config, voice, notifications
- Minimalist dark UI matching OpenClaw aesthetic

### Out of Scope (Future)
- iOS version
- Local LLM inference (standalone mode)
- Multi-user/account switching
- Widgets on home screen
- Voice activation hotword ("Hey Claw")
- Media playback controls (for long TTS)

## User Stories (from FRD)
- US-001: As a user, I can enter my gateway URL and token to connect
- US-002: As a user, I can send text messages and receive streaming responses
- US-003: As a user, I can speak instead of type and hear responses
- US-004: As a user, I get notified when important events happen (errors, task complete)
- US-005: As a user, I can attach files (images, text) to messages
- US-006: As a user, I can view my full conversation history offline
- US-007: As a user, I can configure voice, notifications, and security settings

## Success Criteria
- [ ] All US-001 through US-007 implemented and tested
- [ ] App launches in < 2s on Pixel 5 (Android 10)
- [ ] Average message latency < 500ms on Wi-Fi, < 1s on 4G
- [ ] No crash-free sessions < 99%
- [ ] Token stored securely (verified by security audit)
- [ ] User can complete one full workflow on mobile (e.g., check blog stats → draft tweet → schedule)

## Dependencies
- OpenClaw Gateway stable and reachable (Tailscale or public URL)
- Gateway supports authentication via Bearer token
- Gateway provides either:
  - WebSocket endpoint for real-time messages, or
  - Poll endpoint for messages
- Push notification service (FCM) credentials obtained
- Device TTS engine installed (usually Google)

## Assumptions
- Android device has Google Play Services (for TTS, FCM) — or we provide fallbacks
- User's OpenClaw server has sufficient resources to handle extra mobile sessions
- Network connectivity is generally available when using mobile features

## Timeline (Estimate)
- Week 1: Architecture, project setup, basic UI scaffolding, auth connection
- Week 2: Chat core (send/receive, message list, tool execution)
- Week 3: Voice I/O (STT/TTS), notifications
- Week 4: Offline sync, local DB, settings polish
- Week 5: Testing, bug fixes, release build

Total: ~5 weeks (with parallel tasks may compress)

## Milestones
- M1: App → Gateway connection successful, authentication working
- M2: Chat roundtrip (send text, receive response) with basic formatting
- M3: Voice input and TTS output functional
- M4: Notifications and offline queue operational
- M5: Feature complete, internal testing
- M6: Release to user (side-load APK or internal test track)

## Risks & Mitigations (see BRD for full)
- Gateway unavailable on mobile → use Tailscale exit; implement offline queue
- Token leakage → Keystore, obfuscation, no logs
- Background restrictions → WorkManager, foreground service for sync (if needed)
- API changes → Adapter layer, versioning

## Deliverables
- Android app (APK, optionally AAB for Play Store private testing)
- Source code in Git (mvp2-android repo)
- Setup documentation (build, run, configure)
- User guide (how to use on device)

## Open Issues
- Should we use Kotlin or Flutter/React Native? (Recommend Kotlin for performance, native TTS)
- Will the Gateway be publicly reachable or via Tailscale only?
- FCM setup requires Google Cloud project — user must provide `google-services.json`
- Voice quality: device TTS varies; may need custom TTS engine?

---

**Next Steps:**
1. Confirm tech stack (Kotlin + Jetpack Compose recommended)
2. Set up Android project structure
3. Define TRD (API contracts, data models)
