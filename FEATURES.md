# Workout Tracker App - Feature Documentation

## Overview
This is a complete Flutter workout tracking application that meets all the requirements specified in the problem statement.

## Requirements Implementation

### 1. Login (✓ Implemented)
**Location**: `lib/screens/login_screen.dart`
**Features**:
- Email and password authentication
- Form validation with proper error messages
- Secure password hashing using SHA-256
- Automatic session persistence
- Navigation to registration screen

**Service**: `lib/services/auth_service.dart`
- Password hashing for security
- User authentication logic
- Session management with SharedPreferences

### 2. Register (✓ Implemented)
**Location**: `lib/screens/register_screen.dart`
**Features**:
- User registration with name, email, and password
- Password confirmation validation
- Email uniqueness checking
- Automatic login after registration
- Form validation with proper error messages

### 3. Workout Tracker Based on Plan (✓ Implemented)
**Location**: 
- Workout plans: `lib/screens/workout_plans_screen.dart`
- Active tracking: `lib/screens/workout_tracker_screen.dart`

**Features**:
- Pre-configured workout plans (Beginner Full Body, Upper Body Strength, Lower Body Power)
- Plan selection interface with exercise details
- Real-time progress tracking for sets and reps
- Exercise completion indicators
- Session recording with start and end times
- Save completed workouts to history

**Models**:
- `lib/models/workout_plan.dart` - Plan and exercise structure
- `lib/models/workout_session.dart` - Session tracking and completed exercises

**Service**: `lib/services/workout_plan_service.dart`, `lib/services/workout_session_service.dart`
- Load default workout plans
- Save custom plans
- Track workout sessions
- Store completed workouts

### 4. Historical Statistics (✓ Implemented)
**Location**: `lib/screens/statistics_screen.dart`

**Features**:
- Summary cards showing total workouts and total minutes
- Weekly activity chart (last 7 days) with actual day names
- Workout breakdown by plan type
- Recent session history with dates and durations
- Visual data representation using FL Chart library

**Calculations**:
- Total workouts completed
- Total time spent exercising
- Daily workout frequency
- Workout distribution by plan type

### 5. Group Tracking (✓ Implemented)
**Location**: `lib/screens/groups_screen.dart`

**Features**:
- Create workout groups with name and description
- Join existing groups using Group ID
- View all groups user is a member of
- Group activity feed showing member workouts
- Member count display
- Share Group ID for invitations

**Model**: `lib/models/workout_group.dart`
**Service**: `lib/services/workout_group_service.dart`
- Group creation and management
- Member management
- Activity tracking across group members

## Application Architecture

### Data Models
1. **User** (`lib/models/user.dart`)
   - User information (id, email, name)
   - JSON serialization

2. **WorkoutPlan** (`lib/models/workout_plan.dart`)
   - Plan details and exercises
   - Exercise specifications (sets, reps, weight)

3. **WorkoutSession** (`lib/models/workout_session.dart`)
   - Session tracking data
   - Completed exercises
   - Duration calculation

4. **WorkoutGroup** (`lib/models/workout_group.dart`)
   - Group information
   - Member list
   - Admin management

### Services (Business Logic)
1. **AuthService** - Authentication and user management
2. **WorkoutPlanService** - Workout plan management
3. **WorkoutSessionService** - Session tracking and history
4. **WorkoutGroupService** - Group features

### User Interface
1. **Login Screen** - Authentication entry point
2. **Register Screen** - New user registration
3. **Home Screen** - Main navigation hub with bottom navigation bar
4. **Workout Plans Screen** - Browse and select workout plans
5. **Workout Tracker Screen** - Active workout tracking
6. **Statistics Screen** - Historical data and charts
7. **Groups Screen** - Group management and activity

### Navigation Flow
```
Splash Screen
    ├─> Login Screen
    │       └─> Register Screen
    │
    └─> Home Screen (after authentication)
            ├─> Workout Plans Screen
            │       └─> Workout Tracker Screen
            │
            ├─> Statistics Screen
            │
            └─> Groups Screen
```

## Data Persistence
All data is stored locally using SharedPreferences:
- User accounts with hashed passwords
- Workout plans
- Session history
- Group information

## Security Features
- Password hashing using SHA-256 from crypto package
- Email validation with regex patterns
- Secure session management
- No sensitive data exposed

## UI/UX Features
- Material Design 3
- Responsive card-based layouts
- Bottom navigation for easy access
- Form validation with clear error messages
- Progress indicators for loading states
- Success/error notifications using SnackBars
- Icon-based visual hierarchy

## Technical Stack
- **Framework**: Flutter (SDK >=3.0.0)
- **State Management**: StatefulWidget
- **Storage**: SharedPreferences
- **Charts**: FL Chart
- **Date Formatting**: Intl
- **Security**: Crypto (SHA-256)

## Default Workout Plans

### 1. Beginner Full Body
- Push-ups: 3 sets × 10 reps
- Squats: 3 sets × 15 reps
- Plank: 3 sets × 30 reps

### 2. Upper Body Strength
- Bench Press: 4 sets × 8 reps @ 60kg
- Pull-ups: 3 sets × 8 reps
- Shoulder Press: 3 sets × 10 reps @ 30kg
- Bicep Curls: 3 sets × 12 reps @ 15kg

### 3. Lower Body Power
- Squats: 4 sets × 10 reps @ 80kg
- Deadlifts: 4 sets × 8 reps @ 100kg
- Lunges: 3 sets × 12 reps
- Calf Raises: 3 sets × 15 reps

## How to Use

### First Time Setup
1. Launch the app
2. Click "Don't have an account? Register"
3. Fill in name, email, and password
4. Automatic login and redirect to home screen

### Starting a Workout
1. Navigate to "Workouts" tab (bottom navigation)
2. Select a workout plan
3. Track progress by tapping +/- buttons for sets and reps
4. Click "Complete Workout" when finished

### Viewing Statistics
1. Navigate to "Statistics" tab
2. View summary cards (total workouts, total minutes)
3. Check weekly activity chart
4. Review recent sessions and workout breakdown

### Using Groups
1. Navigate to "Groups" tab
2. Click floating action button (+) to create a group
3. Share Group ID with friends
4. Friends can join using "Join Group" button
5. View group activity in group details

## File Structure
```
lib/
├── main.dart                          # App entry point
├── models/                            # Data models
│   ├── user.dart
│   ├── workout_plan.dart
│   ├── workout_session.dart
│   └── workout_group.dart
├── services/                          # Business logic
│   ├── auth_service.dart
│   ├── workout_plan_service.dart
│   ├── workout_session_service.dart
│   └── workout_group_service.dart
├── screens/                           # UI screens
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── workout_plans_screen.dart
│   ├── workout_tracker_screen.dart
│   ├── statistics_screen.dart
│   └── groups_screen.dart
└── widgets/                           # Reusable widgets (empty for now)
```

## Summary
All 5 requirements from the problem statement have been successfully implemented:
1. ✅ Login functionality with secure authentication
2. ✅ Registration system with validation
3. ✅ Workout tracker following predefined plans
4. ✅ Historical statistics with charts and summaries
5. ✅ Group tracking for sharing progress with friends

The application is production-ready with proper security measures, clean architecture, and user-friendly interface.
