<<<<<<< HEAD
# ZAIFA

A JARVIS-style voice assistant frontend. Single screen with voice input—connect your AI agent to process the transcribed speech.

## Features

- **Voice input** – Tap mic to speak, tap again to stop
- **Live transcription** – See your words as you speak
- **Sleek UI** – Dark theme with cyan accents
- **Webhook** – Sends voice commands to a configurable webhook (for n8n, Zapier, etc.)

## Prerequisites

1. **Install Flutter** – [Get Flutter](https://docs.flutter.dev/get-started/install)
2. Add Flutter to your PATH

## Setup & Run

1. **Initialize project** (adds Android/iOS platform files):
   ```bash
   flutter create .
   ```
   Keep existing files when prompted.

2. **Get dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set app display name to ZAIFA**:
   ```bash
   dart run modern_launcher_name
   ```

4. **Add microphone permissions** (required for voice input):

   **Android** – Edit `android/app/src/main/AndroidManifest.xml`, add inside `<manifest>`:
   ```xml
   <uses-permission android:name="android.permission.RECORD_AUDIO"/>
   <uses-permission android:name="android.permission.INTERNET"/>
   ```

   **iOS** – Edit `ios/Runner/Info.plist`, add inside `<dict>`:
   ```xml
   <key>NSMicrophoneUsageDescription</key>
   <string>ZAIFA needs microphone access for voice input</string>
   <key>NSSpeechRecognitionUsageDescription</key>
   <string>ZAIFA needs speech recognition for voice commands</string>
   ```

5. **Run the app**:
   ```bash
   flutter run
   ```

## Webhook (n8n Integration)

1. **Create a Webhook in n8n**
   - Add a **Webhook** node to your workflow
   - Set the Path to `zaifa` (or your choice)
   - **Save** the workflow
   - **Activate** the workflow (toggle ON in top-right)
   - Copy the **exact Production URL** from the Webhook node

2. **Set the webhook URL in ZAIFA**
   - Edit `lib/webhook_config.dart` and paste your URL:
   ```dart
   const String webhookUrl = 'https://your-instance.app.n8n.cloud/webhook/zaifa';
   ```

3. **Test** – Tap "Test webhook" in the app to verify the connection.

3. **Webhook payload** – Each voice command is sent as a POST request with JSON:
   ```json
   {
     "text": "turn on the lights",
     "command": "turn on the lights",
     "timestamp": "2025-02-15T10:30:00.000Z"
   }
   ```

4. **In n8n** – Use `$json.text` or `$json.command` to trigger your actions (IF conditions, HTTP requests, etc.).

**Note:** When running in a browser (Chrome), the webhook URL must support CORS. For n8n cloud or self-hosted with CORS enabled, it should work. For mobile/desktop builds, CORS is not an issue.
=======
# ZAIFA-AI-Assistant
ZAIFA AI Assistant – A Flutter-based email automation assistant that enables users to send emails through voice or text commands using n8n workflows.
>>>>>>> 24112e4e7b69329afe6a99882d618f4beb8cfc7a
