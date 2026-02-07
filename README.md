# Workout Tracker Flutter App

A comprehensive Flutter application for tracking workouts with authentication, workout plans, statistics, and group features.

## Features

### 1. Authentication
- **Login**: Secure user authentication
- **Register**: New user registration with email and password
- Automatic session management

### 2. Workout Plans
- Pre-configured workout plans for different fitness levels
- Detailed exercise information including sets, reps, and weights
- Easy-to-navigate workout selection interface

### 3. Workout Tracking
- Track workouts according to predefined plans
- Real-time progress tracking for sets and reps
- Complete workout sessions with timestamps
- Mark exercises as completed

### 4. Statistics & History
- View historical workout data
- Visual charts showing workout trends over the past 7 days
- Summary statistics (total workouts, total time)
- Workout breakdown by plan type
- Recent session history with details

### 5. Group Tracking
- Create workout groups
- Join existing groups using Group ID
- Share workout progress with group members
- View group activity feed
- Track group members' workouts

## Technical Stack

### Frontend (Flutter)
- **Framework**: Flutter
- **State Management**: Built-in StatefulWidget with Provider-ready architecture
- **Local Storage**: SharedPreferences for data persistence
- **Charts**: FL Chart for statistics visualization
- **Date Formatting**: Intl package

### Backend (NestJS)
- **Framework**: NestJS
- **Database**: MongoDB with Mongoose
- **Authentication**: JWT with Passport
- **Validation**: class-validator
- **Security**: bcrypt password hashing

## Project Structure

```
.
├── lib/                          # Flutter app source
├── main.dart                     # Application entry point
├── models/                       # Data models
│   ├── user.dart
│   ├── workout_plan.dart
│   ├── workout_session.dart
│   └── workout_group.dart
├── services/                     # Business logic
│   ├── auth_service.dart
│   ├── workout_plan_service.dart
│   ├── workout_session_service.dart
│   └── workout_group_service.dart
└── screens/                      # UI screens
    ├── login_screen.dart
    ├── register_screen.dart
    ├── home_screen.dart
    ├── workout_plans_screen.dart
    ├── workout_tracker_screen.dart
    ├── statistics_screen.dart
    └── groups_screen.dart
└── backend/                      # NestJS backend API
    ├── src/
    │   ├── auth/                 # Authentication module
    │   ├── users/                # Users module
    │   ├── workout-plans/        # Workout plans module
    │   ├── workout-sessions/     # Sessions module
    │   ├── groups/               # Groups module
    │   ├── app.module.ts
    │   └── main.ts
    ├── package.json
    └── README.md                 # Backend documentation
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Node.js (>=16.0.0) - for backend
- MongoDB (>=4.4) - for backend

### Installation

#### Flutter App

1. Clone the repository:
```bash
git clone https://github.com/somkheartk/app-workout-tracker-flutter.git
cd app-workout-tracker-flutter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

#### Backend API (Optional)

The app works with local storage by default, but you can optionally set up the backend:

1. Navigate to backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Configure environment:
```bash
cp .env.example .env
# Edit .env with your MongoDB URI
```

4. Start MongoDB:
```bash
# Using MongoDB service
sudo systemctl start mongod

# Or using Docker
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

5. Run the backend:
```bash
npm run start:dev
```

See [backend/README.md](backend/README.md) for detailed API documentation.

## Usage

### First Time Setup
1. Launch the app
2. Register a new account with email and password
3. Login with your credentials

### Tracking Workouts
1. Navigate to the "Workouts" tab
2. Select a workout plan
3. Track your progress by updating sets and reps
4. Complete the workout to save it to history

### Viewing Statistics
1. Go to the "Statistics" tab
2. View your workout summary and trends
3. Check recent sessions and workout breakdown

### Group Features
1. Navigate to the "Groups" tab
2. Create a new group or join an existing one
3. Share your Group ID with friends to invite them
4. View group activity and member workouts

## Default Workout Plans

The app includes three default workout plans:
1. **Beginner Full Body** - Push-ups, Squats, Plank
2. **Upper Body Strength** - Bench Press, Pull-ups, Shoulder Press, Bicep Curls
3. **Lower Body Power** - Squats, Deadlifts, Lunges, Calf Raises

## Data Persistence

All data is stored locally using SharedPreferences:
- User accounts and authentication
- Workout plans
- Session history
- Group information

## License

This project is open source and available under the MIT License.