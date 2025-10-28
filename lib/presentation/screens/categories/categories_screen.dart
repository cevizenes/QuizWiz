import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/sample/sample_quizzes.dart';
import '../quiz/quiz_question_screen.dart';
import '../../widgets/category_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _itemAnimations;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.science, 'label': 'Science'},
    {'icon': Icons.history_edu, 'label': 'History'},
    {'icon': Icons.movie, 'label': 'Movies & TV'},
    {'icon': Icons.public, 'label': 'Geography'},
    {'icon': Icons.sports_soccer, 'label': 'Sports'},
    {'icon': Icons.music_note, 'label': 'Music'},
    {'icon': Icons.book, 'label': 'Literature'},
    {'icon': Icons.computer, 'label': 'Technology'},
    {'icon': Icons.palette, 'label': 'Art'},
    {'icon': Icons.restaurant, 'label': 'Food'},
    {'icon': Icons.nature, 'label': 'Nature'},
    {'icon': Icons.language, 'label': 'Languages'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create staggered animations for each category card
    _itemAnimations = List.generate(_categories.length, (index) {
      final start = (index * 0.04).clamp(0.0, 1.0);
      final end = ((index * 0.04) + 0.6).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

              // Categories Grid with staggered animation
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.3,
                        ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _itemAnimations[index],
                        builder: (context, child) {
                          final category = _categories[index];
                          final label = category['label'] as String;
                          final icon = category['icon'] as IconData;

                          return Opacity(
                            opacity: _itemAnimations[index].value,
                            child: Transform.scale(
                              scale: _itemAnimations[index].value,
                              child: CategoryCard(
                                icon: icon,
                                label: label,
                                onTap: () {
                                  final quiz = SampleQuizzes.getQuiz(label);
                                  if (quiz != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            QuizQuestionScreen(quiz: quiz),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '$label quiz coming soon!',
                                        ),
                                        backgroundColor: AppColors.lightBlue,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
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
}
