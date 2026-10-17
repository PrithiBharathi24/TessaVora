import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/child_model.dart';
import '../services/storage_service.dart';
import 'voice_learning_screen.dart';
import 'learning_screen.dart';
import 'activities_screen.dart';
import 'progress_screen.dart';
import 'parent_dashboard.dart';
import 'packages_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  ChildModel? _child;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final child = await _storageService.getChildProfile();
    if (!mounted) return;
    setState(() => _child = child);
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _HomeItem('🎤', 'Talk to Tessa', 'Speak and get a spoken reply',
          (context) => const VoiceLearningScreen()),
      _HomeItem('📚', 'Learn', 'Animals, colors, numbers & more',
          (context) => const LearningScreen()),
      _HomeItem('🎮', 'Activities', 'Fun quizzes and matching games',
          (context) => const ActivitiesScreen()),
      _HomeItem('📊', 'My Progress', 'See how much you\'ve learned',
          (context) => const ProgressScreen()),
      _HomeItem('👨‍👩‍👧', 'Parent Dashboard', 'A summary for parents',
          (context) => const ParentDashboard()),
      _HomeItem('🧩', 'Technology & Packages', 'What powers Tessa Vora',
          (context) => const PackagesScreen()),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${_child?.name ?? "Little Learner"} 👋',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'What would you like to do today?',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _DashboardCard(item: item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeItem {
  final String emoji;
  final String title;
  final String subtitle;
  final WidgetBuilder builder;

  _HomeItem(this.emoji, this.title, this.subtitle, this.builder);
}

class _DashboardCard extends StatelessWidget {
  final _HomeItem item;
  const _DashboardCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: item.builder));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppColors.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: AppColors.purpleGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(item.emoji, style: const TextStyle(fontSize: 22)),
            ),
            const Spacer(),
            Text(
              item.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
