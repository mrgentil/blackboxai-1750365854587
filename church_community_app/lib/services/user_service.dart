import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserService extends ChangeNotifier {
  // Singleton pattern
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  ChurchUser? _currentUser;
  bool _isLoading = false;

  // Getters
  ChurchUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Initialize with sample data for development
  void initializeWithSampleData() {
    _currentUser = ChurchUser.sampleUser();
    notifyListeners();
  }

  // Authentication Methods
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));

      if (email == 'user@example.com' && password == 'password') {
        _currentUser = ChurchUser.sampleUser();
        notifyListeners();
        return true;
      }

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = ChurchUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      notifyListeners();
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = null;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));

      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));

      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Profile Management
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      if (_currentUser == null) return false;

      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = _currentUser!.copyWith(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
      );

      notifyListeners();
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePreferences(UserPreferences preferences) async {
    try {
      if (_currentUser == null) return false;

      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = _currentUser!.copyWith(preferences: preferences);
      notifyListeners();
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // User Search and Management (Admin only)
  Future<List<ChurchUser>> searchUsers(String query) async {
    if (_currentUser?.isAdmin != true) return [];

    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Return sample users for development
      return List.generate(
        5,
        (index) => ChurchUser(
          id: 'user$index',
          email: 'user$index@example.com',
          firstName: 'User',
          lastName: '$index',
          createdAt: DateTime.now().subtract(Duration(days: index * 10)),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUserRoles(String userId, List<String> roles) async {
    if (_currentUser?.isAdmin != true) return false;

    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));

      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteUser(String userId) async {
    if (_currentUser?.isAdmin != true) return false;

    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 1));

      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
