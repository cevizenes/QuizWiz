import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lightPurple.withValues(
                                alpha: 0.3,
                              ),
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
                        'Profile',
                        style: TextStyle(color: AppColors.white, fontSize: 20),
                      ),

                      const SizedBox(height: 40),

                      // Statistics Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.lightPurple.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            // User Avatar and Name
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.buttonGradient,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: AppColors.white,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.displayName ?? 'Player',
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user?.email ?? '',
                                        style: TextStyle(
                                          color: AppColors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Statistics
                            const Text(
                              'Statistics',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'Total Quizzes',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      user?.totalQuizzes.toString() ?? '0',
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: AppColors.white.withValues(alpha: 0.3),
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Quizzes Won',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      user?.quizzesWon.toString() ?? '0',
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: AppColors.white.withValues(alpha: 0.3),
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Win Rate',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _calculateWinRate(
                                        user?.totalQuizzes ?? 0,
                                        user?.quizzesWon ?? 0,
                                      ),
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Divider(
                              color: AppColors.white.withValues(alpha: 0.2),
                            ),

                            const SizedBox(height: 16),

                            // Total Quizzes and Score
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Total Quizzes: ${user?.totalQuizzes ?? 0}',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Win Rate: ${_calculateWinRate(user?.totalQuizzes ?? 0, user?.quizzesWon ?? 0)}',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Achievements Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.lightPurple.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Achievements',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildAchievementBadge(
                                  Icons.emoji_events,
                                  true,
                                ),
                                _buildAchievementBadge(Icons.star, false),
                                _buildAchievementBadge(Icons.star, false),
                                _buildAchievementBadge(Icons.star, false),
                                _buildAchievementBadge(
                                  Icons.arrow_downward,
                                  false,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Settings',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Edit Profile Button
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.lightPurple.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.settings,
                            color: AppColors.white,
                          ),
                          title: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.edit,
                            color: AppColors.lightPink,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Edit profile coming soon!'),
                                backgroundColor: AppColors.lightBlue,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Logout Button
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.buttonGradient,
                          borderRadius: BorderRadius.circular(12),
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(IconData icon, bool isEarned) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white.withValues(alpha: isEarned ? 1.0 : 0.3),
          width: 2,
        ),
        color: isEarned
            ? AppColors.lightBlue.withValues(alpha: 0.2)
            : Colors.transparent,
      ),
      child: Icon(
        icon,
        color: AppColors.white.withValues(alpha: isEarned ? 1.0 : 0.3),
        size: 24,
      ),
    );
  }

  String _calculateWinRate(int totalQuizzes, int quizzesWon) {
    if (totalQuizzes == 0) return '0%';
    final rate = (quizzesWon / totalQuizzes * 100).round();
    return '$rate%';
  }
}
