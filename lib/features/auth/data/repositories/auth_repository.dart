import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../shared/services/storage_service.dart';

class AuthRepository {
  final Dio _dio;
  final StorageService _storageService;

  AuthRepository()
      : _dio = Dio(BaseOptions(
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 3),
          validateStatus: (status) => status! < 500,
          baseUrl: ApiConstants.baseUrl, // Add base URL here
        )),
        _storageService = StorageService() {
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  Future<UserModel> login(String username, String password) async {
    try {
      debugPrint('Attempting to login at: /auth/login');

      // Create form data
      final formData = FormData.fromMap({
        'username': username,
        'password': password,
      });

      // First request: Login to get token
      final response = await _dio.post(
        '/auth/login',
        data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      debugPrint('Login response status: ${response.statusCode}');
      debugPrint('Login response data: ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        await _storageService.saveToken(token);

        // Second request: Get user details using the token
        final userResponse = await _dio.get(
          '/auth/me',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
        );

        debugPrint('User details response status: ${userResponse.statusCode}');
        debugPrint('User details response data: ${userResponse.data}');

        if (userResponse.statusCode == 200) {
          return UserModel.fromJson(userResponse.data);
        } else {
          throw Exception(
              'Failed to get user details: ${userResponse.statusCode}');
        }
      } else if (response.statusCode == 422) {
        final errorMessage = _parseErrorMessage(response.data);
        throw Exception(errorMessage);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid username or password');
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('DioException occurred: ${e.toString()}');
      debugPrint('DioException type: ${e.type}');
      debugPrint('DioException message: ${e.message}');
      debugPrint('DioException response: ${e.response}');

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception(
              'Connection timeout. Please check your internet connection.');
        case DioExceptionType.connectionError:
          throw Exception(
              'Connection error. Please check if the server is running.');
        case DioExceptionType.badResponse:
          final errorMessage = _parseErrorMessage(e.response?.data);
          throw Exception(errorMessage);
        default:
          throw Exception(
              'Connection error. Please check your internet connection and try again.');
      }
    } catch (e) {
      debugPrint('Unexpected error: ${e.toString()}');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      debugPrint('Attempting to send password reset for: $email');

      final formData = FormData.fromMap({
        'email': email,
      });

      final response = await _dio.post(
        '/auth/forgot-password',
        data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      debugPrint('Forgot password response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        final errorMessage = _parseErrorMessage(response.data);
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in forgot password: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // Get the token before clearing it
      final token = await _storageService.getToken();

      if (token != null) {
        // Optional: Call logout endpoint if your backend has one
        try {
          await _dio.post(
            '/auth/logout',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            ),
          );
        } catch (e) {
          debugPrint('Error calling logout endpoint: ${e.toString()}');
        }
      }

      // Clear stored token and any other local storage
      await _storageService.deleteToken();
      await _storageService.clearAll(); // Add this method to StorageService
    } catch (e) {
      debugPrint('Error in logout: ${e.toString()}');
      // Still clear local storage even if the API call fails
      await _storageService.deleteToken();
      await _storageService.clearAll();
      rethrow;
    }
  }

  Future<bool> refreshToken() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final newToken = response.data['access_token'];
        await _storageService.saveToken(newToken);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error refreshing token: ${e.toString()}');
      return false;
    }
  }

  String _parseErrorMessage(dynamic responseData) {
    try {
      if (responseData is Map && responseData.containsKey('detail')) {
        if (responseData['detail'] is List) {
          final details = responseData['detail'] as List;
          if (details.isNotEmpty) {
            return details.map((e) => e['msg']).join(', ');
          }
        } else {
          return responseData['detail'].toString();
        }
      }
      return 'Invalid request format';
    } catch (e) {
      return 'An error occurred while processing the response';
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storageService.getToken();
    return token != null;
  }
}
