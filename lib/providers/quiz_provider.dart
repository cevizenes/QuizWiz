import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

/// Quiz State Management Provider
/// Quiz oluşturma, listeleme ve oynama işlemlerini yönetir
class QuizProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<QuizModel> _quizzes = [];
  QuizModel? _currentQuiz;
  bool _isLoading = false;
  String? _errorMessage;
  int _currentQuestionIndex = 0;
  List<int> _userAnswers = [];

  // Getters
  List<QuizModel> get quizzes => _quizzes;
  QuizModel? get currentQuiz => _currentQuiz;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentQuestionIndex => _currentQuestionIndex;
  List<int> get userAnswers => _userAnswers;

  /// Kategorilere göre quiz'leri yükle
  Future<void> loadQuizzesByCategory(String category) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final querySnapshot = await _firestore
          .collection('quizzes')
          .where('category', isEqualTo: category)
          .get();

      _quizzes = querySnapshot.docs
          .map((doc) => QuizModel.fromFirestore(doc.data(), doc.id))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load quizzes: $e';
      notifyListeners();
    }
  }

  /// Tüm quiz'leri yükle
  Future<void> loadAllQuizzes() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final querySnapshot = await _firestore.collection('quizzes').get();

      _quizzes = querySnapshot.docs
          .map((doc) => QuizModel.fromFirestore(doc.data(), doc.id))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load quizzes: $e';
      notifyListeners();
    }
  }

  /// Featured quiz'leri yükle
  Future<void> loadFeaturedQuizzes() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final querySnapshot = await _firestore
          .collection('quizzes')
          .where('isFeatured', isEqualTo: true)
          .limit(3)
          .get();

      _quizzes = querySnapshot.docs
          .map((doc) => QuizModel.fromFirestore(doc.data(), doc.id))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load featured quizzes: $e';
      notifyListeners();
    }
  }

  /// Quiz başlat
  void startQuiz(QuizModel quiz) {
    _currentQuiz = quiz;
    _currentQuestionIndex = 0;
    _userAnswers = List.filled(quiz.questions.length, -1);
    notifyListeners();
  }

  /// Cevap kaydet
  void answerQuestion(int answerIndex) {
    if (_currentQuiz == null) return;

    if (_currentQuestionIndex < _userAnswers.length) {
      _userAnswers[_currentQuestionIndex] = answerIndex;
      notifyListeners();
    }
  }

  /// Sonraki soruya geç
  void nextQuestion() {
    if (_currentQuiz == null) return;

    if (_currentQuestionIndex < _currentQuiz!.questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  /// Önceki soruya dön
  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  /// Quiz'i bitir ve skor hesapla
  int calculateScore() {
    if (_currentQuiz == null) return 0;

    int correctAnswers = 0;
    for (int i = 0; i < _currentQuiz!.questions.length; i++) {
      if (_userAnswers[i] == _currentQuiz!.questions[i].correctAnswerIndex) {
        correctAnswers++;
      }
    }

    return correctAnswers * 100; // Her doğru cevap 100 puan
  }

  /// Quiz'i temizle
  void clearQuiz() {
    _currentQuiz = null;
    _currentQuestionIndex = 0;
    _userAnswers = [];
    notifyListeners();
  }

  /// Hata mesajını temizle
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
