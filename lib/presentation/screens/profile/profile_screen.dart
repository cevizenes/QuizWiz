import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/datasources/remote/firestore_service.dart';
import '../../../data/model/quiz_result_model.dart';
import '../../../core/theme/app_colors.dart';
import '../auth/login_screen.dart';
import '../../widgets/custom_stat_card.dart';
import '../../widgets/achievement_badge.dart';
import '../../widgets/setting_list_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final FirestoreService _firestoreService = FirestoreService();
  List<QuizResultModel> _recentQuizzes = [];
  bool _isLoadingHistory = true;

  // Category icons mapping
  final Map<String, String> _categoryIcons = {
    'Science': '🔬',
    'History': '📜',
    'Geography': '🌍',
    'Movies & TV': '🎬',
    'Sports': '⚽',
    'Music': '🎵',
    'Technology': '💻',
    'Mathematics': '🔢',
    'Art': '🎨',
    'Food': '🍕',
    'Nature': '🌳',
    'Languages': '🗣️',
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
    _loadQuizHistory();
  }

  Future<void> _loadQuizHistory() async {
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.id;

    if (userId == null) {
      if (mounted) {
        setState(() {
          _isLoadingHistory = false;
        });
      }
      return;
    }

    try {
      final history = await _getQuizHistoryWithRetry(userId);
      if (mounted) {
        setState(() {
          _recentQuizzes = history;
          _isLoadingHistory = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recentQuizzes = [];
          _isLoadingHistory = false;
        });
      }
    }
  }

  Future<List<QuizResultModel>> _getQuizHistoryWithRetry(
    String userId, {
    int maxRetries = 2,
  }) async {
    int attempts = 0;
    const delay = Duration(milliseconds: 300);

    while (attempts < maxRetries) {
      try {
        return await _firestoreService
            .getUserQuizHistory(userId, limit: 3)
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          return []; // Return empty list instead of throwing
        }
        await Future.delayed(delay);
      }
    }
    return [];
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
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isLoadingUserData) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                );
              }

              final user = authProvider.user;

              return SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 800),
                            tween: Tween(begin: 0.0, end: 1.0),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.buttonGradient,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.lightPurple.withValues(
                                          alpha: 0.5,
                                        ),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: AppColors.white,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user?.displayName ?? 'Player',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user?.email ?? '',
                            style: TextStyle(
                              color: AppColors.white.withValues(alpha: 0.7),
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 32),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Statistics',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: CustomStatCard(
                                  icon: Icons.quiz,
                                  label: 'Quizzes',
                                  value: user?.totalQuizzes.toString() ?? '0',
                                  color: AppColors.lightBlue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomStatCard(
                                  icon: Icons.emoji_events,
                                  label: 'Won',
                                  value: user?.quizzesWon.toString() ?? '0',
                                  color: const Color(0xFFFFD700),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: CustomStatCard(
                                  icon: Icons.trending_up,
                                  label: 'Win Rate',
                                  value: _calculateWinRate(
                                    user?.totalQuizzes ?? 0,
                                    user?.quizzesWon ?? 0,
                                  ),
                                  color: AppColors.lightPink,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomStatCard(
                                  icon: Icons.star,
                                  label: 'Total Score',
                                  value: (user?.totalScore ?? 0).toString(),
                                  color: AppColors.lightPurple,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Achievements',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.lightPurple.withValues(alpha: 0.2),
                                  AppColors.lightBlue.withValues(alpha: 0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.lightPurple.withValues(
                                  alpha: 0.3,
                                ),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    AchievementBadge(
                                      icon: '🏆',
                                      title: 'First Win',
                                      isEarned: true,
                                    ),
                                    AchievementBadge(
                                      icon: '🔥',
                                      title: '5 Streak',
                                      isEarned: false,
                                    ),
                                    AchievementBadge(
                                      icon: '⭐',
                                      title: 'Perfect',
                                      isEarned: false,
                                    ),
                                    AchievementBadge(
                                      icon: '💎',
                                      title: 'Master',
                                      isEarned: false,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Recent Quizzes',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          if (_isLoadingHistory)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white,
                                  ),
                                ),
                              ),
                            )
                          else if (_recentQuizzes.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.lightPurple.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'No quiz history yet.\nStart playing to see your results!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.white.withValues(
                                      alpha: 0.7,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                          else
                            ..._recentQuizzes.map((quiz) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildQuizHistoryItem(quiz),
                              );
                            }),

                          const SizedBox(height: 16),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          SettingListItem(
                            icon: Icons.person_outline,
                            title: 'Edit Profile',
                            subtitle: 'Update your personal information',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Edit profile coming soon!'),
                                  backgroundColor: AppColors.lightBlue,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          SettingListItem(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            subtitle: 'Manage notification preferences',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Notifications settings coming soon!',
                                  ),
                                  backgroundColor: AppColors.lightBlue,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          SettingListItem(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Privacy',
                            subtitle: 'Privacy and security settings',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Privacy settings coming soon!',
                                  ),
                                  backgroundColor: AppColors.lightBlue,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade400,
                                  Colors.red.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await authProvider.signOut();

                                if (context.mounted) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(
                                Icons.logout,
                                color: AppColors.white,
                              ),
                              label: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuizHistoryItem(QuizResultModel quiz) {
    final accuracy = ((quiz.correctAnswers / quiz.totalQuestions) * 100)
        .round();
    final icon = _categoryIcons[quiz.category] ?? '📝';

    // Format date
    final now = DateTime.now();
    final difference = now.difference(quiz.completedAt);
    String dateText;
    if (difference.inDays == 0) {
      dateText = 'Today';
    } else if (difference.inDays == 1) {
      dateText = 'Yesterday';
    } else if (difference.inDays < 7) {
      dateText = '${difference.inDays} days ago';
    } else {
      dateText = '${(difference.inDays / 7).floor()} weeks ago';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightPurple.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.category,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${quiz.correctAnswers}/${quiz.totalQuestions} correct • $accuracy% accuracy',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateText,
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${quiz.score}',
                style: const TextStyle(
                  color: AppColors.lightBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'pts',
                style: TextStyle(color: AppColors.lightBlue, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateWinRate(int totalQuizzes, int quizzesWon) {
    if (totalQuizzes == 0) return '0%';
    final rate = (quizzesWon / totalQuizzes * 100).round();
    return '$rate%';
  }
}
