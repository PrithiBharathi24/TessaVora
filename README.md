# TESSA VORA
### AI-Powered Multilingual Learning Companion for Early Childhood
*(Flutter + Dart demo project)*

---

## 1. Project Overview

Tessa Vora is a Flutter mobile app demo built around a friendly AI character,
**Tessa**, who talks with a child, answers simple questions out loud, and
runs small learning activities in **English and Tamil**. The project is
built to show two things side by side:

1. Three existing, published Flutter packages doing real work
   (`speech_to_text`, `flutter_tts`, `shared_preferences`).
2. Original application logic and design built on top of them
   (the child profile, learning flow, quiz questions, Tessa's reply
   logic, progress tracking, and the entire UI).

---

## 2. Features

- Splash screen → Child profile setup → Home dashboard
- **Talk to Tessa**: live microphone → speech-to-text → Tessa's own reply
  logic → text-to-speech, in English or Tamil
- **Learn**: 5 categories (Animals, Colors, Numbers, Alphabet, Shapes)
  with multiple-choice questions and instant "Correct! 🎉" feedback
- **Activities**: Match the Object, Identify Colors, Identify Animals
- **My Progress**: questions completed, correct answers, topics learned,
  percentage — all read from local storage
- **Parent Dashboard**: a read-only summary for parents
- **Technology & Packages**: a dedicated screen listing exactly which
  package does what, and where it's used in the app

---

## 3. Package List

| Package | Version | Role |
|---|---|---|
| `speech_to_text` | `^7.0.0` | Voice → text |
| `flutter_tts` | `^4.2.0` | Text → voice |
| `shared_preferences` | `^2.5.3` | Local storage |
| `permission_handler` | `^11.3.1` | Microphone permission |

## 4. Package Purpose (short version)

- **speech_to_text** – listens to the child through the microphone and
  turns speech into text.
- **flutter_tts** – speaks Tessa's text responses out loud.
- **shared_preferences** – saves the child's profile and learning progress
  on the device, so it's remembered next time the app opens.
- **permission_handler** – asks Android for microphone access before
  speech recognition starts, so the feature fails politely instead of
  silently if denied.

---

## 5. Folder Structure

```text
tessa_vora/
├── pubspec.yaml
├── android_manifest_reference/
│   └── AndroidManifest_additions.xml   (copy into android/app/.../AndroidManifest.xml)
└── lib/
    ├── main.dart
    ├── theme/
    │   └── app_colors.dart
    ├── models/
    │   └── child_model.dart
    ├── services/
    │   ├── speech_service.dart      (wraps speech_to_text)
    │   ├── tts_service.dart         (wraps flutter_tts)
    │   ├── storage_service.dart     (wraps shared_preferences)
    │   └── tessa_brain.dart         (OUR OWN reply logic - no package)
    └── screens/
        ├── splash_screen.dart
        ├── welcome_screen.dart
        ├── home_screen.dart
        ├── voice_learning_screen.dart
        ├── learning_screen.dart
        ├── activities_screen.dart
        ├── progress_screen.dart
        ├── parent_dashboard.dart
        └── packages_screen.dart
```

---

## 6. How To Set This Up On Your Machine

You already have Flutter and Dart installed, so:

```bash
flutter create tessa_vora
cd tessa_vora
```

This generates the standard Flutter project (including a working
`android/` folder). Now:

1. **Replace** the generated `pubspec.yaml` with the one in this project.
2. **Replace** the entire generated `lib/` folder with the `lib/` folder
   from this project (delete the default `lib/main.dart` first).
3. Open `android/app/src/main/AndroidManifest.xml` and add the permission
   lines shown in `android_manifest_reference/AndroidManifest_additions.xml`
   (see Section 7 below).
4. Install the packages:

```bash
flutter pub get
```

5. Connect your Android phone (with USB debugging on) or start an Android
   emulator, then run:

```bash
flutter run
```

---

## 7. Android Permissions

Speech recognition needs the microphone, so `android/app/src/main/AndroidManifest.xml`
needs two permissions and a `<queries>` block (required on Android 11+ so the
app can even detect that a speech recognizer exists on the phone).

Open the manifest and add this **inside `<manifest>`, above `<application>`**:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />

<queries>
    <intent>
        <action android:name="android.speech.RecognitionService" />
    </intent>
    <intent>
        <action android:name="android.speech.action.RECOGNIZE_SPEECH" />
    </intent>
</queries>
```

The exact full block, in context, is in
`android_manifest_reference/AndroidManifest_additions.xml`.

The app also asks for microphone permission **at runtime** (via
`permission_handler`) the first time you open "Talk to Tessa" — Android
will show a normal "Allow Tessa Vora to record audio?" popup.

---

## 8. How The Voice Feature Works

```text
Child taps the mic button
        ↓
