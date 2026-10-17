import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class _PackageInfo {
  final String name;
  final String version;
  final String purpose;
  final String usedIn;
  final String icon;
  _PackageInfo(this.name, this.version, this.purpose, this.usedIn, this.icon);
}

final List<_PackageInfo> _packages = [
  _PackageInfo(
    'speech_to_text',
    '^7.0.0',
    "Converts the child's spoken voice into text in real time, using the "
        "device's built-in speech recognition engine.",
    'Talk to Tessa screen - captures what the child says',
    '🎤',
  ),
  _PackageInfo(
    'flutter_tts',
    '^4.2.0',
    "Converts Tessa's text responses into spoken voice, in English or Tamil.",
    'Talk to Tessa screen - speaks Tessa\'s replies out loud',
    '🔊',
  ),
  _PackageInfo(
    'shared_preferences',
    '^2.5.3',
    'Stores the child profile and learning progress locally on the device, '
        'so data is remembered between app sessions.',
    'Welcome screen, Progress screen, Parent Dashboard',
    '💾',
  ),
  _PackageInfo(
    'permission_handler',
    '^11.3.1',
    'Requests microphone permission from the user before speech recognition '
        'starts, so the feature fails gracefully instead of silently.',
    'Talk to Tessa screen - requested right before listening starts',
    '🔐',
  ),
];

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Technology & Packages',
            style: TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppColors.cardDecoration(),
            child: const Text(
              'Tessa Vora is built on top of existing, published Flutter '
              'packages for speech, voice and storage. Our own code adds '
              'the child profile, learning flow, quiz logic, multilingual '
              'responses, progress tracking and this entire UI on top of them.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
            ),
          ),
          const SizedBox(height: 20),
          ..._packages.map((pkg) => Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(18),
                decoration: AppColors.cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(pkg.icon, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(pkg.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.purple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(pkg.version,
                              style: const TextStyle(
                                  color: AppColors.purpleLight, fontSize: 11)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Purpose',
                        style: TextStyle(
                            color: AppColors.purpleLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(pkg.purpose,
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            height: 1.4)),
                    const SizedBox(height: 10),
                    const Text('Used in Tessa Vora',
                        style: TextStyle(
                            color: AppColors.purpleLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(pkg.usedIn,
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 13)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
