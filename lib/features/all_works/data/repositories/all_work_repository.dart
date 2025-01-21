import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:three_dot/core/constants/api_constants.dart';
import 'package:three_dot/features/project/data/model/projectModel.dart';
import 'package:three_dot/shared/services/storage_service.dart';

class AllWorkRepository {
  final Dio _dio;
  final StorageService _storageService;

  AllWorkRepository()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: Duration(minutes: 8),
          receiveTimeout: Duration(minutes: 5),
          validateStatus: (status) => status! < 500,
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
  Future<Response<dynamic>> getList({
    required int pageNo,
    required int pageSize,
    required int inquiryStage,
    String? quotationStatus,
    String? confirmationStatus,
  }) async {
    try {
      final String? accessToken = await _storageService.getToken();

      final response = await _dio.get(
        '/inquiry/filter',
        // data: formData,
        queryParameters: {
          'page': pageNo,
          'size': pageSize,
          'inquiry_stage': inquiryStage,
          if (quotationStatus != null) 'quotation_status': quotationStatus,
          if (confirmationStatus != null)
            'confirmation_status': confirmationStatus,
        },
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );
      log(response.data.toString());
      return response;
    } catch (e) {
      debugPrint('Failed to fetch Projects: $e');
      throw Exception('Failed to fetch Projects: $e');
    }
  }

  Future<Map<String, int>> getcounts() async {
    try {
      final String? accessToken = await _storageService.getToken();

      final response = await _dio.get(
        '/inquiry/counts',
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );

      log(response.data.toString());

      // Cast response.data to Map<String, int>
      return (response.data as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value as int));
    } catch (e) {
      debugPrint('Failed to fetch Projects: $e');
      throw Exception('Failed to fetch Projects: $e');
    }
  }
}
