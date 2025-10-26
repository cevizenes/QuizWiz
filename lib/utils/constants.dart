class AppConstants {
  static const String appName = 'QuizWiz';
  static const String appTagline = 'Knowledge Always Pays Off!';

  static const List<String> categories = [
    'Science',
    'History',
    'Movies & TV',
    'World History',
    'Geography',
    'Sports',
    'Music',
    'Literature',
    'Technology',
    'Art',
    'Food',
    'Nature',
  ];

  static const Map<String, String> categoryIcons = {
    'Science': 'atom',
    'History': 'history_edu',
    'Movies & TV': 'movie',
    'World History': 'public',
    'Geography': 'map',
    'Sports': 'sports_soccer',
    'Music': 'music_note',
    'Literature': 'menu_book',
    'Technology': 'computer',
    'Art': 'palette',
    'Food': 'restaurant',
    'Nature': 'nature',
  };

  static const int pointsPerCorrectAnswer = 100;
  static const int streakBonusPoints = 50;

  static const int questionsPerQuiz = 10;
  static const int timePerQuestionSeconds = 30;

  static const int homeTabIndex = 0;
  static const int categoriesTabIndex = 1;
  static const int profileTabIndex = 2;
  static const int leaderboardTabIndex = 3;
}
