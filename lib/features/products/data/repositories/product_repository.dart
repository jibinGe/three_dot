import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:three_dot/core/constants/api_constants.dart';
import 'package:three_dot/features/products/data/models/product_model.dart';
import 'package:three_dot/shared/services/storage_service.dart';

class ProductRepository {
  final Dio _dio;
  final StorageService _storageService;

  ProductRepository()
      : _dio = Dio(BaseOptions(
          connectTimeout: Duration(minutes: 8),
          receiveTimeout: Duration(minutes: 5),
          validateStatus: (status) => status! < 500,
          baseUrl: ApiConstants.baseUrl,
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

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final formData =
          FormData.fromMap({'category': category, 'skip': 0, 'limit': 100});
      final String? accessToken = await _storageService.getToken();

      final response = await _dio.get(
        '/products/',
        data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );

      return (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final String? accessToken = await _storageService.getToken();
      await _dio.delete(
        '/products/$productId',
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  Future<Product> updateProduct(Product product) async {
    final String? accessToken = await _storageService.getToken();
    try {
      final response = await _dio.put(
        '/products/${product.id}',
        data: product.toJson(),
        options: Options(
          contentType: 'application/json',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );

      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<Product> addProduct(Product product) async {
    final String? accessToken = await _storageService.getToken();
    try {
      final response = await _dio.post(
        '/products/',
        data: product.toJson(),
        options: Options(
          contentType: 'application/json',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );

      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }
}
