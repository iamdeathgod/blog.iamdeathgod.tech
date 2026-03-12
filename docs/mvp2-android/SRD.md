# MVP2-Android: System Requirements Document (SRD)

## System Overview
The Android application integrates with the OpenClaw ecosystem via the Gateway API. It operates as a thin client: all AI reasoning and tool execution happen server-side. The app focuses on presentation, input capture (text/voice), output rendering, and local caching.

## System Boundaries
```
┌─────────────┐      HTTPS/WebSocket      ┌─────────────────┐
│  Android    │◄─────────────────────────►│  OpenClaw       │
│  App         │   (Bearer token auth)     │  Gateway        │
│              │                           │  (existing)     │
└─────────────┘                           └─────────────────┘
      │
      │ FCM
      ▼
┌─────────────┐
│  Firebase   │
│  Cloud      │
│  Messaging  │
└─────────────┘
```

## Non-Functional Requirements

### NFR-1: Performance
- **Startup time:** Cold start < 2s on reference device (Pixel 5)
- **Message latency:** 95th percentile < 500ms on Wi-Fi, < 1000ms on 4G
- **Memory footprint:** < 150MB typical usage
- **Battery drain:** < 5% per hour of active chat; < 1% per hour idle with background sync

### NFR-2: Reliability & Availability
- **Uptime:** App should not crash; crash-free sessions > 99.5%
- **Connectivity tolerance:** Gracefully handle network loss, retry with exponential backoff
- **Data persistence:** Messages survive app restarts, device reboots
- **Sync integrity:** No message loss or duplication under flaky networks

### NFR-3: Security
- **Authentication:** Bearer token stored in Android Keystore (AES, hardware-backed if available)
- **Transport security:** TLS 1.2+; certificate validation default; optional pinning (future)
- **Input validation:** All server responses parsed safely; avoid injection in tool args
- **Obfuscation:** ProGuard/R8 enabled; code shrinking and optimization
- **Data minimization:** No telemetry without explicit opt-in; no PII in logs

### NFR-4: Compatibility
- **Android versions:** API 29–34 (Android 10 to 14)
- **Screen sizes:** Phones (portrait); tablets may use phone layout
- **TTS engines:** Compatible with Google TTS, Samsung TTS, and third-party engines
- **FCM:** Requires Google Play Services; if absent, degrade to polling (notify user)

### NFR-5: Maintainability
- **Code quality:** Kotlin 100%, no Java; follow Android Kotlin style guide
- **Architecture:** Clean separation (UI, Domain, Data layers)
- **Testing:** Unit test coverage > 60% for ViewModels and Repositories; Espresso for critical UI paths
- **Documentation:** Public APIs documented with KDoc; README with build/run steps

### NFR-6: Internationalization
- **Initial:** English only
- **Future-proof:** Strings externalized; no hard-coded UI text

## System Interfaces

### External 1: OpenClaw Gateway
- **Protocol:** HTTPS (REST) and WSS (WebSocket)
- **Auth:** Bearer token (provided by user)
- **Rate limits:** Respect Retry-After headers; backoff 1s, 2s, 4s...
- **Expected response times:** < 200ms for simple queries, < 5s for complex tool runs

### External 2: Firebase Cloud Messaging
- **Protocol:** FCM over HTTPS
- **Auth:** Server key embedded in app? Actually, app only receives messages; Gateway sends using admin SDK. App only provides FCM token to Gateway.
- **Data payload:** Max 4KB; larger content fetched via Chat API

### External 3: Android System Services
- `SpeechRecognizer` — STT
- `TextToSpeech` — TTS
- `NotificationManager` — post notifications
- `WorkManager` — background sync
- `BiometricPrompt` — optional unlock
- `Keystore` — token encryption

## Deployment & Operations

### Build Artifacts
- `app-debug.apk` — development
- `app-release.apk` — signed release (user installs manually or internal test)
- Optional AAB for Google Play internal testing

### Versioning
- Follow semantic versioning: MAJOR.MINOR.PATCH
- Track in `build.gradle.kts` and displayed in Settings > About

### Updates
- Manual APK distribution for now; no auto-update mechanism
- Future: consider in-app update library or Play Store

### Monitoring
- Optional: Firebase Crashlytics (opt-in)
- Local logs via Timber; user can export logs for debugging

## Constraints
- Must work on Android 10+ (API 29)
- Must not require root
- Must not include any proprietary SDKs without user's explicit consent
- Must not send user data to third parties other than configured Gateway/FCM

## Assumptions about Environment
- Device has Google Play Services (for FCM, TTS, SpeechRecognizer) — if not, we degrade gracefully (no push, basic TTS, limited STT)
- User has data plan or Wi-Fi; large file transfers may incur costs
- Gateway reachable via public URL or Tailscale (no port forwarding issues)

---

**Next:** QRD — quality metrics, testing checklist, acceptance criteria.
