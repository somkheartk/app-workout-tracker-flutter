# Quick Start Guide

## For Developers

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDEs)

### Setup Instructions

1. **Clone the repository**
```bash
git clone https://github.com/somkheartk/app-workout-tracker-flutter.git
cd app-workout-tracker-flutter
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# For mobile device or emulator
flutter run

# For web
flutter run -d chrome

# For desktop (macOS)
flutter run -d macos
```

### Testing the App

#### Create a Test Account
1. Launch the app
2. Click "Don't have an account? Register"
3. Fill in:
   - Name: Test User
   - Email: test@example.com
   - Password: password123
4. Click Register

#### Test Workout Tracking
1. Go to Workouts tab
2. Select "Beginner Full Body"
3. Increment sets and reps using +/- buttons
4. Click "Complete Workout"
5. Check Statistics tab to see the logged workout

#### Test Group Feature
1. Go to Groups tab
2. Click the + button to create a group
3. Enter group name and description
4. Share the Group ID with friends
5. View group activity

### Project Structure
```
app-workout-tracker-flutter/
├── lib/
│   ├── main.dart              # App entry point
│   ├── models/                # Data models
│   ├── services/              # Business logic
│   ├── screens/               # UI screens
│   └── widgets/               # Reusable widgets
├── pubspec.yaml               # Dependencies
├── analysis_options.yaml      # Linting rules
├── README.md                  # Project overview
├── FEATURES.md                # Feature documentation
└── SCREENS_GUIDE.md          # UI/UX guide
```

### Key Files to Know

#### Entry Point
- `lib/main.dart` - App initialization and routing

#### Authentication
- `lib/screens/login_screen.dart` - Login UI
- `lib/screens/register_screen.dart` - Registration UI
- `lib/services/auth_service.dart` - Auth logic

#### Workout Tracking
- `lib/screens/workout_plans_screen.dart` - Plan selection
- `lib/screens/workout_tracker_screen.dart` - Active tracking
- `lib/services/workout_plan_service.dart` - Plan management
- `lib/services/workout_session_service.dart` - Session tracking

#### Statistics
- `lib/screens/statistics_screen.dart` - Charts and history

#### Groups
- `lib/screens/groups_screen.dart` - Group management
- `lib/services/workout_group_service.dart` - Group logic

### Dependencies Used
```yaml
dependencies:
  flutter: sdk: flutter
  cupertino_icons: ^1.0.2      # iOS style icons
  provider: ^6.0.5              # State management (for future use)
  shared_preferences: ^2.2.2    # Local storage
  intl: ^0.18.1                 # Date formatting
  fl_chart: ^0.65.0             # Charts
  crypto: ^3.0.3                # Password hashing
```

### Development Commands

#### Format code
```bash
dart format lib/
```

#### Analyze code
```bash
flutter analyze
```

#### Run tests (when added)
```bash
flutter test
```

#### Build for production
```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web
```

### Troubleshooting

#### Issue: Dependencies not found
```bash
flutter clean
flutter pub get
```

#### Issue: Build errors
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

#### Issue: Hot reload not working
- Restart the app
- Or use `R` in terminal to restart

### Code Style Guide

1. **Follow Dart style guide**
   - Use `dart format` for consistent formatting
   - Follow `flutter_lints` rules

2. **Naming conventions**
   - Classes: PascalCase (e.g., `WorkoutPlan`)
   - Variables: camelCase (e.g., `workoutSession`)
   - Constants: UPPER_SNAKE_CASE (e.g., `_USERS_KEY`)
   - Private members: prefix with `_` (e.g., `_loadData()`)

3. **File organization**
   - Models in `lib/models/`
   - Services in `lib/services/`
   - Screens in `lib/screens/`
   - Widgets in `lib/widgets/`

### Adding New Features

#### To add a new workout plan:
Edit `lib/services/workout_plan_service.dart`:
```dart
WorkoutPlan(
  id: '4',
  name: 'Your Plan Name',
  description: 'Description',
  createdAt: DateTime.now(),
  exercises: [
    WorkoutExercise(name: 'Exercise 1', sets: 3, reps: 10),
    // Add more exercises
  ],
)
```

#### To add a new screen:
1. Create file in `lib/screens/new_screen.dart`
2. Import in parent screen
3. Add navigation:
```dart
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => NewScreen()),
);
```

### Data Storage

All data is stored in SharedPreferences with these keys:
- `current_user` - Currently logged-in user
- `users` - All registered users
- `workout_plans` - Workout plans
- `workout_sessions` - Completed sessions
- `workout_groups` - Groups

To clear all data (for testing):
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.clear();
```

### Security Notes

1. **Password Hashing**: Uses SHA-256 (crypto package)
2. **No network calls**: All data is local
3. **No API keys**: Self-contained app
4. **Email validation**: Regex-based validation

### Performance Tips

1. Use `const` constructors where possible
2. Avoid rebuilding widgets unnecessarily
3. Use `ListView.builder` for long lists
4. Dispose controllers in `dispose()` method

### Future Enhancements

Potential features to add:
- [ ] Exercise database with images
- [ ] Custom workout plan creation
- [ ] Timer for timed exercises
- [ ] Rest timer between sets
- [ ] Progress photos
- [ ] Calendar view of workouts
- [ ] Export data (CSV/PDF)
- [ ] Cloud sync
- [ ] Social features
- [ ] Achievements/badges
- [ ] Exercise form videos
- [ ] Workout reminders
- [ ] Dark mode

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Support

For issues or questions:
- Create an issue on GitHub
- Check the documentation files
- Review the code comments

### License

MIT License - See LICENSE file for details

---

Happy coding! 💪🏋️‍♂️
