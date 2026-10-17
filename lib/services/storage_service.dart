import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_model.dart';

/// Wraps the `shared_preferences` package.
///
/// This is where the EXISTING PACKAGE (shared_preferences) is put to work:
/// it saves the child's profile and learning progress on the device so the
/// data survives an app restart, without needing any backend or database.
class StorageService {
  static const _keyChildName = 'child_name';
  static const _keyChildAge = 'child_age';
  static const _keyChildLanguage = 'child_language';
  static const _keyProfileExists = 'profile_exists';

  static const _keyQuestionsCompleted = 'questions_completed';
  static const _keyCorrectAnswers = 'correct_answers';
  static const _keyTopicsLearned = 'topics_learned';
  static const _keyLastSession = 'last_session';
  static const _keyActivitiesCompleted = 'activities_completed';

  Future<void> saveChildProfile(ChildModel child) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyChildName, child.name);
    await prefs.setInt(_keyChildAge, child.age);
    await prefs.setString(_keyChildLanguage, child.language);
    await prefs.setBool(_keyProfileExists, true);
  }

  Future<bool> hasProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyProfileExists) ?? false;
  }

  Future<ChildModel> getChildProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return ChildModel(
      name: prefs.getString(_keyChildName) ?? 'Little Learner',
      age: prefs.getInt(_keyChildAge) ?? 5,
      language: prefs.getString(_keyChildLanguage) ?? 'English',
    );
  }

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyChildLanguage, language);
  }

  Future<void> incrementQuestionsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_keyQuestionsCompleted) ?? 0;
    await prefs.setInt(_keyQuestionsCompleted, current + 1);
    await _touchLastSession(prefs);
  }

  Future<void> incrementCorrectAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_keyCorrectAnswers) ?? 0;
    await prefs.setInt(_keyCorrectAnswers, current + 1);
  }

  Future<void> incrementActivitiesCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_keyActivitiesCompleted) ?? 0;
    await prefs.setInt(_keyActivitiesCompleted, current + 1);
    await _touchLastSession(prefs);
  }

  Future<void> addTopicLearned(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    final topics = prefs.getStringList(_keyTopicsLearned) ?? <String>[];
    if (!topics.contains(topic)) {
      topics.add(topic);
      await prefs.setStringList(_keyTopicsLearned, topics);
    }
    await _touchLastSession(prefs);
  }

  Future<void> _touchLastSession(SharedPreferences prefs) async {
    await prefs.setString(_keyLastSession, DateTime.now().toString());
  }

  Future<Map<String, dynamic>> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final questions = prefs.getInt(_keyQuestionsCompleted) ?? 0;
    final correct = prefs.getInt(_keyCorrectAnswers) ?? 0;
    final activities = prefs.getInt(_keyActivitiesCompleted) ?? 0;
    final topics = prefs.getStringList(_keyTopicsLearned) ?? <String>[];
    final lastSessionRaw = prefs.getString(_keyLastSession);
    final percentage = questions == 0 ? 0.0 : (correct / questions) * 100;

    return {
      'questionsCompleted': questions,
      'correctAnswers': correct,
      'activitiesCompleted': activities,
      'topicsLearned': topics,
      'lastSession': lastSessionRaw ?? 'No sessions yet',
      'percentage': percentage,
    };
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyQuestionsCompleted);
    await prefs.remove(_keyCorrectAnswers);
    await prefs.remove(_keyActivitiesCompleted);
    await prefs.remove(_keyTopicsLearned);
    await prefs.remove(_keyLastSession);
  }
}
