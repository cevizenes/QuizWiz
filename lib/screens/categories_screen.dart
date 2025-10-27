import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lightPurple.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Q',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader =
                                  const LinearGradient(
                                    colors: [
                                      AppColors.lightBlue,
                                      AppColors.lightPink,
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 70),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'QuizWiz',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Categories',
                      style: TextStyle(color: AppColors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),

              // Categories Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.3,
                    children: [
                      _buildCategoryCard(
                        icon: Icons.science,
                        label: 'Science',
                        context: context,
                      ),
                      _buildCategoryCard(
                        icon: Icons.history_edu,
                        label: 'History',
                        context: context,
                      ),
                      _buildCategoryCard(
                        icon: Icons.movie,
                        label: 'Movies & TV',
                        context: context,
                      ),
                      _buildCategoryCard(
                        icon: Icons.public,
                        label: 'World History',
                        context: context,
                      ),
                      _buildCategoryCard(
                        icon: Icons.language,
                        label: 'Geography',
                        context: context,
                      ),
                      _buildCategoryCard(
                        icon: Icons.sports_soccer,
                        label: 'Sports',
                        context: context,
                      ),
                      _buildCategoryCard(
                        icon: Icons.headphones,
                        label: 'Sports',
                        context: context,
                      ),
                      _buildCategoryCard(
                        icon: Icons.music_note,
                        label: 'Music',
                        context: context,
                      ),
                      _buildCategoryCard(
                        icon: Icons.menu_book,
                        label: 'Ppusic',
                        context: context,
                      ),
                      _buildCategoryCard(
                        icon: Icons.book,
                        label: 'Literature',
                        context: context,
                      ),
                      _buildCategoryCard(
                        icon: Icons.audiotrack,
                        label: 'Literature',
                        context: context,
                      ),
                      _buildCategoryCard(
                        icon: Icons.computer,
                        label: 'Technology',
                        context: context,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label quiz coming soon!'),
            backgroundColor: AppColors.lightBlue,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.lightPurple.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.white, size: 48),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
