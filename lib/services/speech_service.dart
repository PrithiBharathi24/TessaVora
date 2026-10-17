import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

/// Wraps the `speech_to_text` package.
///
/// This is where the EXISTING PACKAGE (speech_to_text) is put to work:
/// it listens to the microphone and converts the child's spoken words into
/// text that Tessa's own logic can then understand and reply to.
class SpeechService {
  final SpeechToText _speechToText = SpeechToText();

  bool isAvailable = false;
  bool isListening = false;

  /// Asks for microphone permission (required on Android before speech
  /// recognition can start) and initializes the speech_to_text engine.
  Future<bool> initialize() async {
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      isAvailable = false;
      return false;
    }

    isAvailable = await _speechToText.initialize(
      onStatus: (status) {
        isListening = status == 'listening';
      },
      onError: (error) {
        isListening = false;
      },
    );
    return isAvailable;
  }

  /// Starts listening and streams the recognized words back through
  /// [onResult] every time speech_to_text updates its guess.
  Future<void> startListening({
    required Function(String recognizedText, bool isFinal) onResult,
    String localeId = 'en_US',
  }) async {
    if (!isAvailable) {
      final ok = await initialize();
      if (!ok) return;
    }

    isListening = true;
    await _speechToText.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      localeId: localeId,
      listenFor: const Duration(seconds: 12),
      pauseFor: const Duration(seconds: 3),
    );
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    isListening = false;
  }

  /// speech_to_text locale codes for the languages Tessa Vora supports.
  static String localeFor(String language) {
    return language == 'Tamil' ? 'ta_IN' : 'en_US';
  }
}
