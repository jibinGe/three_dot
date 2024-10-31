// auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  AuthNotifier(this._authRepository, this._storageService)
      : super(AuthState()) {
    // Initialize auth state when the notifier is created
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    try {
      final token = await _storageService.getToken();
      final userDataString = await _storageService.getUserData();

      if (token != null && userDataString != null) {
        try {
          final userData = UserModel.fromJsonString(userDataString);
          state = state.copyWith(
            isAuthenticated: true,
            user: userData,
          );
        } catch (e) {
          print('Error parsing stored user data: $e');
          await _storageService.clearAll();
        }
      }
    } catch (e) {
      print('Error initializing auth state: $e');
      await _storageService.clearAll();
    }
  }

  Future<void> login(String username, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Login and get user data
      final user = await _authRepository.login(username, password);

      // Save user data to storage
      await _storageService.saveUserData(user.toJsonString());

      // Update state with user data and authentication
      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
        error: null,
      );
    } catch (e) {
      // Handle login failure
      await _storageService.clearAll();
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
        user: null,
      );
    }
  }

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
}
