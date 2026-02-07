# Workout Tracker App - Screen Flow Guide

## App Screens Overview

### 1. Splash Screen
**Purpose**: Initial loading screen with authentication check
**Elements**:
- Large fitness center icon (blue)
- "Workout Tracker" title text
- Loading spinner
**Flow**: Checks for existing session → redirects to Login or Home

---

### 2. Login Screen
**Purpose**: User authentication
**Elements**:
- Fitness center icon at top
- "Workout Tracker" title
- Email input field (with @ icon)
- Password input field (with lock icon)
- "Login" button (blue)
- "Don't have an account? Register" link
**Validation**:
- Email format validation with regex
- Password minimum 6 characters
- Error messages for invalid credentials

---

### 3. Register Screen
**Purpose**: New user registration
**Elements**:
- Fitness center icon
- "Create Account" title
- Name input field (with person icon)
- Email input field (with @ icon)
- Password input field (with lock icon)
- Confirm Password input field (with lock outline icon)
- "Register" button
**Validation**:
- All fields required
- Email format validation
- Password confirmation match
- Duplicate email detection

---

### 4. Home Screen (Bottom Navigation)
**Purpose**: Main navigation hub
**Bottom Navigation Tabs**:
1. **Workouts** (fitness_center icon)
2. **Statistics** (bar_chart icon)
3. **Groups** (group icon)

**Top App Bar**:
- Title: "Workout Tracker"
- Logout button (right side)

---

## Tab 1: Workouts Screen

### Workout Plans List
**Purpose**: Display available workout plans
**Elements**:
- List of workout plan cards
- Each card contains:
  - Fitness icon + Plan name (bold, large)
  - Description text (gray)
  - Number of exercises
  - Exercise chips showing exercise names

**Available Plans**:
1. **Beginner Full Body**
   - 3 exercises: Push-ups, Squats, Plank
   
2. **Upper Body Strength**
   - 4 exercises: Bench Press, Pull-ups, Shoulder Press, Bicep Curls
   
3. **Lower Body Power**
   - 4 exercises: Squats, Deadlifts, Lunges, Calf Raises

**Interaction**: Tap any card → Opens Workout Tracker Screen

---

### Workout Tracker Screen
**Purpose**: Active workout session tracking
**Top Bar**: Plan name as title

**Exercise Cards** (one per exercise):
Each card shows:
- Exercise name (bold, large)
- Target: "X sets × Y reps @ Zkg"
- Two counters with +/- buttons:
  - Sets Completed
  - Reps per Set
- Green checkmark when target sets reached

**Bottom Button**:
- "Complete Workout" (green, full width)
- Saves session to history

---

## Tab 2: Statistics Screen

### Overview Cards
Two summary cards at top:
1. **Total Workouts**
   - Fitness icon (blue)
   - Number count (large)
   
2. **Total Minutes**
   - Timer icon (green)
   - Minutes count (large)

### Last 7 Days Chart
**Purpose**: Visual workout frequency
**Elements**:
- Line chart showing workouts per day
- X-axis: Actual day names (Mon-Sun)
- Y-axis: Number of workouts
- Blue curved line with dots

### Workout Breakdown
**Purpose**: Show workout distribution
**Elements**:
- Card for each workout plan type
- Shows: Plan name + "X times" count
- Fitness icon for each

### Recent Sessions
**Purpose**: List recent workout history
**Elements**:
- List of session cards
- Each shows:
  - Green checkmark icon
  - Plan name
  - Date and time
  - Duration in minutes

---

## Tab 3: Groups Screen

### Empty State (No Groups)
**Elements**:
- Large group icon (gray)
- "No groups yet" text
- "Create Group" button
- "Join Group" text button

### Groups List (With Groups)
**Purpose**: Display user's workout groups
**Elements**:
- List of group cards
- Each card shows:
  - Group icon (blue)
  - Group name (bold, large)
  - Description text (gray)
  - People icon + member count

**Floating Action Buttons** (bottom right):
1. Create Group (+)
2. Join Group (login icon)

**Interaction**: Tap card → Opens group details dialog

---