speech_service.dart calls speech_to_text.listen()
        ↓
Recognized words stream back live and are shown as "You said: ..."
        ↓
Once speech is final, tessa_brain.dart (our own code) picks a reply
based on keywords in what was said, in the selected language
        ↓
The reply is shown on screen as "Tessa responds: ..."
        ↓
tts_service.dart calls flutter_tts.speak() to say it out loud
        ↓
storage_service.dart logs it as one more completed question
```

`TessaBrain` (in `lib/services/tessa_brain.dart`) is plain Dart — it is
**not** part of any package. It looks for keywords like "animal", "cat",
"color", "number", "shape", "alphabet" or "hello" in what the child said,
and returns a matching sentence in English or Tamil. Anything it doesn't
recognize gets a friendly default answer. This is deliberately simple so
it's easy to explain and extend during your presentation.

---

## 9. How The Packages Are Used (in code)

- `SpeechService` (`lib/services/speech_service.dart`) is the only place
  `speech_to_text` is called directly.
- `TtsService` (`lib/services/tts_service.dart`) is the only place
  `flutter_tts` is called directly.
- `StorageService` (`lib/services/storage_service.dart`) is the only place
  `shared_preferences` is called directly.

Every screen talks to these three service classes instead of calling the
packages directly — this is what your evaluator will see when you open the
code: a clean line between "package" and "our application logic."

---

## 10. Demo Presentation Flow

```text
1. Open Tessa Vora → Splash screen appears
        ↓
2. Set up child profile (name, age, language) → Start Learning
        ↓
3. Show Home Dashboard (6 cards)
        ↓
4. Open "Talk to Tessa" → tap mic → say "Tell me about animals"
        ↓
5. Show the recognized text appearing live (speech_to_text working)
        ↓
6. Show Tessa's text reply appear (our own Dart logic)
        ↓
7. Listen to Tessa speak the reply out loud (flutter_tts working)
        ↓
8. Open "Learn" → pick a category → answer a question → show "Correct! 🎉"
        ↓
9. Open "My Progress" → show updated numbers (shared_preferences working)
        ↓
10. Open "Technology & Packages" → walk through each package card
        ↓
11. Explain: "these are existing packages; everything else is ours"
```

---

## 11. Existing Package vs. Our Development

```text
speech_to_text, flutter_tts, shared_preferences, permission_handler
                            ↓
                  EXISTING TECHNOLOGY
      (published on pub.dev, maintained by other developers,
         we only call their public functions)

                            ↓

                        TESSA VORA
                            ↓
                     OUR APPLICATION
                            ↓
        - Child profile screens and data model
        - The entire dark-purple UI and navigation
        - Home dashboard, Learn, Activities, Progress, Parent Dashboard
        - TessaBrain: the keyword-matching reply logic
        - English/Tamil content for every response and question
        - Quiz questions, answer checking, scoring
        - Progress calculation and formatting
        - Wiring the three packages together into one working flow
```

In short: the packages provide **raw capability** (hear, speak, remember).
Everything a user actually experiences as "Tessa" — her personality, the
lessons, the design, the flow — is original work built on top of that
capability.

---

## 12. Common Errors and Fixes

**"MissingPluginException" on first run**
→ Run `flutter clean`, then `flutter pub get`, then `flutter run` again.
This happens when native plugin code hasn't been rebuilt after adding a
package.

**Mic button does nothing / `speech_to_text.initialize()` returns false**
→ Check that `RECORD_AUDIO` and the `<queries>` block were added to
`AndroidManifest.xml` (Section 7), and that you tapped "Allow" on the
runtime permission popup. On an emulator, make sure the emulator's host
audio input is enabled (AVD settings → Microphone).

**No sound from Tessa**
→ Make sure the phone/emulator volume is up. Some emulators need Tamil
(`ta-IN`) voice data installed separately — English will always work;
for Tamil TTS on a real device, install the Tamil voice under
Android Settings → Accessibility → Text-to-speech output.

**"Because tessa_vora depends on X which requires Y..." version conflict**
→ Run `flutter pub upgrade --major-versions`, or relax the version in
`pubspec.yaml` (e.g. `speech_to_text: ^7.0.0` → `any`) if your installed
Flutter SDK is older or newer than expected.

**Gradle / Android build errors about `minSdkVersion`**
→ Open `android/app/build.gradle` (or `build.gradle.kts`) and set
`minSdk = 21` or higher — `speech_to_text` and `flutter_tts` need at
least API 21.

**App crashes immediately on launch**
→ Run `flutter run -v` and read the first red error line; it's almost
always a typo from copy-pasting file paths. Double-check every file
landed in the exact folder shown in Section 5.
