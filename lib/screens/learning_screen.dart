import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/storage_service.dart';

class _Question {
  final String prompt;
  final List<String> options;
  final int correctIndex;
  _Question(this.prompt, this.options, this.correctIndex);
}

class _Category {
  final String emoji;
  final String title;
  final List<_Question> questions;
  _Category(this.emoji, this.title, this.questions);
}

final List<_Category> _categories = [
  _Category('🐾', 'Animals', [
    _Question('What animal says Meow?', ['🐶 Dog', '🐱 Cat', '🦁 Lion'], 1),
    _Question('What animal says Woof?', ['🐱 Cat', '🐘 Elephant', '🐶 Dog'], 2),
  ]),
  _Category('🎨', 'Colors', [
    _Question('Which one is the color of the sky?', ['🔴 Red', '🔵 Blue', '🟢 Green'], 1),
    _Question('Which one is the color of grass?', ['🟢 Green', '🟡 Yellow', '🔴 Red'], 0),
  ]),
  _Category('🔢', 'Numbers', [
    _Question('How many fingers on one hand?', ['3', '5', '7'], 1),
    _Question('What comes after 2?', ['4', '1', '3'], 2),
  ]),
  _Category('🔤', 'Alphabet', [
    _Question('Which letter comes after A?', ['C', 'B', 'D'], 1),
    _Question('Which is the first letter of "Cat"?', ['C', 'A', 'T'], 0),
  ]),
  _Category('🔷', 'Shapes', [
    _Question('Which shape has 3 sides?', ['Square', 'Triangle', 'Circle'], 1),
    _Question('Which shape is round?', ['Circle', 'Square', 'Triangle'], 0),
  ]),
];

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Learn', style: TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: _categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            final category = _categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => _QuizScreen(category: category),
                ));
              },
              child: Container(
                decoration: AppColors.cardDecoration(),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(category.emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 10),
                    Text(category.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuizScreen extends StatefulWidget {
  final _Category category;
  const _QuizScreen({required this.category});

  @override
  State<_QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<_QuizScreen> {
  final StorageService _storageService = StorageService();
  int _questionIndex = 0;
  int? _selectedOption;
  bool _answered = false;

  Future<void> _selectOption(int index) async {
    if (_answered) return;
    final question = widget.category.questions[_questionIndex];
    final isCorrect = index == question.correctIndex;

    setState(() {
      _selectedOption = index;
      _answered = true;
    });

    await _storageService.incrementQuestionsCompleted();
    if (isCorrect) await _storageService.incrementCorrectAnswers();
    await _storageService.addTopicLearned(widget.category.title);
  }

  void _nextQuestion() {
    if (_questionIndex < widget.category.questions.length - 1) {
      setState(() {
        _questionIndex++;
        _selectedOption = null;
        _answered = false;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.category.questions[_questionIndex];
    final isLast = _questionIndex == widget.category.questions.length - 1;
    final isCorrect =
        _answered && _selectedOption == question.correctIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('${widget.category.emoji} ${widget.category.title}',
            style: const TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_questionIndex + 1} of ${widget.category.questions.length}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Text(
              question.prompt,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 26),
            ...List.generate(question.options.length, (index) {
              final isSelected = _selectedOption == index;
              final isRight = index == question.correctIndex;
              Color borderColor = AppColors.purple.withOpacity(0.35);
              if (_answered && isSelected) {
                borderColor = isRight ? AppColors.success : AppColors.error;
              } else if (_answered && isRight) {
                borderColor = AppColors.success;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: GestureDetector(
                  onTap: () => _selectOption(index),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor, width: 1.6),
                    ),
                    child: Text(
                      question.options[index],
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (_answered) ...[
              const SizedBox(height: 8),
              Text(
                isCorrect ? 'Correct! 🎉' : 'Not quite! Keep trying 💜',
                style: TextStyle(
                  color: isCorrect ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(isLast ? 'Finish' : 'Next Question',
                      style: const TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
