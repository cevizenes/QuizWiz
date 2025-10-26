import 'package:cloud_firestore/cloud_firestore.dart';

/// Quiz sonuç modeli - Kullanıcının quiz sonuçlarını saklar
class QuizResultModel {
  final String id;
  final String userId;
  final String quizId;
  final int correctAnswers;
  final int totalQuestions;
  final int score;
  final int timeSpent; // saniye cinsinden
  final List<int> userAnswers; // Kullanıcının verdiği cevapların indeksleri
  final DateTime completedAt;

  QuizResultModel({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.score,
    this.timeSpent = 0,
    required this.userAnswers,
    required this.completedAt,
  });

  // Doğru cevap yüzdesi
  double get accuracy => (correctAnswers / totalQuestions) * 100;

  // Sınıflandırma
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
      correctAnswers: data['correctAnswers'] ?? 0,
      totalQuestions: data['totalQuestions'] ?? 0,
      score: data['score'] ?? 0,
      timeSpent: data['timeSpent'] ?? 0,
      userAnswers: List<int>.from(data['userAnswers'] ?? []),
      completedAt:
          (data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'quizId': quizId,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'score': score,
      'timeSpent': timeSpent,
      'userAnswers': userAnswers,
      'completedAt': Timestamp.fromDate(completedAt),
    };
  }
}
