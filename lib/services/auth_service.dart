import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Retrieves the map of stored users (email -> {username, password}).
  Future<Map<String, Map<String, String>>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_usersKey);
    if (jsonString == null) return {};
    final Map<String, dynamic> decoded = json.decode(jsonString);
    // Ensure proper typing
    return decoded.map(
      (email, data) => MapEntry(email, Map<String, String>.from(data)),
    );
  }

  /// Persists the users map.
  Future<void> _saveUsers(Map<String, Map<String, String>> users) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(users);
    await prefs.setString(_usersKey, jsonString);
  }

  /// Sign up a new user. Returns true if successful, false if email already exists.
  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final users = await _getUsers();
    if (users.containsKey(email)) {
      return false; // email already registered
    }
    users[email] = {'username': username, 'password': password};
    await _saveUsers(users);
    // Auto‑login after sign‑up
    await login(email: email, password: password);
    return true;
  }

  /// Login with email (or username) and password. Returns true on success.
  Future<bool> login({required String email, required String password}) async {
    final users = await _getUsers();
    final user = users[email];
    if (user == null) return false;
    if (user['password'] != password) return false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, email);
    return true;
  }

  /// Logout the current user.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  /// Returns the currently logged‑in user's data or null.
  Future<Map<String, String>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_currentUserKey);
    if (email == null) return null;
    final users = await _getUsers();
    return users[email];
  }
}
