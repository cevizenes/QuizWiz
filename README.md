# 🎯 QuizWiz - Interactive Quiz Application

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

QuizWiz is a modern, feature-rich quiz application built with Flutter and Firebase. Test your knowledge across multiple categories, compete with others on the leaderboard, and track your progress!

## ✨ Features

### 🎮 Core Features

- **Multiple Quiz Categories** - Science, History, Geography, Movies, Sports, and more
- **Real-time Leaderboard** - Compete with players worldwide
- **Progress Tracking** - Track your quiz history and statistics
- **Achievement System** - Unlock badges as you progress
- **User Profiles** - Personalized user experience with detailed stats

### 🎨 UI/UX Features

- **Beautiful Animations** - Smooth transitions and interactive elements
- **Gradient Design** - Modern gradient-based UI
- **Responsive Layout** - Optimized for all screen sizes
- **Dark Theme** - Eye-friendly dark mode design

### 🔐 Authentication

- **Email/Password Authentication** - Secure user login
- **Firebase Authentication** - Robust and secure auth system

---

## 📱 Screenshots

### Authentication Screens

<table>
<tr>
    <td align="center"><b>Splash Screen</b></td>
    <td align="center"><b>Login</b></td>
    <td align="center"><b>Sign Up</b></td>
  </tr>
  <tr>
    <td><img src="screenshots/splash.png" width="250"/></td>
    <td><img src="screenshots/login.png" width="250"/></td>
    <td><img src="screenshots/signup.png" width="250"/></td>
  </tr>
</table>

### Main Application

<table>
<tr>
    <td align="center"><b>Home Screen</b></td>
    <td align="center"><b>Categories</b></td>
    <td align="center"><b>Quiz Screen</b></td>
  </tr>
  <tr>
    <td><img src="screenshots/home.png" width="250"/></td>
    <td><img src="screenshots/categories.png" width="250"/></td>
    <td><img src="screenshots/quiz.png" width="250"/></td>
  </tr>
</table>

### Results & Profile

<table>
<tr>
    <td align="center"><b>Quiz Results</b></td>
    <td align="center"><b>Leaderboard</b></td>
    <td align="center"><b>Profile</b></td>
  </tr>
  <tr>
    <td><img src="screenshots/result.png" width="250"/></td>
    <td><img src="screenshots/leaderboard.png" width="250"/></td>
    <td><img src="screenshots/profile.png" width="250"/></td>
  </tr>
</table>

---

## 🏗️ Architecture

This project follows **Feature-Based Clean Architecture** principles for better separation of concerns, testability, scalability, and maintainability.

```
lib/
│
├── 🎨 common/                              # Shared UI & Constants
│   ├── constants/
│   │   └── app_constants.dart             # App-wide constants
│   └── widgets/                            # Reusable widgets
│       ├── achievement_badge.dart
│       ├── category_card.dart
│       ├── custom_stat_card.dart
│       └── setting_list_item.dart
│
├── 🔧 core/                                # Infrastructure Layer
│   ├── extensions/                         # Dart extensions
│   │   ├── context_extensions.dart        # BuildContext helpers
│   │   └── string_extensions.dart         # String helpers
│   ├── services/                           # Singleton services
│   │   └── firebase_service.dart          # Firebase operations
│   ├── theme/                              # App theming
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── utils/                              # Utility classes
│       ├── date_utils.dart                # Date formatting
│       └── validators.dart                # Form validation
│
└── 🎯 features/                            # Feature Modules
    │
    ├── 🔐 auth/                            # Authentication Feature
    │   ├── data/
    │   │   └── models/
    │   │       └── user_model.dart
    │   └── presentation/
    │       ├── providers/
    │       │   └── auth_provider.dart
    │       └── screens/
    │           ├── splash_screen.dart
    │           ├── login_screen.dart
    │           └── sign_up_screen.dart
    │
    ├── 📚 categories/                      # Categories Feature
    │   └── presentation/
    │       └── screens/
    │           └── categories_screen.dart
    │
    ├── 🏠 home/                            # Home Feature
    │   └── presentation/
    │       └── screens/
    │           ├── home_screen.dart
    │           └── main_navigation.dart
    │
    ├── 🏆 leaderboard/                     # Leaderboard Feature
    │   ├── data/
    │   │   └── datasources/
    │   │       └── leaderboard_remote_datasource.dart
    │   └── presentation/
    │       └── screens/
    │           └── leaderboard_screen.dart
    │
    ├── 👤 profile/                         # Profile Feature
    │   └── presentation/
    │       └── screens/
    │           └── profile_screen.dart
    │
    └── 📝 quiz/                            # Quiz Feature
        ├── data/
        │   ├── datasources/
        │   │   └── quiz_remote_datasource.dart
        │   ├── models/
        │   │   ├── quiz_model.dart
        │   │   └── quiz_result_model.dart
        │   └── sample/
        │       └── sample_quizzes.dart    # Sample quiz data
        └── presentation/
            ├── providers/
            │   └── quiz_provider.dart
            └── screens/
                ├── quiz_question_screen.dart
                └── quiz_result_screen.dart
```

### Architecture Principles

#### 🎯 Feature-Based Structure

