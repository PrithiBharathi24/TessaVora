import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/storage_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final StorageService _storageService = StorageService();
  late Future<Map<String, dynamic>> _progressFuture;

  @override
  void initState() {
    super.initState();
    _progressFuture = _storageService.getProgress();
  }

  void _refresh() {
    setState(() => _progressFuture = _storageService.getProgress());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('My Progress',
            style: TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh, color: AppColors.purpleLight),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _progressFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.purpleLight),
            );
          }

          final data = snapshot.data!;
          final questions = data['questionsCompleted'] as int;
          final correct = data['correctAnswers'] as int;
          final activities = data['activitiesCompleted'] as int;
          final topics = data['topicsLearned'] as List<String>;
          final percentage = data['percentage'] as double;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: AppColors.cardDecoration(),
                  child: Column(
                    children: [
                      const Text('Overall Progress',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                      const SizedBox(height: 12),
                      Text('${percentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: AppColors.purpleLight,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (percentage / 100).clamp(0, 1),
                          minHeight: 10,
                          backgroundColor: AppColors.surfaceLight,
                          valueColor: const AlwaysStoppedAnimation(AppColors.purple),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                        child: _statCard('Questions', '$questions', '📝')),
                    const SizedBox(width: 14),
                    Expanded(
                        child: _statCard('Correct', '$correct', '✅')),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                        child: _statCard('Activities', '$activities', '🎮')),
                    const SizedBox(width: 14),
                    Expanded(
                        child: _statCard('Topics', '${topics.length}', '📚')),
                  ],
                ),
                const SizedBox(height: 22),
                const Text('Topics Learned',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 10),
                topics.isEmpty
                    ? const Text('No topics yet - start learning!',
                        style: TextStyle(color: AppColors.textSecondary))
                    : Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: topics
                            .map((topic) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.purpleGradient,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(topic,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13)),
                                ))
                            .toList(),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(String label, String value, String emoji) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppColors.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
