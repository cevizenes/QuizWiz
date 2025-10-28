import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/quiz/data/models/quiz_result_model.dart';

@lazySingleton
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get quizzesCollection => _firestore.collection('quizzes');
  CollectionReference get quizResultsCollection =>
      _firestore.collection('quiz_results');

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await usersCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await usersCollection.doc(user.id).set(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await usersCollection.doc(userId).update(data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> saveQuizResult(QuizResultModel result) async {
    try {
      await quizResultsCollection.add(result.toFirestore());
    } catch (e) {
      throw Exception('Failed to save quiz result: $e');
    }
  }

  Future<List<QuizResultModel>> getUserQuizHistory(
    String userId, {
    int limit = 10,
  }) async {
    try {
      final querySnapshot = await quizResultsCollection
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

  Future<List<UserModel>> getTopPlayers({int limit = 10}) async {
    try {
      final querySnapshot = await usersCollection
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

  Future<int> getUserRank(String userId) async {
    try {
      final userDoc = await usersCollection.doc(userId).get();
      if (!userDoc.exists) return 0;

      final userData = userDoc.data() as Map<String, dynamic>;
      final userScore = userData['totalScore'] ?? 0;

      final higherScoreCount = await usersCollection
          .where('totalScore', isGreaterThan: userScore)
          .count()
          .get();

      return (higherScoreCount.count ?? 0) + 1;
    } catch (e) {
      throw Exception('Failed to get user rank: $e');
    }
  }
}
