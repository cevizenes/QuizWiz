import 'package:cloud_firestore/cloud_firestore.dart';

class QuizResultModel {
  final String id;
  final String userId;
  final String quizId;
  final String category;
  final int correctAnswers;
  final int totalQuestions;
  final int score;
  final int timeTaken;
  final DateTime completedAt;

  QuizResultModel({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.category,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.score,
    this.timeTaken = 0,
    required this.completedAt,
  });

  double get accuracy => (correctAnswers / totalQuestions) * 100;

  String get grade {
    if (accuracy >= 90) return 'Excellent';
    if (accuracy >= 70) return 'Great';
    if (accuracy >= 50) return 'Good';
    return 'Try Again';
  }

  factory QuizResultModel.fromFirestore(Map<String, dynamic> data, String id) {
    return QuizResultModel(
      id: id,
      userId: data['userId'] ?? '',
      quizId: data['quizId'] ?? '',
      category: data['category'] ?? 'Unknown',
      correctAnswers: data['correctAnswers'] ?? 0,
      totalQuestions: data['totalQuestions'] ?? 0,
      score: data['score'] ?? 0,
      timeTaken: data['timeTaken'] ?? 0,
      completedAt:
          (data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'quizId': quizId,
      'category': category,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'score': score,
      'timeTaken': timeTaken,
      'completedAt': Timestamp.fromDate(completedAt),
    };
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }
}
