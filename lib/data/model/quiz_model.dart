/// Quiz Model - Bir quiz'in tüm bilgilerini içerir
class QuizModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final List<QuestionModel> questions;
  final String difficulty;
  final int totalQuestions;
  final int timeLimit; // saniye cinsinden
  final String? imageUrl;

  QuizModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.questions,
    this.difficulty = 'medium',
    required this.totalQuestions,
    this.timeLimit = 300,
    this.imageUrl,
  });

  factory QuizModel.fromFirestore(Map<String, dynamic> data, String id) {
    return QuizModel(
      id: id,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      questions:
          (data['questions'] as List?)
              ?.map((q) => QuestionModel.fromMap(q as Map<String, dynamic>))
              .toList() ??
          [],
      difficulty: data['difficulty'] ?? 'medium',
      totalQuestions: data['totalQuestions'] ?? 0,
      timeLimit: data['timeLimit'] ?? 300,
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'category': category,
      'description': description,
      'questions': questions.map((q) => q.toMap()).toList(),
      'difficulty': difficulty,
      'totalQuestions': totalQuestions,
      'timeLimit': timeLimit,
      'imageUrl': imageUrl,
    };
  }
}

/// Soru Modeli
class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
      explanation: map['explanation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
    };
  }
}
