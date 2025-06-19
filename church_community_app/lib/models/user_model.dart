import 'package:flutter/material.dart';

class UserPreferences {
  final bool notificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool quietHoursEnabled;
  final TimeOfDay quietHoursStart;
  final TimeOfDay quietHoursEnd;
  final String language;
  final ThemeMode themeMode;

  const UserPreferences({
    this.notificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.quietHoursEnabled = false,
    this.quietHoursStart = const TimeOfDay(hour: 22, minute: 0),
    this.quietHoursEnd = const TimeOfDay(hour: 7, minute: 0),
    this.language = 'fr',
    this.themeMode = ThemeMode.system,
  });

  UserPreferences copyWith({
    bool? notificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? quietHoursEnabled,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
    String? language,
    ThemeMode? themeMode,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'emailNotificationsEnabled': emailNotificationsEnabled,
      'quietHoursEnabled': quietHoursEnabled,
      'quietHoursStart': {
        'hour': quietHoursStart.hour,
        'minute': quietHoursStart.minute,
      },
      'quietHoursEnd': {
        'hour': quietHoursEnd.hour,
        'minute': quietHoursEnd.minute,
      },
      'language': language,
      'themeMode': themeMode.toString(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      emailNotificationsEnabled: json['emailNotificationsEnabled'] ?? true,
      quietHoursEnabled: json['quietHoursEnabled'] ?? false,
      quietHoursStart: json['quietHoursStart'] != null
          ? TimeOfDay(
              hour: json['quietHoursStart']['hour'],
              minute: json['quietHoursStart']['minute'],
            )
          : const TimeOfDay(hour: 22, minute: 0),
      quietHoursEnd: json['quietHoursEnd'] != null
          ? TimeOfDay(
              hour: json['quietHoursEnd']['hour'],
              minute: json['quietHoursEnd']['minute'],
            )
          : const TimeOfDay(hour: 7, minute: 0),
      language: json['language'] ?? 'fr',
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.toString() == json['themeMode'],
        orElse: () => ThemeMode.system,
      ),
    );
  }
}

class ChurchUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final UserPreferences preferences;
  final List<String> roles;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const ChurchUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    this.preferences = const UserPreferences(),
    this.roles = const ['user'],
    required this.createdAt,
    this.lastLoginAt,
  });

  String get fullName => '$firstName $lastName';

  bool get isAdmin => roles.contains('admin');
  bool get isPastor => roles.contains('pastor');
  bool get isModerator => roles.contains('moderator');

  ChurchUser copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    UserPreferences? preferences,
    List<String>? roles,
    DateTime? lastLoginAt,
  }) {
    return ChurchUser(
      id: id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      preferences: preferences ?? this.preferences,
      roles: roles ?? List.from(this.roles),
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'preferences': preferences.toJson(),
      'roles': roles,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  factory ChurchUser.fromJson(Map<String, dynamic> json) {
    return ChurchUser(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
      roles: List<String>.from(json['roles'] ?? ['user']),
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt:
          json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
    );
  }

  // Sample user for development
  static ChurchUser sampleUser() {
    return ChurchUser(
      id: '1',
      email: 'user@example.com',
      firstName: 'Jean',
      lastName: 'Dupont',
      phoneNumber: '+33 1 23 45 67 89',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLoginAt: DateTime.now(),
      roles: ['user', 'admin'],
    );
  }
}
