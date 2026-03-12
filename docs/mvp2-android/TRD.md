# MVP2-Android: Technical Requirements Document (TRD)

## Architecture Overview
```
┌─────────────────────────────────────────────────────┐
│                    Android App                      │
│  ┌─────────┐  ┌─────────┐  ┌─────────────────────┐│
│  │ UI      │  │ Voice   │  │  Notifications      ││
│  │ (Compose)│  │ (STT/TTS)│  │  (FCM/WorkManager) ││
│  └────┬────┘  └────┬────┘  └─────────┬───────────┘│
│       │           │                  │            │
│  ┌────▼───────────▼──────────────────▼───────────┐│
│  │           Repository / Data Layer             ││
│  │  • MessagesDao (Room)                        ││
│  │  • SettingsPreferences (EncryptedSharedPrefs)││
│  │  • NetworkService (Retrofit/WebSocket)      ││
│  └────┬───────────────────────────────────────────┘│
│       │                                           │
│  ┌────▼───────────────────────────────────────────┐│
│  │         OpenClaw Gateway (remote)             ││
│  │  • Chat API (POST /chat)                     ││
│  │  • WebSocket (wss://.../ws)                  ││
│  │  • Auth: Bearer token                        ││
│  └───────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────┘
```

## Tech Stack
- **Language:** Kotlin (100%)
- **UI Framework:** Jetpack Compose (Material 3)
- **Architecture:** MVVM + Repository pattern
- **Networking:** OkHttp + Retrofit (REST), OkHttp WebSocket for streaming
- **Local Storage:** Room (messages), EncryptedSharedPreferences (settings, tokens)
- **Voice:** Android SpeechRecognizer (STT), Android TextToSpeech (TTS)
- **Notifications:** Firebase Cloud Messaging (FCM) + WorkManager for background
- **Security:** Android Keystore (AES), ProGuard obfuscation
- **Testing:** JUnit4, Espresso, MockWebServer

## API Contracts

### 1. Authentication
All requests include header: `Authorization: Bearer <token>`

### 2. Chat Endpoint (REST)
```
POST /v1/chat
Content-Type: application/json

{
  "message": "string",
  "session_id": "optional-string",
  "stream": true|false,
  "tools": ["exec", "file", "browser"]  // optional, defaults to all
}

Response (streaming if requested):
{
  "id": "msg-uuid",
  "role": "assistant",
  "content": "partial or full text",
  "tool_calls": [...],  // if any
  "done": true|false
}
```

### 3. WebSocket (Alternative)
`wss://gateway/v1/ws?token=<token>`
Messages:
```json
{"type":"message","content":"..."}
{"type":"tool_call","name":"exec","arguments":{...}}
{"type":"tool_result","call_id":"...","content":"..."}
```

### 4. Notifications Registration (FCM)
App registers FCM token with Gateway:
```
POST /v1/notifications/register
{"fcm_token": "abc123"}
```
Gateway can then send messages to FCM topic or direct.

### 5. Tools Execution
Tools are invoked by assistant internally; app only displays results. Some tools may require user confirmation (e.g., destructive exec commands). App should intercept `tool_call` events and show confirmation dialog if needed.

```json
{
  "type": "tool_call",
  "call_id": "uuid",
  "name": "exec",
  "arguments": {"command": "rm -rf /tmp/foo"}
}
```
App response (if confirmation needed):
```json
{"type":"tool_confirm","call_id":"uuid","approved":true|false}
```

## Data Model

### Message Entity (Room)
```kotlin
@Entity(tableName = "messages")
data class Message(
  @PrimaryKey val id: String,
  val sessionId: String,
  val role: String, // "user" | "assistant" | "system"
  val content: String,
  val timestamp: Long,
  val isError: Boolean = false,
  val toolCalls: String? = null, // JSON array
  val raw: String? = null // full response payload
)
```

### Settings
- `gateway_url` (String)
- `gateway_token` (Encrypted)
- `tts_enabled` (Boolean)
- `tts_rate` (Float)
- `notifications_enabled` (Boolean)
- `quiet_hours_start` (Int)
- `quiet_hours_end` (Int)

## Security Requirements
- **TRD-SEC-01:** Token must be stored in Android Keystore, never in plain SharedPreferences
- **TRD-SEC-02:** All network traffic must use HTTPS/WSS (TLS 1.2+)
- **TRD-SEC-03:** Certificate pinning optional for initial release (TODO)
- **TRD-SEC-04:** ProGuard/R8 obfuscation enabled (minifyEnabled true)
- **TRD-SEC-05:** Screenshots can be blocked via FLAG_SECURE in settings

## Offline & Sync
- Messages stored in Room DB with `session_id` grouping
- Outgoing messages while offline marked `pending` in DB
- WorkManager enqueues sync worker when network available
- Sync worker sends pending messages in order, updates to `sent` status
- Conflicts: server authoritative; if duplicate IDs, skip

## Voice Implementation
- **STT:** `SpeechRecognizer` with `RecognizerIntent.ACTION_RECOGNIZE_SPEECH`
  - Use `EXTRA_LANGUAGE_MODEL = LANGUAGE_MODEL_FREE_FORM`
  - Prompt: "Speak now"
  - Partial results shown if available
- **TTS:** `TextToSpeech` engine
  - Default to Google TTS if available
  - Set speech rate from settings (0.5–2.0f)
  - Queue management: stop current when new message arrives (configurable)

## Notifications
- FCM integration:
  - App sends FCM token to Gateway on first launch
  - Gateway uses FCM API to send messages
  - App handles `FirebaseMessagingService.onMessageReceived`
  - Notification channels: "errors", "reminders", "messages"
- Foreground service? Not needed if using FCM; app can be killed

## Error Handling
- Network errors → show "Offline" banner, retry button
- Auth errors (401) → prompt re-enter token
- Tool errors → display in chat with "Retry" if applicable
- Crash reporting: optional Firebase Crashlytics (if user consents to analytics)

## Performance
- Lazy loading in message list (RecyclerView)
- Message pagination: load 50 at a time, keep total < 1000 in memory
- Image downloading: Glide or Coil with caching
- TTS speech rate adjustments tested on multiple devices

## Build & Deployment
- Gradle module: `app`
- Min SDK: 29 (Android 10)
- Target SDK: 34 (Android 14)
- Build types: debug, release
- Signing: user provides keystore for release
- Distribution: side-load APK or internal Google Play testing

## Testing Strategy
- Unit tests: ViewModels, Repository logic, data parsing
- Instrumentation tests: UI flows (send message, voice input)
- Integration tests: MockWebServer simulating Gateway API
- Manual testing on physical device (primary)

## Monitoring & Debugging
- Timber for logging (debug builds only)
- Optional: local HTTP proxy (Charles) for inspecting traffic
- FCM console for delivery monitoring

---

**References:**
- FR-001 → auth flow
- FR-003, FR-004 → chat API
- FR-006, FR-007 → STT/TTS integration
- FR-008, FR-009 → FCM registration, notification handling
- FR-010 → tool confirmation flow
- FR-012, FR-013 → Room schema, WorkManager sync

**Next:** SRD (if different from TRD) or QRD.
