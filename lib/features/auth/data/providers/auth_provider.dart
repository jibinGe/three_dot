// auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_dot/features/auth/data/models/user_model.dart';
import 'package:three_dot/shared/services/storage_service.dart';
import '../models/auth_state.dart';
import '../repositories/auth_repository.dart';

final storageServiceProvider =
    Provider<StorageService>((ref) => StorageService());

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(
      ref.watch(storageServiceProvider),
    ));

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(storageServiceProvider),
  );
});

// Provider for current user data that can be accessed globally
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).user;
});

// Provider to check if initialization is complete
final authInitializedProvider = StateProvider<bool>((ref) => false);

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  AuthNotifier(this._authRepository, this._storageService)
      : super(AuthState()) {
    _loadSavedCredentials();
  }

  // Load saved credentials on initialization
  Future<void> _loadSavedCredentials() async {
    final rememberMe = await _storageService.getRememberMe();
    if (rememberMe) {
      state = state.copyWith(savedCredentials: await _getSavedCredentials());
    }
  }

  Future<Map<String, String>?> _getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('saved_username');
    final password = prefs.getString('saved_password');

    if (username != null && password != null) {
      return {
        'username': username,
        'password': password,
      };
    }
    return null;
  }

  Future<void> login(String username, String password,
      {required bool rememberMe}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final user = await _authRepository.login(username, password);
      await _storageService.saveUserData(user.toJsonString());

      // Handle remember me
      await _storageService.saveRememberMe(rememberMe);
      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('saved_username', username);
        await prefs.setString('saved_password', password);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('saved_username');
        await prefs.remove('saved_password');
      }

      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
        error: null,
      );
    } catch (e) {
      await _storageService.clearAll();
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
        user: null,
      );
    }
  }

  Future<void> validateAuthAndGetUser() async {
    try {
      // Attempt to validate the token and get user data
      final userData = await _authRepository.validateToken();

      if (userData != null) {
        // Token is valid and we have user data
        await _storageService.saveUserData(userData.toJsonString());
        state = state.copyWith(
          isAuthenticated: true,
          isInitialized: true,
          user: userData,
        );
      } else {
        // Token is invalid or missing
        await _storageService.clearAll();
        state = state.copyWith(
          isAuthenticated: false,
          isInitialized: true,
          user: null,
        );
      }
    } catch (e) {
      print('Error validating auth state: $e');
      await _storageService.clearAll();
      state = state.copyWith(
        isAuthenticated: false,
        user: null,
      );
    }
  }

  // Future<void> login(String username, String password) async {
  //   try {
  //     state = state.copyWith(isLoading: true, error: null);

  //     final user = await _authRepository.login(username, password);
  //     await _storageService.saveUserData(user.toJsonString());

  //     state = state.copyWith(
  //       isLoading: false,
  //       user: user,
  //       isAuthenticated: true,
  //       error: null,
  //     );
  //   } catch (e) {
  //     await _storageService.clearAll();
  //     state = state.copyWith(
  //       isLoading: false,
  //       error: e.toString(),
  //       isAuthenticated: false,
  //       user: null,
  //     );
  //   }
  // }

  Future<void> checkAuthStatus() async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (!isLoggedIn) {
        await _storageService.clearAll();
        state = state.copyWith(
          isAuthenticated: false,
          user: null,
        );
      }
    } catch (e) {
      print('Error checking auth status: $e');
      await _storageService.clearAll();
      state = state.copyWith(
        isAuthenticated: false,
        user: null,
      );
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);
      await _authRepository.logout();
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      // Always clear storage and reset state
      await _storageService.clearAll();
      state = AuthState();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _authRepository.forgotPassword(email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Add method to refresh user data
  Future<void> refreshUserData() async {
    try {
      final userData = await _authRepository.validateToken();
      if (userData != null) {
        await _storageService.saveUserData(userData.toJsonString());
        state = state.copyWith(user: userData);
      } else {
        // If validation fails, logout the user
        await logout();
      }
    } catch (e) {
      print('Error refreshing user data: $e');
      await logout();
    }
  }
}
