# KBC-style Quiz (Flutter)

This project adds a simple offline KBC-style quiz to the existing Flutter workspace.

Features added in `lib/`:
- Local question data: `lib/assets/questions.json` (60 mixed questions of GK, Science, Tech)
- Model: `lib/models/question.dart`
- Question loader/service: `lib/services/question_service.dart`
- Quiz UI: `lib/screens/quiz_screen.dart` (50-question randomized quiz, 20s timer)
- App entrypoint updated: `lib/main.dart` now opens the Quiz screen

How to run
1. Ensure Flutter SDK is installed and on your PATH.
2. From the project root (this folder), run:

```powershell
flutter pub get
flutter run
```

Notes
- The quiz loads questions from the bundled JSON asset so it works offline.
- Timer is set to 20 seconds per question; you can tweak `_initialTime` in `quiz_screen.dart`.
- This is a minimal, local implementation designed for quick iteration.

Next steps
- Add more questions or a simple editor to maintain the question bank.
- Add sounds, Lottie animations, lifelines (50:50), scoring/leaderboard persistence.
# kbc_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
