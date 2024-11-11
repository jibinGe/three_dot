import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:three_dot/core/constants/api_constants.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/models/location_model.dart';
import 'package:three_dot/features/inquiry/data/models/selected_product_model.dart';
import 'package:three_dot/shared/services/storage_service.dart';

class InquiryRepository {
  final Dio _dio;
  final StorageService _storageService;

  InquiryRepository()
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
  Future<List<InquiryModel>> getAllInquiries() async {
    try {
      final String? accessToken = await _storageService.getToken();

      final response = await _dio.get(
        '/inquiry/?page=1&size=10',
        // data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );

      return (response.data["items"] as List)
          .map((json) => InquiryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch Inquiries: $e');
    }
  }

  Future<InquiryModel> createInquiryStage1({
    required String name,
    required String consumerNumber,
    required String address,
    required String mobileNumber,
    required String email,
    required LocationModel location,
    int? referredById,
  }) async {
    debugPrint("repo called >>>>>>>>>>>>>>>>>>>>>>>");
    final String? accessToken = await _storageService.getToken();

    try {
      final response = await _dio.post(
        '/inquiry/stage1',
        data: {
          'name': name,
          'consumer_number': consumerNumber,
          'address': address,
          'mobile_number': mobileNumber,
          'email': email,
          'location': location.toJson(),
          if (referredById != null) 'referred_by_id': referredById,
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

      return InquiryModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create inquiry: $e');
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

  Future<InquiryModel> getInquiry(int id) async {
    final String? accessToken = await _storageService.getToken();

    try {
      final response = await _dio.get(
        '/inquiry/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${accessToken ?? ""}',
          },
        ),
      );
      log(response.data.toString());
      return InquiryModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get inquiry: $e');
    }
  }
}
