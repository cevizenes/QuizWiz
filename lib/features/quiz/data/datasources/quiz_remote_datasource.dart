import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/quiz_result_model.dart';

@lazySingleton
class QuizRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _quizResultsCollection =>
      _firestore.collection('quiz_results');
  CollectionReference get _usersCollection => _firestore.collection('users');

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
        id: '',
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
}