Each feature is self-contained with its own:

- **Data Layer** - Models, datasources, repositories
- **Presentation Layer** - Screens, widgets, providers

#### 🔧 Core Layer

Infrastructure and utilities shared across all features:

- **Extensions** - Enhance existing Dart classes
- **Services** - Singleton services (Firebase, API)
- **Utils** - Helper functions and validators
- **Theme** - App-wide styling

#### 🎨 Common Layer

Shared UI components and constants:

- **Widgets** - Reusable across features
- **Constants** - App-wide configuration

### Benefits

**Modularity** - Features are independent and portable  
**Scalability** - Easy to add new features  
**Maintainability** - Clear separation of concerns  
**Testability** - Each layer can be tested independently  
**Team Collaboration** - Multiple developers can work in parallel  
**Code Reusability** - Shared code in common and core layers

---

## 🛠️ Tech Stack

### Frontend

- **Flutter** - UI framework
- **Provider** - State management
- **Dart** - Programming language

### Backend & Services

- **Firebase Authentication** - User authentication
- **Cloud Firestore** - NoSQL database
- **Firebase Core** - Firebase initialization

### Development Tools

- **Flutter Lints** - Code quality
- **Flutter Dotenv** - Environment variables

---

## 🚀 Getting Started

### Prerequisites

```bash
Flutter SDK: >=3.0.0
Dart SDK: >=3.0.0
```

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/cevizenes/QuizWiz.git
   cd QuizWiz
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Setup**

   Create a `.env` file in the root directory:

   ```env
   # Add your environment variables here if needed
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🔥 Firebase Configuration

### Required Services

- Firebase Authentication (Email/Password)
- Cloud Firestore (Database)

### Firestore Collections

#### `users`

```javascript
{
  "displayName": string,
  "email": string,
  "photoUrl": string?,
  "totalQuizzes": number,
  "quizzesWon": number,
  "totalScore": number,
  "rank": number,
  "achievements": array,
  "createdAt": timestamp
}
```

#### `quizzes`

```javascript
{
  "title": string,
  "category": string,
  "description": string,
  "difficulty": string,
  "totalQuestions": number,
  "timeLimit": number,
  "questions": array,
  "isFeatured": boolean
}
```

#### `quiz_results`

```javascript
{
  "userId": string,
  "quizId": string,
  "category": string,
  "score": number,
  "correctAnswers": number,
  "totalQuestions": number,
  "timeTaken": number,
  "completedAt": timestamp
}
```

### Required Indexes

Create composite indexes in Firebase Console:

1. **users collection**

   - Fields: `totalScore` (Descending), `__name__` (Descending)

2. **quiz_results collection**

   - Fields: `userId` (Ascending), `completedAt` (Descending)

3. **quizzes collection**
   - Fields: `category` (Ascending), `__name__` (Ascending)
   - Fields: `isFeatured` (Ascending), `__name__` (Ascending)

---

## 📊 Features in Detail

### 🎯 Quiz System

- **12+ Categories** - Diverse topics to test your knowledge
- **Timed Questions** - 30 seconds per question
- **Score System** - Base points (100) + time bonus (up to 60 points)
- **Progress Tracking** - Visual progress indicator
- **Instant Feedback** - See correct answers immediately

### 🏆 Leaderboard

- **Global Rankings** - See where you stand worldwide
- **Top 10 Players** - Podium display for top 3
- **Real-time Updates** - Automatic refresh on pull
- **User Rank** - Your current position
- **Score Display** - Total points and achievements

### 👤 User Profile

- **Statistics Dashboard** - Total quizzes, wins, win rate, total score
- **Achievement Badges** - Unlock as you progress
- **Quiz History** - Recent quiz results with categories
- **Settings** - Profile management options
- **Logout** - Secure sign out

---

## 🎨 Design System

### Color Palette

- **Primary**: Gradient (Purple to Blue)
  - `#6B4CE6` → `#4E9FEB`
- **Secondary**: Light Blue, Light Pink
  - `#4E9FEB`, `#F472B6`
- **Background**: Dark Blue shades
  - Card: `#1E293B`
  - Background: `#0F172A`
- **Accent**: Gold (`#FFD700`), Green, Purple

### Typography

- **Display Large**: Bold, 32-36px
- **Headings**: Bold, 20-28px
- **Body**: Regular, 14-16px
- **Captions**: Light, 10-12px

### Components

- **Cards** - Rounded corners (12-16px), gradient borders
- **Buttons** - Gradient backgrounds, shadow effects
- **Animations** - Elastic, ease-out curves
- **Icons** - Outlined style with gradient overlays

---

## 📱 State Management

The app uses **Provider** for state management with main providers:

### AuthProvider

- User authentication state
- User data management (Firestore sync)
- Sign in/up/out functionality
- Error handling
- Loading states

### QuizProvider

- Quiz data fetching from Firestore
- Current quiz state management
- Answer tracking
- Score calculation
- Question navigation

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.2

  # Firebase
  firebase_core: ^3.15.2
  firebase_auth: ^5.7.0
  cloud_firestore: ^5.6.12

  # Environment
  flutter_dotenv: ^5.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---
