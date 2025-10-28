import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/quiz_model.dart';

@lazySingleton
class QuizProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<QuizModel> _quizzes = [];
  QuizModel? _currentQuiz;
  bool _isLoading = false;
  String? _errorMessage;
  int _currentQuestionIndex = 0;
  List<int> _userAnswers = [];

  List<QuizModel> get quizzes => _quizzes;
  QuizModel? get currentQuiz => _currentQuiz;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentQuestionIndex => _currentQuestionIndex;
  List<int> get userAnswers => _userAnswers;

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

  void startQuiz(QuizModel quiz) {
    _currentQuiz = quiz;
    _currentQuestionIndex = 0;
    _userAnswers = List.filled(quiz.questions.length, -1);
    notifyListeners();
  }

  void answerQuestion(int answerIndex) {
    if (_currentQuiz == null) return;

    if (_currentQuestionIndex < _userAnswers.length) {
      _userAnswers[_currentQuestionIndex] = answerIndex;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_currentQuiz == null) return;

    if (_currentQuestionIndex < _currentQuiz!.questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  int calculateScore() {
    if (_currentQuiz == null) return 0;

    int correctAnswers = 0;
    for (int i = 0; i < _currentQuiz!.questions.length; i++) {
      if (_userAnswers[i] == _currentQuiz!.questions[i].correctAnswerIndex) {
        correctAnswers++;
      }
    }

    return correctAnswers * 100;
  }

  void clearQuiz() {
    _currentQuiz = null;
    _currentQuestionIndex = 0;
    _userAnswers = [];
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