### Create Group Dialog
**Purpose**: Create new workout group
**Elements**:
- "Create Group" title
- Group Name input field
- Description input field (multiline)
- Cancel button
- Create button (blue)

---

### Join Group Dialog
**Purpose**: Join existing group
**Elements**:
- "Join Group" title
- Group ID input field
- Cancel button
- Join button (blue)

---

### Group Details Dialog
**Purpose**: View group information and activity
**Elements**:
- Group name (title)
- Description
- Member count
- Group ID (small, gray)
- "Recent Group Activity" section
- List of member workouts:
  - Fitness icon
  - Plan name
  - Date/time
  - Duration

---

## Navigation Flow Diagram

```
┌─────────────────┐
│  Splash Screen  │
└────────┬────────┘
         │
    ┌────┴────┐
    │ Login?  │
    └────┬────┘
         │
    ┌────┴─────────┐
    │              │
   Yes            No
    │              │
    ▼              ▼
┌────────┐   ┌──────────┐
│  Home  │   │  Login   │
└────────┘   └─────┬────┘
    │              │
    │         ┌────┴────┐
    │         │ Register│
    │         └────┬────┘
    │              │
    └──────┬───────┘
           │
    ┌──────┴──────┐
    │  Home (Nav) │
    └──────┬──────┘
           │
    ┌──────┴───────────────────┐
    │                          │
    ▼                          ▼
┌─────────────┐         ┌──────────────┐
│  Workouts   │         │ Statistics   │
└──────┬──────┘         └──────────────┘
       │                       
       ▼                       ▼
┌─────────────┐         ┌──────────────┐
│  Tracker    │         │   Groups     │
└─────────────┘         └──────┬───────┘
                               │
                        ┌──────┴──────┐
                        │ Group Details│
                        └─────────────┘
```

---

## Color Scheme
- **Primary**: Blue (Material Blue)
- **Success**: Green
- **Text Primary**: Black
- **Text Secondary**: Gray (#757575)
- **Background**: White
- **Card**: White with elevation shadow

---

## Icons Used
- fitness_center: Main app icon, workouts
- login: Authentication
- person: User profile
- email: Email input
- lock: Password input
- bar_chart: Statistics
- group: Groups feature
- add: Create new
- check_circle: Completed items
- timer: Duration tracking
- logout: Sign out

---

## User Experience Flow

### First Time User Journey:
1. Open app → Splash Screen (1s)
2. See Login Screen
3. Click "Don't have an account? Register"
4. Fill registration form
5. Auto-login → Home Screen (Workouts tab)
6. Browse workout plans
7. Select a plan → Start tracking
8. Complete workout → Return to home
9. View Statistics tab → See first workout logged
10. Create/Join a group in Groups tab

### Returning User Journey:
1. Open app → Splash Screen
2. Auto-login → Home Screen
3. Continue tracking workouts
4. View progress in Statistics
5. Share progress in Groups

---

## Data Flow

### Authentication Flow:
```
User Input → AuthService → SHA-256 Hash → SharedPreferences
                    ↓
              User Model → Current Session
```

### Workout Flow:
```
Select Plan → WorkoutTrackerScreen → Track Progress
                        ↓
                  Complete → WorkoutSession
                        ↓
              WorkoutSessionService → SharedPreferences
                        ↓
                  Statistics Screen → Display Charts
```

### Group Flow:
```
Create/Join Group → WorkoutGroupService → SharedPreferences
         ↓
    Group Activity ← Fetch Member Sessions
         ↓
   Display Feed
```

---

## Technical Implementation Notes

1. **State Management**: Each screen uses StatefulWidget with setState()
2. **Data Persistence**: All data stored in SharedPreferences as JSON
3. **Security**: Passwords hashed with SHA-256 (crypto package)
4. **Charts**: FL Chart library for line graphs
5. **Date Formatting**: Intl package for date/time display
6. **Navigation**: Bottom navigation + standard push/pop navigation
7. **Validation**: Real-time form validation with error messages
8. **Loading States**: Circular progress indicators during async operations
9. **User Feedback**: SnackBars for success/error messages

---

This comprehensive guide shows the complete user experience and technical flow of the Workout Tracker app.
