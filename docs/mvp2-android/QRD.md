# MVP2-Android: Quality Requirements Document (QRD)

## Quality Goals
- **Reliable:** Crash-free sessions > 99.5%
- **Responsive:** UI stays fluid; no ANRs; message send < 500ms
- **Secure:** Token never leaked; communications encrypted
- **Maintainable:** Codebase tested and documented; technical debt minimal

## Test Strategy

### Unit Tests
- **Coverage target:** 60%+ for ViewModels, Repositories, Use Cases
- **Framework:** JUnit4, MockK/Mockito
- **Scope:** Business logic, data transformations, state management
- **Excluded:** Android framework classes (use instrumentation for those)

### Integration Tests
- **Network:** MockWebServer simulating Gateway responses (success, error, streaming)
- **Database:** Room in-memory tests for message CRUD, query pagination
- **Preferences:** EncryptedSharedPreferences behavior

### UI Tests (Instrumentation)
- **Framework:** Espresso + Compose Testing
- **Critical paths:**
  1. Connect to gateway (valid/invalid token)
  2. Send a text message and receive response
  3. Voice input → send
  4. TTS toggle on/off
  5. Notification tap opens app to correct context
  6. Offline → online sync

### Manual Testing
- Perform on physical device (Pixel 5 or equivalent)
- Test across Android 10, 12, 14
- Battery consumption over 1-hour typical usage
- Memory usage via Android Profiler

## Quality Gates

Before any release candidate:

1. **Static Analysis:**
   - Detekt (Kotlin lint) passes with no errors
   - KtLint format check
   - ProGuard mapping file generated

2. **Unit Tests:**
   - All tests pass
   - Coverage >= 60%

3. **UI Tests:**
   - Critical path tests pass on API 29 and API 34 emulators

4. **Security:**
   - Token verified to be stored in Keystore (via adb shell dumpsys)
   - No plaintext tokens in shared_prefs
   - Network security config validated (cleartext disabled)

5. **Performance:**
   - Cold start < 2s on API 30 emulator (baseline)
   - No memory leaks detected by LeakCanary (if included)

6. **Accessibility:**
   - TalkBack can navigate entire chat screen
   - Content descriptions present for icons
   - Font scaling up to 1.5x does not break layout

## Non-Functional Testing

### Battery Impact
- Use Battery Historian to measure drain over 1 hour:
  - Idle with app in background: < 1%
  - Active chat (send/receive every 30s): < 5%
- Background sync should use JobScheduler/WorkManager (not busy loops)

### Network Resilience
- Simulate 100% packet loss, then restore: app queues messages, syncs correctly
- 401 response: prompt re-auth, do not crash
- 5xx response: exponential backoff, user-friendly error

### Storage Growth
- Insert 1000 messages, ensure DB size < 10MB
- Confirm old messages pruned if configured (optional)

### Notifications
- Arrive within 5 seconds of being sent by Gateway
- Tapping notification opens app and navigates to relevant message/conversation
- Respects Do Not Disturb (no sounds during quiet hours)

## Known Limitations & Future Work
- No message threading or replies
- No editing/deleting messages
- No search in initial release (can be added later)
- Voice activation hotword not supported
- No multi-account support
- FCM requires Google Play Services; alternative push mechanism needed for microG

## Release Checklist

- [ ] Version code incremented
- [ ] Changelog updated
- [ ] All unit tests pass
- [ ] All UI tests pass
- [ ] Release APK signed with correct keystore
- [ ] ProGuard mapping uploaded to crash service (if used)
- [ ] Manual smoke test on physical device
- [ ] Documentation (README) updated with build instructions
- [ ] Gateway API compatibility verified (tested against latest)

## User Acceptance Criteria (for deathgod)

- I can install the app on my Android 10+ device
- I can configure the gateway URL and token
- I can send a text message and get a response
- I can use voice input to send a message
- I can hear the assistant's response via TTS (option toggle)
- I receive a notification when the assistant triggers an event (e.g., task complete)
- I can view my conversation history while offline
- Messages I send while offline are transmitted when I'm back online
- I feel confident my token is stored securely
- The app does not noticeably drain battery during a day of normal use

---

**Sign-off:**
- QA Lead: _________________ Date: ___
- Product Owner (deathgod): _________________ Date: ___

**Next:** Implementation begins after approval of BRD–QRD suite.
