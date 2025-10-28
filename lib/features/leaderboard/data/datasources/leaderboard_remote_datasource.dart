import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/data/models/user_model.dart';

@lazySingleton
class LeaderboardRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _usersCollection => _firestore.collection('users');

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

  Future<int> getTotalUsersCount() async {
    try {
      final count = await _usersCollection.count().get();
      return count.count ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
