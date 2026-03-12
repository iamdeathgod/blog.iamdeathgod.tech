# MVP2-Android: Functional Requirements Document (FRD)

## 1. Authentication & Gateway Connection

### FR-001: Store Gateway Credentials
- As a user, I want to securely store my OpenClaw gateway URL and token so the app can connect automatically on launch
- **Acceptance:**
  - Gateway URL and token entered in Settings
  - Token stored in Android Keystore (encrypted)
  - App validates connection on save (ping gateway)
  - Error shown if invalid

### FR-002: Automatic Connection
- As a user, I want the app to attempt connection to the gateway on startup and reconnect if dropped
- **Acceptance:**
  - On launch, show connecting state → connected/error
  - Background reconnection every 30s when offline
  - Visual indicator (status bar color or icon)
  - Manual disconnect/reconnect toggle

## 2. Chat Interface

### FR-003: Message List
- As a user, I want to see a scrollable list of conversation history with the assistant
- **Acceptance:**
  - Messages displayed in bubbles (user right, assistant left)
  - Timestamps and avatars
  - Markdown rendering (bold, code blocks, links)
  - Infinite scroll loads older messages from local DB
  - Auto-scroll to bottom on new message

### FR-004: Send Text Message
- As a user, I want to type a message and send it to the assistant, seeing the response in real-time
- **Acceptance:**
  - Input field with send button (or Enter)
  - Message appears immediately as "sending"
  - Assistant response streams in (if streaming supported by gateway)
  - Error handling (retry button on failure)
  - Character count (optional)

### FR-005: Rich Content Display
- As a user, I want to see images, code snippets, and formatted text from the assistant
- **Acceptance:**
  - Code blocks with syntax highlighting (languages: bash, json, js, python, etc.)
  - Inline images load from URLs (tap to expand)
  - Files as clickable links (download/open)
  - Tables render properly

## 3. Voice Input & Output

### FR-006: Voice-to-Text Input
- As a user, I want to speak a message instead of typing
- **Acceptance:**
  - Microphone button in input area
  - Real-time transcription while speaking
  - Submit button to send transcribed text
  - Error if speech recognition unavailable
  - Works offline if device supports offline STT (optional)

### FR-007: Text-to-Speech Output
- As a user, I want the assistant's responses spoken aloud
- **Acceptance:**
  - Toggle button to enable/disable TTS per message or globally
  - Configurable voice (pitch, rate, language)
  - Auto-play can be toggled in settings
  - Playback controls (pause, skip) during long responses
  - Uses Android's default TTS engine or Google Cloud TTS if configured

## 4. Notifications

### FR-008: Push Notifications
- As a user, I want to receive notifications for events defined by the assistant
- **Acceptance:**
  - Notifications appear in system tray with sound/vibration
  - Tapping opens app and navigates to relevant context
  - Notification channels: Errors, Reminders, Completed Tasks (user can disable each)
  - Content: title, body, maybe action buttons (e.g., "View", "Dismiss")
  - Respects Do Not Disturb settings

### FR-009: Notification Triggers (from Assistant)
- As the assistant, I want to trigger notifications on the device
- **Acceptance:**
  - Gateway exposes an endpoint or WebSocket message type for push
  - App receives via FCM or persistent WebSocket (if app in foreground/background)
  - Payload: title, body, priority, actions
  - Rate limiting to avoid spam

## 5. Tool Integration

### FR-010: Execute Tools
- As a user, I want to run any OpenClaw tool (exec, file, browser, etc.) from the mobile app and see results
- **Acceptance:**
  - Assistant can invoke tools as part of conversation
  - Results (stdout, file content, screenshots) displayed in chat
  - Sensitive tools (destructive commands) require confirmation dialog
  - Long-running tools show progress indicator / timeout warning

### FR-011: File Attachments
- As a user, I want to send files (images, text) to the assistant
- **Acceptance:**
  - Paperclip button to attach from device storage
  - Images shown inline in chat (both sent and received)
  - Text files displayed/previewed
  - File size limits enforced (configurable, default 5MB)

## 6. Offline & Sync

### FR-012: Offline Message Queue
- As a user, I want to type messages while offline and have them sent automatically when back online
- **Acceptance:**
  - Drafts saved locally when offline
  - Outgoing messages marked "pending" and queued
  - Auto-send queue when connection restored
  - User can manually trigger sync
  - Conflicts resolved by append-only (server authoritative)

### FR-013: Local History
- As a user, I want to view my full conversation history even when offline
- **Acceptance:**
  - All messages cached in local SQLite DB
  - Search works offline
  - Old messages pruned based on age/size config (keep at least 30 days)

## 7. Settings & Configuration

### FR-014: Gateway Configuration
- As a user, I want to change the gateway URL and token from within the app
- **Acceptance:**
  - Settings screen with fields for URL and token
  - "Test Connection" button
  - Show last successful ping timestamp
  - Option to clear stored credentials

### FR-015: Voice Settings
- As a user, I want to configure voice preferences (engine, language, rate)
- **Acceptance:**
  - List available TTS engines installed on device
  - Slider for speech rate (0.5x – 2x)
  - Language selector (for engines that support multiple)
  - Test button to preview voice

### FR-016: Notification Preferences
- As a user, I want to control which events trigger notifications
- **Acceptance:**
  - Checkboxes for categories: Errors, Reminders, Task Complete, New Message
  - Do Not Disturb schedule (quiet hours)
  - Vibration/sound toggles per category

## 8. Security & Privacy

### FR-017: Secure Token Storage
- As a user, I want my gateway token protected if device is lost/stolen
- **Acceptance:**
  - Token stored in Android Keystore (hardware-backed if available)
  - App can be remotely revoked by deleting token from server
  - Option to require biometric (fingerprint/face) to unlock app
  - Screenshot blocking optional (FLAG_SECURE)

### FR-018: Data Minimization
- As a user, I want the app to only store what's necessary locally
- **Acceptance:**
  - No analytics collection without explicit opt-in
  - Messages can be wiped from device on demand
  - Clear data button in Settings

---

**Traceability:**
- FR-001 → TRD-AUTH-01
- FR-003, FR-004 → TRD-UI-01, TRD-API-01
- FR-006, FR-007 → TRD-VOICE-01, TRD-VOICE-02
- FR-008, FR-009 → TRD-PUSH-01
- FR-010 → TRD-TOOLS-01
- FR-012, FR-013 → TRD-OFFLINE-01
- FR-017 → TRD-SEC-01

**Next:** UIRD — UI wireframes and interaction flows.
