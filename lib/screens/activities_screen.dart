import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/storage_service.dart';

class _Activity {
  final String emoji;
  final String title;
  final String description;
  final List<_MatchPair> pairs;
  _Activity(this.emoji, this.title, this.description, this.pairs);
}

class _MatchPair {
  final String emoji;
  final String label;
  _MatchPair(this.emoji, this.label);
}

final List<_Activity> _activities = [
  _Activity('🧩', 'Match the Object', 'Match each picture with its name', [
    _MatchPair('🍎', 'Apple'),
    _MatchPair('🚗', 'Car'),
    _MatchPair('🌞', 'Sun'),
  ]),
  _Activity('🎨', 'Identify Colors', 'Tap the color that is named', [
    _MatchPair('🔴', 'Red'),
    _MatchPair('🔵', 'Blue'),
    _MatchPair('🟢', 'Green'),
  ]),
  _Activity('🐾', 'Identify Animals', 'Tap the animal that is named', [
    _MatchPair('🐘', 'Elephant'),
    _MatchPair('🦁', 'Lion'),
    _MatchPair('🐘', 'Elephant'),
  ]),
];

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Activities',
            style: TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _activities.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final activity = _activities[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => _ActivityScreen(activity: activity),
              ));
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: AppColors.cardDecoration(),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppColors.purpleGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(activity.emoji, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(height: 4),
                        Text(activity.description,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 12.5)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.purpleLight),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ActivityScreen extends StatefulWidget {
  final _Activity activity;
  const _ActivityScreen({required this.activity});

  @override
  State<_ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<_ActivityScreen> {
  final StorageService _storageService = StorageService();
  int _round = 0;
  String? _feedback;

  Future<void> _pick(_MatchPair target, _MatchPair chosen) async {
    final isCorrect = target.label == chosen.label;
    setState(() {
      _feedback = isCorrect ? 'Correct! 🎉' : 'Try the next one!';
    });

    if (isCorrect) await _storageService.incrementCorrectAnswers();
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    if (_round < widget.activity.pairs.length - 1) {
      setState(() {
        _round++;
        _feedback = null;
      });
    } else {
      await _storageService.incrementActivitiesCompleted();
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.activity.pairs[_round];
    final options = List<_MatchPair>.from(widget.activity.pairs)..shuffle();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(widget.activity.title,
            style: const TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Round ${_round + 1} of ${widget.activity.pairs.length}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 24),
            Text(target.emoji, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 8),
            const Text('What is this?',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 18)),
            const SizedBox(height: 30),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: options
                  .map((option) => GestureDetector(
                        onTap: () => _pick(target, option),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          decoration: AppColors.cardDecoration(radius: 14),
                          child: Text(option.label,
                              style: const TextStyle(
                                  color: AppColors.textPrimary, fontSize: 15)),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 26),
            if (_feedback != null)
              Text(_feedback!,
                  style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
