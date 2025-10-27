import '../models/quiz_model.dart';

class SampleQuizzes {
  static final Map<String, List<QuizModel>> _quizzes = {
    'Science': [
      QuizModel(
        id: 'sci_001',
        title: 'Science Basics',
        category: 'Science',
        description: 'Test your basic science knowledge',
        difficulty: 'Easy',
        totalQuestions: 5,
        questions: [
          QuestionModel(
            id: 'sci_001_q1',
            question: 'What is the chemical symbol for water?',
            options: ['H2O', 'CO2', 'O2', 'N2'],
            correctAnswerIndex: 0,
          ),
          QuestionModel(
            id: 'sci_001_q2',
            question: 'What planet is known as the Red Planet?',
            options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
            correctAnswerIndex: 1,
          ),
          QuestionModel(
            id: 'sci_001_q3',
            question: 'What is the speed of light?',
            options: [
              '300,000 km/s',
              '150,000 km/s',
              '500,000 km/s',
              '100,000 km/s',
            ],
            correctAnswerIndex: 0,
          ),
          QuestionModel(
            id: 'sci_001_q4',
            question: 'What is the largest organ in the human body?',
            options: ['Heart', 'Liver', 'Skin', 'Brain'],
            correctAnswerIndex: 2,
          ),
          QuestionModel(
            id: 'sci_001_q5',
            question: 'How many bones are in the adult human body?',
            options: ['186', '206', '226', '246'],
            correctAnswerIndex: 1,
          ),
        ],
      ),
    ],
    'History': [
      QuizModel(
        id: 'hist_001',
        title: 'World History',
        category: 'History',
        description: 'Journey through major historical events',
        difficulty: 'Medium',
        totalQuestions: 5,
        questions: [
          QuestionModel(
            id: 'hist_001_q1',
            question: 'In which year did World War II end?',
            options: ['1943', '1944', '1945', '1946'],
            correctAnswerIndex: 2,
          ),
          QuestionModel(
            id: 'hist_001_q2',
            question: 'Who was the first President of the United States?',
            options: [
              'Thomas Jefferson',
              'George Washington',
              'Abraham Lincoln',
              'John Adams',
            ],
            correctAnswerIndex: 1,
          ),
          QuestionModel(
            id: 'hist_001_q3',
            question: 'What year did the Titanic sink?',
            options: ['1910', '1912', '1914', '1916'],
            correctAnswerIndex: 1,
          ),
          QuestionModel(
            id: 'hist_001_q4',
            question: 'Who painted the Mona Lisa?',
            options: [
              'Michelangelo',
              'Leonardo da Vinci',
              'Raphael',
              'Donatello',
            ],
            correctAnswerIndex: 1,
          ),
          QuestionModel(
            id: 'hist_001_q5',
            question: 'What ancient wonder of the world still exists today?',
            options: [
              'Colossus of Rhodes',
              'Hanging Gardens of Babylon',
              'Great Pyramid of Giza',
              'Lighthouse of Alexandria',
            ],
            correctAnswerIndex: 2,
          ),
        ],
      ),
    ],
    'Movies & TV': [
      QuizModel(
        id: 'movie_001',
        title: 'Cinema Classics',
        category: 'Movies & TV',
        description: 'Test your knowledge of classic films',
        difficulty: 'Easy',
        totalQuestions: 5,
        questions: [
          QuestionModel(
            id: 'movie_001_q1',
            question: 'Who directed "The Shawshank Redemption"?',
            options: [
              'Steven Spielberg',
              'Frank Darabont',
              'Christopher Nolan',
              'Martin Scorsese',
            ],
            correctAnswerIndex: 1,
          ),
          QuestionModel(
            id: 'movie_001_q2',
            question: 'Which movie won the first ever Oscar for Best Picture?',
            options: ['Wings', 'The Jazz Singer', 'Sunrise', 'Metropolis'],
            correctAnswerIndex: 0,
          ),
          QuestionModel(
            id: 'movie_001_q3',
            question: 'In which year was the first "Star Wars" movie released?',
            options: ['1975', '1977', '1979', '1981'],
            correctAnswerIndex: 1,
          ),
          QuestionModel(
            id: 'movie_001_q4',
            question: 'Who played Iron Man in the Marvel Cinematic Universe?',
            options: [
              'Chris Evans',
              'Chris Hemsworth',
              'Robert Downey Jr.',
              'Mark Ruffalo',
            ],
            correctAnswerIndex: 2,
          ),
          QuestionModel(
            id: 'movie_001_q5',
            question:
                'What is the highest-grossing film of all time (unadjusted)?',
            options: ['Avatar', 'Avengers: Endgame', 'Titanic', 'Avatar 2'],
            correctAnswerIndex: 0,
          ),
        ],
      ),
    ],
    'Geography': [
      QuizModel(
        id: 'geo_001',
        title: 'World Geography',
        category: 'Geography',
        description: 'Explore the world with geography questions',
        difficulty: 'Medium',
        totalQuestions: 5,
        questions: [
          QuestionModel(
            id: 'geo_001_q1',
            question: 'What is the capital of Australia?',
            options: ['Sydney', 'Melbourne', 'Canberra', 'Brisbane'],
            correctAnswerIndex: 2,
          ),
          QuestionModel(
            id: 'geo_001_q2',
            question: 'Which is the longest river in the world?',
            options: ['Amazon', 'Nile', 'Yangtze', 'Mississippi'],
            correctAnswerIndex: 1,
          ),
          QuestionModel(
            id: 'geo_001_q3',
            question: 'How many continents are there?',
            options: ['5', '6', '7', '8'],
            correctAnswerIndex: 2,
          ),
          QuestionModel(
            id: 'geo_001_q4',
            question: 'What is the largest desert in the world?',
            options: ['Sahara', 'Arabian', 'Gobi', 'Antarctic'],
            correctAnswerIndex: 3,
          ),
          QuestionModel(
            id: 'geo_001_q5',
            question: 'Which country has the most islands?',
            options: ['Philippines', 'Indonesia', 'Sweden', 'Norway'],
            correctAnswerIndex: 2,
          ),
        ],
      ),
    ],
  };

  static QuizModel? getQuiz(String category) {
    final quizzes = _quizzes[category];
    if (quizzes != null && quizzes.isNotEmpty) {
      return quizzes[0];
    }
    return null;
  }

  static QuizModel getDefaultQuiz() {
    return QuizModel(
      id: 'default_001',
      title: 'General Knowledge',
      category: 'General',
      description: 'Basic general knowledge questions',
      difficulty: 'Easy',
      totalQuestions: 3,
      questions: [
        QuestionModel(
          id: 'default_001_q1',
          question: 'What is 2 + 2?',
          options: ['3', '4', '5', '6'],
          correctAnswerIndex: 1,
        ),
        QuestionModel(
          id: 'default_001_q2',
          question: 'What color is the sky?',
          options: ['Red', 'Blue', 'Green', 'Yellow'],
          correctAnswerIndex: 1,
        ),
        QuestionModel(
          id: 'default_001_q3',
          question: 'How many days are in a week?',
          options: ['5', '6', '7', '8'],
          correctAnswerIndex: 2,
        ),
      ],
    );
  }
}
