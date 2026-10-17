import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/child_model.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final StorageService _storageService = StorageService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedLanguage = 'English';
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _startLearning() async {
    final name = _nameController.text.trim().isEmpty
        ? 'Little Learner'
        : _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim()) ?? 5;

    setState(() => _saving = true);

    final child = ChildModel(name: name, age: age, language: _selectedLanguage);
    await _storageService.saveChildProfile(child);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('Hi! I\'m Tessa 👋',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 6),
              const Text(
                'Let\'s set up your learning profile first.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
              ),
              const SizedBox(height: 32),
              _buildLabel('Child\'s Name'),
              _buildTextField(_nameController, 'Enter name'),
              const SizedBox(height: 20),
              _buildLabel('Age'),
              _buildTextField(_ageController, 'Enter age',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              _buildLabel('Preferred Language'),
              const SizedBox(height: 10),
              Row(
                children: [
                  _languageChip('English'),
                  const SizedBox(width: 12),
                  _languageChip('Tamil'),
                ],
              ),
              const SizedBox(height: 44),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saving ? null : _startLearning,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ).copyWith(
                    shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          'Start Learning',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      );

  Widget _buildTextField(TextEditingController controller, String hint,
      {TextInputType? keyboardType}) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: AppColors.cardDecoration(radius: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _languageChip(String language) {
    final isSelected = _selectedLanguage == language;
    return GestureDetector(
      onTap: () => setState(() => _selectedLanguage = language),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.purpleGradient : null,
          color: isSelected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.purple.withOpacity(0.4),
          ),
          boxShadow: isSelected ? AppColors.glow(opacity: 0.4) : null,
        ),
        child: Text(
          language,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
