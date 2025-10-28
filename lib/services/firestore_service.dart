import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_result_model.dart';
import '../models/user_model.dart';

/// Firestore Database Service
/// Provides methods for interacting with Firestore collections
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _quizResultsCollection =>
      _firestore.collection('quiz_results');

  /// Save quiz result to Firestore
  Future<void> saveQuizResult({
    required String userId,
    required String quizId,
    required String category,
    required int score,
    required int correctAnswers,
    required int totalQuestions,
    required int timeTaken,
  }) async {
    try {
      final quizResult = QuizResultModel(
        id: '', // Firestore will generate
        userId: userId,
        quizId: quizId,
        category: category,
        score: score,
        correctAnswers: correctAnswers,
        totalQuestions: totalQuestions,
        timeTaken: timeTaken,
        completedAt: DateTime.now(),
      );

      await _quizResultsCollection.add(quizResult.toMap());
    } catch (e) {
      throw Exception('Failed to save quiz result: $e');
    }
  }

  /// Update user statistics after completing a quiz
  Future<void> updateUserStatistics({
    required String userId,
    required int scoreToAdd,
    required bool isWin,
  }) async {
    try {
      final userDoc = _usersCollection.doc(userId);
      final userData = await userDoc.get();

      if (userData.exists) {
        final currentData = userData.data() as Map<String, dynamic>;
        final currentScore = currentData['totalScore'] ?? 0;
        final currentQuizzes = currentData['totalQuizzes'] ?? 0;
        final currentWins = currentData['quizzesWon'] ?? 0;

        await userDoc.update({
          'totalScore': currentScore + scoreToAdd,
          'totalQuizzes': currentQuizzes + 1,
          'quizzesWon': isWin ? currentWins + 1 : currentWins,
          'lastActive': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Failed to update user statistics: $e');
    }
  }

  /// Get user's quiz history
  Future<List<QuizResultModel>> getUserQuizHistory(
    String userId, {
    int limit = 10,
  }) async {
    try {
      final querySnapshot = await _quizResultsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('completedAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map(
            (doc) => QuizResultModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get quiz history: $e');
    }
  }

  /// Get top players for leaderboard
  Future<List<UserModel>> getTopPlayers({int limit = 10}) async {
    try {
      final querySnapshot = await _usersCollection
          .orderBy('totalScore', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map(
            (doc) => UserModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get top players: $e');
    }
  }

  /// Get user rank in leaderboard
  Future<int> getUserRank(String userId) async {
    try {
      final userDoc = await _usersCollection.doc(userId).get();
      if (!userDoc.exists) return 0;

      final userData = userDoc.data() as Map<String, dynamic>;
      final userScore = userData['totalScore'] ?? 0;

      final higherScoreCount = await _usersCollection
          .where('totalScore', isGreaterThan: userScore)
          .count()
          .get();

      return (higherScoreCount.count ?? 0) + 1;
    } catch (e) {
      throw Exception('Failed to get user rank: $e');
    }
  }

  /// Stream of top players for real-time updates
  Stream<List<UserModel>> getTopPlayersStream({int limit = 10}) {
    return _usersCollection
        .orderBy('totalScore', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => UserModel.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  /// Get category statistics
  Future<Map<String, int>> getCategoryStatistics(String userId) async {
    try {
      final querySnapshot = await _quizResultsCollection
          .where('userId', isEqualTo: userId)
          .get();

      final Map<String, int> categoryStats = {};

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final category = data['category'] as String;
        categoryStats[category] = (categoryStats[category] ?? 0) + 1;
      }

      return categoryStats;
    } catch (e) {
      throw Exception('Failed to get category statistics: $e');
    }
  }

  /// Check if user has completed any quizzes
  Future<bool> hasCompletedQuizzes(String userId) async {
    try {
      final querySnapshot = await _quizResultsCollection
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get total users count
  Future<int> getTotalUsersCount() async {
    try {
      final count = await _usersCollection.count().get();
      return count.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Get total quizzes played count
  Future<int> getTotalQuizzesPlayedCount() async {
    try {
      final count = await _quizResultsCollection.count().get();
      return count.count ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
