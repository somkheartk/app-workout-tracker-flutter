import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _usersKey = 'users';

  Future<User?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    
    if (usersJson != null) {
      final List<dynamic> usersList = jsonDecode(usersJson);
      for (var userJson in usersList) {
        if (userJson['email'] == email && userJson['password'] == password) {
          final user = User.fromJson(userJson);
          await _saveCurrentUser(user);
          return user;
        }
      }
    }
    return null;
  }

  Future<User?> register(String email, String password, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    
    List<dynamic> usersList = [];
    if (usersJson != null) {
      usersList = jsonDecode(usersJson);
      // Check if email already exists
      for (var userJson in usersList) {
        if (userJson['email'] == email) {
          return null; // Email already registered
        }
      }
    }
    
    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final user = User(id: userId, email: email, name: name);
    
    usersList.add({
      ...user.toJson(),
      'password': password,
    });
    
    await prefs.setString(_usersKey, jsonEncode(usersList));
    await _saveCurrentUser(user);
    return user;
  }

  Future<void> _saveCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
