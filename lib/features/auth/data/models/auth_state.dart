import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_model.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool isInitialized;
  final UserModel? user;
  final String? error;
  final Map<String, String>? savedCredentials;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.isInitialized = false,
    this.user,
    this.error,
    this.savedCredentials,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? isInitialized,
    UserModel? user,
    String? error,
    Map<String, String>? savedCredentials,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isInitialized: isInitialized ?? this.isInitialized,
      user: user ?? this.user,
      error: error ?? this.error,
      savedCredentials: savedCredentials ?? this.savedCredentials,
    );
  }
}
