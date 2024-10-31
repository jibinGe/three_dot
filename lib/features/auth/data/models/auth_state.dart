import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_model.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final UserModel? user;

  AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    UserModel? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
    );
  }
}