import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';
import '../services/tessa_brain.dart';
import '../services/storage_service.dart';

enum _VoiceState { idle, listening, processing, responded }

/// This screen chains all three existing packages together:
/// speech_to_text (hear the child) -> TessaBrain (our own logic, not a
/// package) -> flutter_tts (speak the reply). shared_preferences quietly
/// logs the interaction as a completed "question" for the progress screen.
class VoiceLearningScreen extends StatefulWidget {
  const VoiceLearningScreen({super.key});

  @override
  State<VoiceLearningScreen> createState() => _VoiceLearningScreenState();
}

class _VoiceLearningScreenState extends State<VoiceLearningScreen> {
  final SpeechService _speechService = SpeechService();
  final TtsService _ttsService = TtsService();
  final StorageService _storageService = StorageService();

  _VoiceState _state = _VoiceState.idle;
  String _recognizedText = '';
  String _tessaResponse = '';
  String _language = 'English';
  bool _micReady = true;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final child = await _storageService.getChildProfile();
    if (!mounted) return;
    setState(() => _language = child.language);
  }

  Future<void> _handleMicTap() async {
    if (_state == _VoiceState.listening) {
      await _speechService.stopListening();
      return;
    }

    setState(() {
      _state = _VoiceState.listening;
      _recognizedText = '';
      _tessaResponse = '';
    });

    await _speechService.startListening(
      localeId: SpeechService.localeFor(_language),
      onResult: (text, isFinal) {
        setState(() => _recognizedText = text);
        if (isFinal && text.trim().isNotEmpty) {
          _generateResponse(text);
        }
      },
    );

    if (!_speechService.isAvailable) {
      setState(() {
        _state = _VoiceState.idle;
        _micReady = false;
      });
    }
  }

  Future<void> _generateResponse(String recognizedText) async {
    setState(() => _state = _VoiceState.processing);

    // Tessa's own reasoning (not from any package) decides the reply.
    final response = TessaBrain.getResponse(recognizedText, _language);

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() {
      _tessaResponse = response;
      _state = _VoiceState.responded;
    });

    await _ttsService.speak(response, language: _language);
    await _storageService.incrementQuestionsCompleted();
  }

  @override
  void dispose() {
    _speechService.stopListening();
    _ttsService.stop();
    super.dispose();
  }

  String get _statusLabel {
    switch (_state) {
      case _VoiceState.listening:
        return 'Listening...';
      case _VoiceState.processing:
        return 'Processing...';
      case _VoiceState.responded:
        return 'Tessa Response';
      case _VoiceState.idle:
        return 'Tap the mic and talk to Tessa';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Talk to Tessa',
            style: TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _languageBadge(),
              const SizedBox(height: 8),
              if (!_micReady) _permissionWarning(),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_recognizedText.isNotEmpty)
                        _bubble(
                          title: 'You said:',
                          text: '"$_recognizedText"',
                          alignLeft: false,
                        ),
                      if (_tessaResponse.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _bubble(
                          title: 'Tessa responds:',
                          text: _tessaResponse,
                          alignLeft: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _statusLabel,
                style: const TextStyle(
                  color: AppColors.purpleLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              _micButton(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageBadge() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.purple.withOpacity(0.4)),
        ),
        child: Text(
          'Language: $_language',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ),
    );
  }

  Widget _permissionWarning() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.4)),
      ),
      child: const Text(
        'Microphone permission is needed for speech recognition to work. '
        'Please allow it in your device settings and try again.',
        style: TextStyle(color: AppColors.error, fontSize: 12.5),
      ),
    );
  }

  Widget _bubble({required String title, required String text, required bool alignLeft}) {
    return Align(
      alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(14),
        decoration: alignLeft
            ? AppColors.cardDecoration(radius: 16)
            : BoxDecoration(
                gradient: AppColors.purpleGradient,
                borderRadius: BorderRadius.circular(16),
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                  color: alignLeft ? AppColors.purpleLight : Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 4),
            Text(text,
                style: const TextStyle(color: Colors.white, fontSize: 14.5)),
          ],
        ),
      ),
    );
  }

  Widget _micButton() {
    final isListening = _state == _VoiceState.listening;
    return GestureDetector(
      onTap: _handleMicTap,
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.purpleGradient,
          boxShadow: AppColors.glow(opacity: isListening ? 0.85 : 0.5),
        ),
        child: Icon(
          isListening ? Icons.mic : Icons.mic_none_rounded,
          color: Colors.white,
          size: 38,
        ),
      ),
    );
  }
}
