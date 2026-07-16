import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _authRepository;

  UserModel? _user;
  bool _isAuthenticated = false;
  String? _token;
  int? _userId;
  String? _userName;
  String? _userEmail;

  AuthViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepositoryImpl();

  bool get isAuthenticated => _isAuthenticated;
  UserModel? get user => _user;
  int? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  Future<void> login(String email, String password) async {
    try {
      _token = await _authRepository.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);

      // Fetch user details
      await _fetchUserDetails();

      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(
    String email,
    String password1,
    String password2,
    String firstName,
    String lastName,
    String uniqueId,
  ) async {
    try {
      await _authRepository.register(
        email,
        password1,
        password2,
        firstName,
        lastName,
        uniqueId,
      );
      await login(email, password1);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _fetchUserDetails() async {
    if (_token == null) return;
    try {
      _user = await _authRepository.fetchUserDetails(_token!);
      _userId = _user?.id;
      _userName = '${_user?.firstName} ${_user?.lastName}';
      _userEmail = _user?.email;
      await _saveUserInfoToPrefs();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveUserInfoToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _userName ?? '');
    await prefs.setString('userEmail', _userEmail ?? '');
    if (_userId != null) {
      await prefs.setInt('userId', _userId!);
    }
  }

  Future<void> _loadUserInfoFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName');
    _userEmail = prefs.getString('userEmail');
    _userId = prefs.getInt('userId');
  }

  Future<void> logout() async {
    _user = null;
    _isAuthenticated = false;
    _token = null;
    _userId = null;
    _userName = null;
    _userEmail = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userId');
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userId = prefs.getInt('userId');
    if (_token != null && _userId != null) {
      _isAuthenticated = true;
      await _loadUserInfoFromPrefs();
      notifyListeners();
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
}
