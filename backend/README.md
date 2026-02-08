# Workout Tracker Backend API

NestJS backend API for the Workout Tracker Flutter application.

## Features

- **Authentication**: JWT-based authentication with bcrypt password hashing
- **User Management**: User registration and profile management
- **Workout Plans**: CRUD operations for workout plans with default templates
- **Workout Sessions**: Track completed workout sessions with statistics
- **Groups**: Create and manage workout groups with activity tracking
- **MongoDB Database**: Mongoose integration for data persistence
- **Validation**: Built-in request validation using class-validator
- **CORS**: Configured for Flutter app integration

## Tech Stack

- **Framework**: NestJS
- **Database**: MongoDB with Mongoose
- **Authentication**: JWT (JSON Web Tokens) with Passport
- **Validation**: class-validator and class-transformer
- **Security**: bcrypt for password hashing

## Prerequisites

- Node.js (v16 or higher)
- MongoDB (v4.4 or higher)
- npm or yarn

## Installation

1. Install dependencies:
```bash
cd backend
npm install
```

2. Create a `.env` file in the backend directory:
```bash
cp .env.example .env
```

3. Configure your environment variables in `.env`:
```env
PORT=3000
NODE_ENV=development

MONGODB_URI=mongodb://localhost:27017/workout_tracker

JWT_SECRET=your-secret-key-change-in-production
JWT_EXPIRES_IN=7d
```

4. Start MongoDB:
```bash
# Using MongoDB service
sudo systemctl start mongod

# Or using Docker
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

## Running the Application

### Development Mode
```bash
npm run start:dev
```

The API will be available at `http://localhost:3000`

### Production Mode
```bash
npm run build
npm run start:prod
```

## API Endpoints

### Authentication

#### Register
```http
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "name": "John Doe",
  "password": "password123"
}
```

Response:
```json
{
  "access_token": "jwt-token-here",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

#### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

### Users

#### Get Profile (Protected)
```http
GET /users/profile
Authorization: Bearer {token}
```

#### Get All Users (Protected)
```http
GET /users
Authorization: Bearer {token}
```

### Workout Plans

#### Get All Workout Plans (Protected)
```http
GET /workout-plans
Authorization: Bearer {token}
```

#### Get Single Workout Plan (Protected)
```http
GET /workout-plans/:id
Authorization: Bearer {token}
```

#### Create Workout Plan (Protected)
```http
POST /workout-plans
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Custom Workout",
  "description": "My custom workout plan",
  "exercises": [
    {
      "name": "Push-ups",
      "sets": 3,
      "reps": 10,
      "weight": 0
    }
  ]
}
```

#### Update Workout Plan (Protected)
```http
PUT /workout-plans/:id
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Updated Workout Name"
}
```

#### Delete Workout Plan (Protected)
```http
DELETE /workout-plans/:id
Authorization: Bearer {token}
```

### Workout Sessions

#### Get All Sessions (Protected)
```http
GET /workout-sessions
Authorization: Bearer {token}
```

#### Get Session Statistics (Protected)
```http
GET /workout-sessions/stats
Authorization: Bearer {token}
```

#### Create Session (Protected)
```http
POST /workout-sessions
Authorization: Bearer {token}
Content-Type: application/json

{
  "planName": "Beginner Full Body",
  "completedExercises": [
    {
      "name": "Push-ups",
      "completedSets": 3,
      "completedReps": 10
    }
  ],
  "startTime": "2024-01-01T10:00:00Z",
  "endTime": "2024-01-01T10:30:00Z",
  "duration": 30
}
```

#### Delete Session (Protected)
```http
DELETE /workout-sessions/:id
Authorization: Bearer {token}
```

### Groups

#### Get All Groups (Protected)
```http
GET /groups
Authorization: Bearer {token}
```

#### Get Single Group (Protected)
```http
GET /groups/:id
Authorization: Bearer {token}
```

#### Create Group (Protected)
```http
POST /groups
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Fitness Buddies",
  "description": "My workout group"
}
```

#### Join Group (Protected)
```http
POST /groups/join
Authorization: Bearer {token}
Content-Type: application/json

{
  "groupId": "group-uuid"
}
```

#### Add Activity to Group (Protected)
```http
POST /groups/:id/activity
Authorization: Bearer {token}
Content-Type: application/json

