import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final int totalQuizzes;
  final int quizzesWon;
  final int totalScore;
  final int rank;
  final List<String> achievements;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.totalQuizzes = 0,
    this.quizzesWon = 0,
    this.totalScore = 0,
    this.rank = 0,
    this.achievements = const [],
    required this.createdAt,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'],
      totalQuizzes: data['totalQuizzes'] ?? 0,
      quizzesWon: data['quizzesWon'] ?? 0,
      totalScore: data['totalScore'] ?? 0,
      rank: data['rank'] ?? 0,
      achievements: List<String>.from(data['achievements'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'totalQuizzes': totalQuizzes,
      'quizzesWon': quizzesWon,
      'totalScore': totalScore,
      'rank': rank,
      'achievements': achievements,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    int? totalQuizzes,
    int? quizzesWon,
    int? totalScore,
    int? rank,
    List<String>? achievements,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
      quizzesWon: quizzesWon ?? this.quizzesWon,
      totalScore: totalScore ?? this.totalScore,
      rank: rank ?? this.rank,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
