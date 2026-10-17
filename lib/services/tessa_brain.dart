/// TessaBrain is 100% written for this project - it is NOT part of any
/// package. It takes the plain text produced by speech_to_text and decides
/// what Tessa should say back, in the child's selected language. flutter_tts
/// then speaks whatever string this class returns.
class TessaBrain {
  static final Map<String, Map<String, String>> _responses = {
    'hello': {
      'English':
          'Hello there! I am Tessa, your learning friend. What would you like to learn today?',
      'Tamil':
          'வணக்கம்! நான் டெஸ்ஸா, உங்கள் கற்றல் தோழி. இன்று நீங்கள் என்ன கற்க விரும்புகிறீர்கள்?',
    },
    'animal': {
      'English': 'Animals are living beings. Can you name one animal?',
      'Tamil':
          'விலங்குகள் உயிருள்ள உயிரினங்கள். ஒரு விலங்கின் பெயரைச் சொல்ல முடியுமா?',
    },
    'cat': {
      'English': 'A cat is a small animal. A cat says Meow!',
      'Tamil': 'பூனை ஒரு சிறிய விலங்கு. அது மியாவ் என்று சொல்லும்!',
    },
    'dog': {
      'English': 'A dog is a friendly animal. A dog says Woof!',
      'Tamil': 'நாய் ஒரு நட்பான விலங்கு. அது வூஃப் என்று சொல்லும்!',
    },
    'color': {
      'English':
          'Colors are all around us! Red, blue, green and yellow are colors.',
      'Tamil':
          'நிறங்கள் நம்மைச் சுற்றி இருக்கின்றன! சிவப்பு, நீலம், பச்சை மற்றும் மஞ்சள்.',
    },
    'number': {
      'English':
          'Numbers help us count things. Let us count from one to five!',
      'Tamil':
          'எண்கள் நமக்கு பொருட்களை எண்ண உதவுகின்றன. ஒன்று முதல் ஐந்து வரை எண்ணுவோம்!',
    },
    'shape': {
      'English':
          'Shapes like circle, square and triangle are everywhere around us.',
      'Tamil':
          'வட்டம், சதுரம் மற்றும் முக்கோணம் போன்ற வடிவங்கள் நம்மைச் சுற்றி உள்ளன.',
    },
    'alphabet': {
      'English': 'The alphabet has twenty six letters, starting with A, B, C.',
      'Tamil': 'தமிழ் எழுத்துக்கள் அ, ஆ, இ, ஈ என்று தொடங்குகின்றன.',
    },
  };

  static const String _defaultEnglish =
      "That's interesting! You can ask me about animals, colors, numbers, "
      'shapes or the alphabet.';
  static const String _defaultTamil =
      'அது சுவாரஸ்யமாக இருக்கிறது! விலங்குகள், நிறங்கள், எண்கள், வடிவங்கள் '
      'அல்லது எழுத்துக்கள் பற்றி என்னிடம் கேளுங்கள்.';

  /// Very simple keyword matching - enough to show a believable, working
  /// conversation loop for a demo without needing any external AI service.
  static String getResponse(String recognizedText, String language) {
    final text = recognizedText.toLowerCase().trim();

    if (text.isEmpty) {
      return language == 'Tamil'
          ? 'நான் உங்களைக் கேட்கவில்லை. மீண்டும் முயற்சிக்கவா?'
          : "I didn't quite hear that. Can you try again?";
    }

    for (final keyword in _responses.keys) {
      if (text.contains(keyword)) {
        return _responses[keyword]![language] ??
            _responses[keyword]!['English']!;
      }
    }

    return language == 'Tamil' ? _defaultTamil : _defaultEnglish;
  }
}