{
  "workoutName": "Upper Body Strength",
  "duration": 45
}
```

#### Leave Group (Protected)
```http
DELETE /groups/:id/leave
Authorization: Bearer {token}
```

#### Delete Group (Protected, Admin only)
```http
DELETE /groups/:id
Authorization: Bearer {token}
```

## Default Workout Plans

The API automatically creates three default workout plans on first run:

1. **Beginner Full Body**
   - Push-ups: 3 sets × 10 reps
   - Squats: 3 sets × 15 reps
   - Plank: 3 sets × 30 reps

2. **Upper Body Strength**
   - Bench Press: 4 sets × 8 reps @ 60kg
   - Pull-ups: 3 sets × 8 reps
   - Shoulder Press: 3 sets × 10 reps @ 30kg
   - Bicep Curls: 3 sets × 12 reps @ 15kg

3. **Lower Body Power**
   - Squats: 4 sets × 10 reps @ 80kg
   - Deadlifts: 4 sets × 8 reps @ 100kg
   - Lunges: 3 sets × 12 reps
   - Calf Raises: 3 sets × 15 reps

## Database Schema

### Users Collection
- `_id`: ObjectId (Primary Key)
- `email`: String (Unique, Required)
- `name`: String (Required)
- `password`: String (Required, Hashed)
- `createdAt`: Timestamp (Auto-generated)
- `updatedAt`: Timestamp (Auto-generated)

### Workout Plans Collection
- `_id`: ObjectId (Primary Key)
- `name`: String (Required)
- `description`: String
- `exercises`: Array (Required)
- `createdAt`: Timestamp (Auto-generated)
- `updatedAt`: Timestamp (Auto-generated)

### Workout Sessions Collection
- `_id`: ObjectId (Primary Key)
- `planName`: String (Required)
- `completedExercises`: Array (Required)
- `startTime`: Date (Required)
- `endTime`: Date (Required)
- `duration`: Number (Required)
- `userId`: ObjectId (Reference to Users, Required)
- `createdAt`: Timestamp (Auto-generated)
- `updatedAt`: Timestamp (Auto-generated)

### Groups Collection
- `_id`: ObjectId (Primary Key)
- `name`: String (Required)
- `description`: String
- `adminId`: String (Required)
- `memberIds`: Array of Strings
- `activities`: Array
- `createdAt`: Timestamp (Auto-generated)
- `updatedAt`: Timestamp (Auto-generated)

## Project Structure

```
backend/
├── src/
│   ├── auth/                   # Authentication module
│   │   ├── dto/
│   │   │   └── auth.dto.ts
│   │   ├── auth.controller.ts
│   │   ├── auth.module.ts
│   │   ├── auth.service.ts
│   │   ├── jwt-auth.guard.ts
│   │   ├── jwt.strategy.ts
│   │   ├── local-auth.guard.ts
│   │   └── local.strategy.ts
│   ├── users/                  # Users module
│   │   ├── user.entity.ts
│   │   ├── users.controller.ts
│   │   ├── users.module.ts
│   │   └── users.service.ts
│   ├── workout-plans/          # Workout plans module
│   │   ├── dto/
│   │   │   └── workout-plan.dto.ts
│   │   ├── workout-plan.entity.ts
│   │   ├── workout-plans.controller.ts
│   │   ├── workout-plans.module.ts
│   │   └── workout-plans.service.ts
│   ├── workout-sessions/       # Workout sessions module
│   │   ├── dto/
│   │   │   └── workout-session.dto.ts
│   │   ├── workout-session.entity.ts
│   │   ├── workout-sessions.controller.ts
│   │   ├── workout-sessions.module.ts
│   │   └── workout-sessions.service.ts
│   ├── groups/                 # Groups module
│   │   ├── dto/
│   │   │   └── group.dto.ts
│   │   ├── group.entity.ts
│   │   ├── groups.controller.ts
│   │   ├── groups.module.ts
│   │   └── groups.service.ts
│   ├── app.module.ts           # Root module
│   └── main.ts                 # Application entry point
├── .env.example                # Environment variables template
├── .gitignore
├── nest-cli.json
├── package.json
├── tsconfig.json
└── README.md
```

## Security Features

- **Password Hashing**: bcrypt with salt rounds
- **JWT Authentication**: Secure token-based authentication
- **CORS**: Configured for Flutter app integration
- **Input Validation**: Request validation using class-validator
- **Protected Routes**: JWT guard for authenticated endpoints

## Development

### Building
```bash
npm run build
```

### Linting
```bash
npm run lint
```

### Watch Mode
```bash
npm run start:dev
```

## Connecting Flutter App

To connect the Flutter app to this backend:

1. Update the API base URL in your Flutter app's configuration
2. Use the JWT token from login/register responses in subsequent requests
3. Add the token to the Authorization header: `Bearer {token}`

Example Flutter configuration:
```dart
class ApiService {
  static const baseUrl = 'http://localhost:3000';
  // or for mobile emulator:
  // Android: 'http://10.0.2.2:3000'
  // iOS: 'http://localhost:3000'
}
```

## Troubleshooting

### Database Connection Issues
- Ensure MongoDB is running
- Verify MONGODB_URI in `.env`
- Check if MongoDB is accessible on the specified port

### Port Already in Use
- Change the PORT in `.env` file
- Kill the process using port 3000: `lsof -ti:3000 | xargs kill`

### JWT Token Issues
- Ensure JWT_SECRET is set in `.env`
- Check token expiration time
- Verify Authorization header format: `Bearer {token}`

## License

MIT
