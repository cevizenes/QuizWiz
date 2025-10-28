import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AchievementBadge extends StatelessWidget {
  final String icon;
  final String title;
  final bool isEarned;

  const AchievementBadge({
    super.key,
    required this.icon,
    required this.title,
    required this.isEarned,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isEarned
                      ? LinearGradient(
                          colors: [AppColors.lightBlue, AppColors.lightPurple],
                        )
                      : null,
                  color: isEarned
                      ? null
                      : AppColors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: isEarned
                        ? AppColors.white
                        : AppColors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: isEarned
                      ? [
                          BoxShadow(
                            color: AppColors.lightBlue.withValues(alpha: 0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: TextStyle(
                      fontSize: 28,
                      color: isEarned
                          ? AppColors.white
                          : AppColors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isEarned
                      ? AppColors.white
                      : AppColors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
