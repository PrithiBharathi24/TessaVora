import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/storage_service.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Parent Dashboard',
            style: TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: FutureBuilder(
        future: Future.wait([
          _storageService.getChildProfile(),
          _storageService.getProgress(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.purpleLight),
            );
          }

          final child = snapshot.data![0];
          final progress = snapshot.data![1] as Map<String, dynamic>;
          final topics = progress['topicsLearned'] as List<String>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: AppColors.cardDecoration(),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: AppColors.purpleGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          child.name.isNotEmpty
                              ? child.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(child.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          Text('Age ${child.age} • ${child.language}',
                              style: const TextStyle(
                                  color: AppColors.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Learning Summary',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 12),
                _row('Learning Progress',
                    '${(progress['percentage'] as double).toStringAsFixed(0)}%'),
                _row('Activities Completed', '${progress['activitiesCompleted']}'),
                _row('Correct Answers', '${progress['correctAnswers']}'),
                _row('Questions Answered', '${progress['questionsCompleted']}'),
                _row('Topics Covered',
                    topics.isEmpty ? 'None yet' : topics.join(', ')),
                _row('Last Learning Session', progress['lastSession']),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _row(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppColors.cardDecoration(radius: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
