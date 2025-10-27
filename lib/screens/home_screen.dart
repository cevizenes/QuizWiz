import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

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
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              // Show loading indicator in center while user data is loading
              if (authProvider.isLoadingUserData) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show main content once user data is loaded
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Header with Logo
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 1000),
                                tween: Tween(begin: 0.8, end: 1.0),
                                curve: Curves.elasticOut,
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.lightPurple
                                                .withValues(alpha: 0.3),
                                            blurRadius: 30,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Q',
                                          style: TextStyle(
                                            fontSize: 56,
                                            fontWeight: FontWeight.bold,
                                            foreground: Paint()
                                              ..shader =
                                                  const LinearGradient(
                                                    colors: [
                                                      AppColors.lightBlue,
                                                      AppColors.lightPink,
                                                    ],
                                                  ).createShader(
                                                    const Rect.fromLTWH(
                                                      0,
                                                      0,
                                                      200,
                                                      70,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppConstants.appName,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Welcome, ${authProvider.user?.displayName ?? 'Player'}!',
                                style: TextStyle(
                                  color: AppColors.white.withValues(alpha: 0.9),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Play Now Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 1200),
                            tween: Tween(begin: 0.9, end: 1.0),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: AppColors.buttonGradient,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.lightBlue.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Quiz feature coming soon!',
                                          ),
                                          backgroundColor: Colors.blue,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      minimumSize: const Size(
                                        double.infinity,
                                        60,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      color: AppColors.white,
                                      size: 28,
                                    ),
                                    label: const Text(
                                      'Play Now',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Featured Quizzes Section
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Featured Quizzes',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          height: 140,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            children: [
                              _buildFeaturedQuizCard(
                                icon: Icons.language,
                                title: 'Space Exploration',
                                context: context,
                              ),
                              _buildFeaturedQuizCard(
                                icon: Icons.public,
                                title: 'World History',
                                context: context,
                              ),
                              _buildFeaturedQuizCard(
                                icon: Icons.emoji_events,
                                title: 'World History',
                                context: context,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Recent Activity Section
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Recent Activity',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: _buildRecentActivityItem(
                            name: 'John Doe',
                            activity: 'completed "Pop Culture Quiz Quiz',
                            context: context,
                          ),
                        ),

                        const SizedBox(height: 100),
                      ],
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

  Widget _buildFeaturedQuizCard({
    required IconData icon,
    required String title,
    required BuildContext context,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightPurple.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$title quiz coming soon!'),
                backgroundColor: AppColors.lightBlue,
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.lightBlue, size: 48),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityItem({
    required String name,
    required String activity,
    required BuildContext context,
  }) {
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
              shape: BoxShape.circle,
              gradient: AppColors.buttonGradient,
            ),
            child: const Icon(Icons.person, color: AppColors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name $activity',
                  style: const TextStyle(color: AppColors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
