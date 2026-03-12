# MVP2-Android: User Interface Requirements Document (UIRD)

## Design Principles
- **Minimalist:** Focus on conversation; UI elements fade into background
- **Fast:** One-tap actions, minimal navigation depth
- **Consistent:** Match OpenClaw desktop aesthetic (dark theme, purple/cyan accents)
- **Accessible:** Large tap targets, readable fonts, TalkBack support

## Color Palette
- Background: `#07070f` (dark)
- Surface: `#0d0d1a` (cards, input areas)
- Accent: `#7c3aed` (purple) for primary actions
- Accent light: `#a855f7`
- Cyan: `#06b6d4` for secondary actions, voice recording
- Text primary: `#e2e8f0`
- Text secondary: `#64748b`
- Border: `#1e1e3a`

## Typography
- Body: `Space Grotesk` (or `Inter` if not available)
- Monospace: `Space Mono` for code blocks
- Sizes:
  - Title: 20–24sp
  - Body: 16sp
  - Caption: 12–14sp

## Screen Layouts

### 1. Main Chat Screen (`activity_main.xml`)

```
┌─────────────────────────────────────┐
│  ◀  iamdeathgod          ● connected │  ← Top bar: back (if embedded), status indicator
├─────────────────────────────────────┤
│  Message List (RecyclerView)        │
│  ┌─────────────────────────────┐   │
│  │ [User bubble] Hey           │   │
│  │ [Assistant bubble] ...      │   │
│  │ [Code block]                │   │
│  │ [Image preview]             │   │
│  │                             │   │
│  │ (scrollable)                │   │
│  └─────────────────────────────┘   │
├─────────────────────────────────────┤
│  [📎] [🎤] [   Type a message... ]│   ← Input area
│        [Send]                      │
└─────────────────────────────────────┘
```

**Components:**
- `RecyclerView` with two view types (user/assistant)
- User bubble: purple accent background, white text, right-aligned
- Assistant bubble: dark surface, left-aligned
- Code blocks: monospace, horizontal scroll, copy button
- Images: expand to full-screen on tap
- Timestamps: small, muted, below bubble (optional)
- Typing indicator: three dots animation when assistant responding

### 2. Settings Screen (`activity_settings.xml`)

```
◀ Settings
──────────────────────────────
Gateway
  URL: https://...
  Token: •••••••• [Test] [Edit]

Voice
  [✓] Enable TTS
  Engine: Google TTS
  Rate: ──○──────── (50%–150%)
  [Test]

Notifications
  [✓] Errors
  [✓] Completed Tasks
  [✓] Reminders
  Quiet hours: 23:00–07:00

Security
  [✓] Biometric unlock
  [✓] Block screenshots
  [Clear local data]

About
  Version: 2.0.0 (debug)
  OpenClaw Gateway: v2026.3.2
```

### 3. Notification UI
- Standard Android notification style
- Big picture for image results
- Actions: "Open", "Reply", "Dismiss"
- Channel names: "OpenClaw Errors", "OpenClaw Reminders", "OpenClaw Messages"

### 4. Voice Input Overlay
When microphone button tapped:
```
┌─────────────────────────────────────┐
│  🎤 Listening...                    │
│  Visualize waveform (optional)      │
│  [⏸] [■] [⏹]                       │
│  Cancel  Send                       │
└─────────────────────────────────────┘
```
- Live transcription shown below title
- Stop button ends listening, sends text

## Navigation
- Single activity, single fragment (chat screen)
- Settings as separate activity or bottom sheet
- Deep links: `intent://chat` opens app to chat

## Interactions

### Sending Message
1. User types or speaks
2. Tap Send (or voice auto-submit)
3. Message appears immediately with "sending" spinner
4. On success: spinner → delivered (no extra check)
5. On error: red bubble with "Retry" button

### Receiving Message
1. Server push via WebSocket or poll
2. Append to RecyclerView, scroll to bottom
3. If TTS enabled and app in foreground → speak
4. If app in background → show notification (based on content type)

### Voice Toggle
- Long-press message → "Speak" context menu? Or simpler: global TTS toggle in header

### File Attachment
- Paperclip button opens system picker
- Selected file uploaded via `exec` tool or multipart API
- Progress shown as overlay on send button

## Responsiveness
- Support portrait only (simpler)
- Tablets: two-pane layout? Not needed for MVP2

## Accessibility
- Content descriptions for all icons
- TalkBack reads message content naturally
- High contrast mode support (use system colors where possible)
- Font scaling respected up to 1.5x

## Error States
- Offline: banner at top "Offline - messages queued"
- Auth failure: full-screen "Reauthenticate" with token field
- Gateway unreachable: retry button, last seen timestamp
- Voice recognition error: toast "Could not understand, try again"

## Dark Theme Only
App is dark-only to match user preference and save battery (AMOLED). No light theme.

---

**References:**
- FR-001 → Settings screen gateway fields
- FR-003, FR-004 → Chat screen message list + input
- FR-006, FR-007 → Voice overlay, TTS settings
- FR-008, FR-009 → Notification channels
- FR-010 → File attachment UI

**Next:** PRD — scope, timeline, deliverables.
