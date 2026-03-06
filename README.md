# Air Force Quiz League (Flutter)

This project adds a simple offline Air Force Quiz League quiz to the existing Flutter workspace.

## 🌐 Live Demo

Play the quiz online: **[https://mishraumang288.github.io/Quiz-App-Flutter/](https://mishraumang288.github.io/Quiz-App-Flutter/)**

## 📱 Download APK

Download the latest APK from the [Releases](https://github.com/mishraumang288/Quiz-App-Flutter/releases) page.

## Features

- Local question data: `lib/assets/questions.json` (60 mixed questions of GK, Science, Tech)
- Model: `lib/models/question.dart`
- Question loader/service: `lib/services/question_service.dart`
- Quiz UI: `lib/screens/quiz_screen.dart` (50-question randomized quiz, 20s timer)
- App entrypoint updated: `lib/main.dart` now opens the Quiz screen

## How to run

1. Ensure Flutter SDK is installed and on your PATH.
2. From the project root (this folder), run:

```powershell
flutter pub get
flutter run
```

## Deployment

### GitHub Pages (Web)
The app is automatically deployed to GitHub Pages on every push to the main/master branch. The workflow is defined in `.github/workflows/deploy-web.yml`.

### APK Releases
To create a new APK release:
1. Update the version in `pubspec.yaml`
2. Create and push a git tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
3. GitHub Actions will automatically build and release the APK

Alternatively, you can manually trigger the release workflow from the Actions tab on GitHub.

## Notes
- The quiz loads questions from the bundled JSON asset so it works offline.
- Timer is set to 20 seconds per question; you can tweak `_initialTime` in `quiz_screen.dart`.
- This is a minimal, local implementation designed for quick iteration.

## Next steps
- Add more questions or a simple editor to maintain the question bank.
- Add sounds, Lottie animations, lifelines (50:50), scoring/leaderboard persistence.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
