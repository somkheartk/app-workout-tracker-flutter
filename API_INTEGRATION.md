# Flutter App - Backend API Integration Guide

This guide explains how to integrate the Flutter app with the NestJS backend API.

## Overview

The backend API provides RESTful endpoints for:
- User authentication (register, login)
- Workout plans management
- Workout sessions tracking
- Groups and social features
- User statistics

## Quick Start

### 1. Start the Backend

```bash
cd backend
npm install
npm run start:dev
```

The API will be available at `http://localhost:3000`

### 2. Configure Flutter App

#### For Android Emulator
Use `http://10.0.2.2:3000` to access localhost from Android emulator

#### For iOS Simulator
Use `http://localhost:3000` or `http://127.0.0.1:3000`

#### For Physical Device
Use your computer's IP address, e.g., `http://192.168.1.100:3000`

## Integration Steps

### Step 1: Add HTTP Package

Add the http package to `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0
```

### Step 2: Create API Service

Create `lib/services/api_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this based on your environment
  static const String baseUrl = 'http://localhost:3000';
  
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  String? getToken() {
    return _token;
  }

  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // Authentication
  Future<Map<String, dynamic>> register(
    String email,
    String name,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'name': name,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      _token = data['access_token'];
      return data;
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      _token = data['access_token'];
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  // Workout Plans
  Future<List<dynamic>> getWorkoutPlans() async {
    final response = await http.get(
      Uri.parse('$baseUrl/workout-plans'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load workout plans');
    }
  }

  Future<Map<String, dynamic>> getWorkoutPlan(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/workout-plans/$id'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load workout plan');
    }
  }

  // Workout Sessions
  Future<Map<String, dynamic>> createSession(
    String planName,
    List<dynamic> completedExercises,
    DateTime startTime,
    DateTime endTime,
    int duration,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/workout-sessions'),
      headers: _headers(),
      body: json.encode({
        'planName': planName,
        'completedExercises': completedExercises,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'duration': duration,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create session');
    }
  }

  Future<List<dynamic>> getSessions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/workout-sessions'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/workout-sessions/stats'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load stats');
    }
  }

  // Groups
  Future<Map<String, dynamic>> createGroup(
    String name,
    String description,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/groups'),
      headers: _headers(),
      body: json.encode({
        'name': name,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create group');
    }
  }

  Future<List<dynamic>> getGroups() async {
    final response = await http.get(
      Uri.parse('$baseUrl/groups'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load groups');
    }
  }

  Future<Map<String, dynamic>> joinGroup(String groupId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/groups/join'),
      headers: _headers(),
      body: json.encode({
        'groupId': groupId,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to join group');
    }
  }
}
```

### Step 3: Update Auth Service

Modify `lib/services/auth_service.dart` to use the API:

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/user.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<User?> register(String name, String email, String password) async {
    try {
      final response = await _apiService.register(email, name, password);
      
      final user = User(
        id: response['user']['id'],
        email: response['user']['email'],
        name: response['user']['name'],
      );

      // Save token and user info
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['access_token']);
      await prefs.setString('userId', user.id);
      
      return user;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      
      final user = User(
        id: response['user']['id'],
        email: response['user']['email'],
        name: response['user']['name'],
      );

      // Save token and user info
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['access_token']);
      await prefs.setString('userId', user.id);
      
      return user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');
    
    if (token != null && userId != null) {
      _apiService.setToken(token);
      // You might want to validate the token with the backend
      return User(
        id: userId,
        email: '', // Fetch from backend if needed
        name: '', // Fetch from backend if needed
      );
    }
    
    return null;
  }
}
```

### Step 4: Initialize API Service

In your `main.dart` or service initialization:

```dart
final apiService = ApiService();

// After login/register
final token = await SharedPreferences.getInstance().getString('token');
if (token != null) {
  apiService.setToken(token);
}
```

## API Endpoints Reference

### Authentication

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/auth/register` | POST | Register new user |
| `/auth/login` | POST | Login user |

### Users

| Endpoint | Method | Description | Auth |
|----------|--------|-------------|------|
| `/users/profile` | GET | Get current user profile | Yes |
| `/users` | GET | Get all users | Yes |

### Workout Plans

| Endpoint | Method | Description | Auth |
|----------|--------|-------------|------|
| `/workout-plans` | GET | Get all plans | Yes |
| `/workout-plans/:id` | GET | Get single plan | Yes |
| `/workout-plans` | POST | Create plan | Yes |
| `/workout-plans/:id` | PUT | Update plan | Yes |
| `/workout-plans/:id` | DELETE | Delete plan | Yes |

### Workout Sessions

| Endpoint | Method | Description | Auth |
|----------|--------|-------------|------|
| `/workout-sessions` | GET | Get all sessions | Yes |
| `/workout-sessions/stats` | GET | Get statistics | Yes |
| `/workout-sessions` | POST | Create session | Yes |
| `/workout-sessions/:id` | DELETE | Delete session | Yes |

### Groups

| Endpoint | Method | Description | Auth |
|----------|--------|-------------|------|
| `/groups` | GET | Get all groups | Yes |
| `/groups/:id` | GET | Get single group | Yes |
| `/groups` | POST | Create group | Yes |
| `/groups/join` | POST | Join group | Yes |
| `/groups/:id/activity` | POST | Add activity | Yes |
| `/groups/:id/leave` | DELETE | Leave group | Yes |
| `/groups/:id` | DELETE | Delete group | Yes |

## Error Handling

Always wrap API calls in try-catch blocks:

```dart
try {
  final plans = await apiService.getWorkoutPlans();
  // Handle success
} catch (e) {
  // Handle error
  print('Error: $e');
  // Show error message to user
}
```

## Best Practices

1. **Token Management**
   - Store token securely using shared_preferences or flutter_secure_storage
   - Refresh token on app startup
   - Handle token expiration

2. **Error Handling**
   - Show user-friendly error messages
   - Handle network errors gracefully
   - Implement retry logic for failed requests

3. **Loading States**
   - Show loading indicators during API calls
   - Disable buttons during requests to prevent double submissions

4. **Caching**
   - Cache workout plans and sessions locally
   - Sync with backend periodically
   - Implement offline mode

5. **Security**
   - Always use HTTPS in production
   - Don't store sensitive data in plain text
   - Validate all user inputs

## Testing

Test the integration:

1. Start the backend server
2. Run the Flutter app
3. Test each feature:
   - Register a new user
   - Login
   - Fetch workout plans
   - Create a session
   - Join a group

## Troubleshooting

### Connection Refused
- Ensure backend is running
- Check the correct IP/port
- Verify firewall settings

### 401 Unauthorized
- Token might be expired
- Check if token is being sent correctly
- Re-login to get a new token

### CORS Issues
- Backend already has CORS enabled
- If issues persist, check backend CORS configuration

### Network Error on Android
- Add Internet permission in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## Next Steps

1. Implement the API service in your Flutter app
2. Update existing services to use the backend
3. Test all features end-to-end
4. Deploy backend to production server
5. Update Flutter app with production API URL

## Production Considerations

1. **Environment Variables**
   - Use different API URLs for development/production
   - Store configuration in environment files

2. **SSL/TLS**
   - Use HTTPS in production
   - Implement certificate pinning for security

3. **Performance**
   - Implement pagination for large lists
   - Use debouncing for search/filter
   - Optimize image loading

4. **Monitoring**
   - Add error tracking (Sentry, Crashlytics)
   - Monitor API performance
   - Track user analytics

## Support

For issues or questions:
- Check backend logs: `backend/` directory
- Review API documentation: `backend/README.md`
- Test endpoints with Postman or curl
