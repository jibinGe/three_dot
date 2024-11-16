import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:three_dot/core/constants/api_constants.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/models/location_model.dart';
import 'package:three_dot/features/inquiry/data/models/selected_product_model.dart';
import 'package:three_dot/features/project/data/model/projectModel.dart';
import 'package:three_dot/shared/services/storage_service.dart';

class ProjectRepository {
  final Dio _dio;
  final StorageService _storageService;

  ProjectRepository()
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
  Future<List<ProjectModel>> getAllProjects() async {
    try {
      final String? accessToken = await _storageService.getToken();

      final response = await _dio.get(
        '/Projects/projects/?skip=0&limit=100',
        // data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );
      log(response.data.toString());
      return (response.data["data"] as List)
          .map((json) => ProjectModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Failed to fetch Projects: $e');
      throw Exception('Failed to fetch Projects: $e');
    }
  }

  Future<ProjectModel?> createProject({
    required int inquiryId,
    required int statusId,
    required int amountCollected,
    required int balenceAmount,
    required bool subsidyStatus,
    required String latestStatus,
  }) async {
    debugPrint("repo called >>>>>>>>>>>>>>>>>>>>>>>");
    final String? accessToken = await _storageService.getToken();

    try {
      final response = await _dio.post(
        '/Projects/projects',
        data: {
          "inquiry_id": inquiryId,
          "status_id": statusId,
          "latest_status": latestStatus,
          "amount_collected": amountCollected,
          "amount_pending": balenceAmount,
          "subsidy_status": subsidyStatus
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}',
          },
        ),
      );
      debugPrint("Respones :${response.statusCode}");
      debugPrint("Respones :${response.statusMessage}");
      debugPrint("Respones :${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProjectModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to create project: $e');
    }
  }

  Future<ProjectModel> getProject(int id) async {
    final String? accessToken = await _storageService.getToken();

    try {
      final response = await _dio.get(
        '/Projects/projects/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${accessToken ?? ""}',
          },
        ),
      );
      log(response.data.toString());
      return ProjectModel.fromJson(response.data["data"]);
    } catch (e) {
      debugPrint('Failed to get project: $e');
      throw Exception('Failed to get project: $e');
    }
  }

  Future<InquiryModel> updateInquiryStage2({
    required int inquiryId,
    required String roofType,
    required String quotationStatus,
    required String confirmationStatus,
    required String roofSpecification,
    required String confirmationRejectionReason,
    required String quotationRejectionReason,
    required double proposedAmount,
    required double proposedCapacity,
    required String paymentTerms,
    required List<SelectedProductModel> selectedProducts,
  }) async {
    final String? accessToken = await _storageService.getToken();

    try {
      final response = await _dio.put(
        '/inquiry/$inquiryId',
        data: {
          'roof_type': roofType,
          'roof_specification': roofSpecification,
          'proposed_amount': proposedAmount,
          'proposed_capacity': proposedCapacity,
          'payment_terms': paymentTerms,
          'selected_products': selectedProducts.map((p) => p.toJson()).toList(),
          'quotation_status': quotationStatus,
          'confirmation_status': confirmationStatus,
          if (quotationRejectionReason != "")
            'quotation_rejection_reason': quotationRejectionReason,
          if (confirmationRejectionReason != "")
            'confirmation_rejection_reason': confirmationRejectionReason,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}',
          },
        ),
      );

      return InquiryModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update inquiry: $e');
    }
  }
}
