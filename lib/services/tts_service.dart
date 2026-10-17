import 'package:flutter_tts/flutter_tts.dart';

/// Wraps the `flutter_tts` package.
///
/// This is where the EXISTING PACKAGE (flutter_tts) is put to work:
/// it takes Tessa's text response and speaks it out loud, in either
/// English or Tamil depending on the child's selected language.
class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setPitch(1.05);
    await _flutterTts.setVolume(1.0);
    _initialized = true;
  }

  Future<void> speak(String text, {String language = 'English'}) async {
    await initialize();
    await _flutterTts.setLanguage(language == 'Tamil' ? 'ta-IN' : 'en-US');
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
