import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late List<Animation<double>> _itemAnimations;

  final FirestoreService _firestoreService = FirestoreService();
  List<UserModel> _topPlayers = [];
  int _userRank = 0;
  bool _isLoading = true;

  // Avatar emojis for display
  final List<String> _avatars = [
    '👑',
    '⭐',
    '🧠',
    '👸',
    '🎓',
    '🍪',
    '⚡',
    '🦉',
    '🎮',
    '🥷',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
          ),
        );

    // Initialize with empty animations, will update after data loads
    _itemAnimations = [];

    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id;

      // Load top players
      final players = await _firestoreService.getTopPlayers(limit: 10);

      // Get user's rank if logged in (with retry for transient errors)
      if (userId != null) {
        try {
          final rank = await _getUserRankWithRetry(userId);
          _userRank = rank;
        } catch (e) {
          debugPrint('Could not get user rank: $e');
          // Keep _userRank at 0 if failed
          _userRank = 0;
        }
      }

      if (mounted) {
        setState(() {
          _topPlayers = players;
          _isLoading = false;

          // Create animations for loaded data
          _itemAnimations = List.generate(_topPlayers.length, (index) {
            final start = (0.2 + (index * 0.05)).clamp(0.0, 1.0);
            final end = (start + 0.4).clamp(0.0, 1.0);
            return Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(start, end, curve: Curves.easeOutCubic),
              ),
            );
          });
        });

        _controller.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error loading leaderboard: $e');
    }
  }

  /// Get user rank with retry logic for transient errors
  Future<int> _getUserRankWithRetry(String userId, {int maxRetries = 3}) async {
    int attempts = 0;
    Duration delay = const Duration(milliseconds: 500);

    while (attempts < maxRetries) {
      try {
        return await _firestoreService.getUserRank(userId);
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          rethrow;
        }
        // Wait before retrying (exponential backoff)
        await Future.delayed(delay * attempts);
      }
    }
    return 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return AppColors.lightPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final user = authProvider.user;

              if (_isLoading && _topPlayers.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _loadLeaderboardData,
                color: AppColors.lightPurple,
                backgroundColor: AppColors.cardBackground,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
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
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFFFD700,
                                              ).withValues(alpha: 0.4),
                                              blurRadius: 20,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '🏆',
                                            style: TextStyle(fontSize: 48),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Global Leaderboard',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Top Players Worldwide',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.lightPurple.withValues(alpha: 0.3),
                                  AppColors.lightBlue.withValues(alpha: 0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.lightPurple.withValues(
                                  alpha: 0.5,
                                ),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.lightPurple.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.buttonGradient,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.lightBlue.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
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
                                        'Your Rank: ${_userRank > 0 ? '#$_userRank' : 'Unranked'}',
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Score: ${user?.totalScore ?? 0} pts',
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),

                    // Top 3 Podium (only show if we have at least 3 players)
                    if (_topPlayers.length >= 3)
                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: _buildPodiumPlace(
                                  player: _topPlayers[1],
                                  rank: 2,
                                  height: 100,
                                  animation: _itemAnimations.length > 1
                                      ? _itemAnimations[1]
                                      : _fadeAnimation,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildPodiumPlace(
                                  player: _topPlayers[0],
                                  rank: 1,
                                  height: 130,
                                  animation: _itemAnimations.isNotEmpty
                                      ? _itemAnimations[0]
                                      : _fadeAnimation,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildPodiumPlace(
                                  player: _topPlayers[2],
                                  rank: 3,
                                  height: 80,
                                  animation: _itemAnimations.length > 2
                                      ? _itemAnimations[2]
                                      : _fadeAnimation,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),

                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final actualIndex = index + 3;
                            if (actualIndex >= _topPlayers.length) return null;

                            final animation =
                                _itemAnimations.length > actualIndex
                                ? _itemAnimations[actualIndex]
                                : _fadeAnimation;

                            return AnimatedBuilder(
                              animation: animation,
                              builder: (context, child) {
                                final value = animation.value;
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: _buildLeaderboardItem(
                                        player: _topPlayers[actualIndex],
                                        rank: actualIndex + 1,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: _topPlayers.length > 3
                              ? _topPlayers.length - 3
                              : 0,
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPodiumPlace({
    required UserModel player,
    required int rank,
    required double height,
    required Animation<double> animation,
  }) {
    final name = player.displayName;
    final score = player.totalScore;
    final avatar = _avatars[rank - 1]; // Get avatar from list
    final color = _getRankColor(rank);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          avatar,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                score >= 1000
                    ? '${(score / 1000).toStringAsFixed(1)}K'
                    : '$score pts',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withValues(alpha: 0.8),
                      color.withValues(alpha: 0.4),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: rank == 1 ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeaderboardItem({required UserModel player, required int rank}) {
    final name = player.displayName;
    final score = player.totalScore;
    final avatar = _avatars[rank - 1]; // Get avatar from list
    final color = _getRankColor(rank);

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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.2),
            ),
            child: Center(
              child: Text(avatar, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score >= 1000
                    ? '${(score / 1000).toStringAsFixed(1)}K'
                    : '$score',
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.star, color: color, size: 16),
                  const SizedBox(width: 4),
                  Text('pts', style: TextStyle(color: color, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
