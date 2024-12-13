import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:three_dot/core/constants/api_constants.dart';
import 'package:three_dot/features/products/data/models/product_category_model.dart';
import 'package:three_dot/features/products/data/models/product_model.dart';
import 'package:three_dot/features/products/data/models/stock_movement_model.dart';
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

  Future<List<Product>> getProductsByCategory(int category) async {
    try {
      debugPrint("getting products>>>>>>>>>>>>>>>>");
      final formData =
          FormData.fromMap({'category': category, 'skip': 0, 'limit': 100});
      final String? accessToken = await _storageService.getToken();

      final response = await _dio.get(
        '/products/products/$category',
        // data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );
      log(response.statusCode.toString());
      log(response.data.toString());
      return (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Failed to fetch products: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<List<Product>> getallProducts() async {
    try {
      final String? accessToken = await _storageService.getToken();

      final response = await _dio.get(
        '/products/products',
        // data: formData,
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
        '/products/products/$productId',
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
        '/products/products/${product.id}',
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
        '/products/products/',
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

  Future<List<ProductCategory>> getallProductCategories() async {
    try {
      final String? accessToken = await _storageService.getToken();

      final response = await _dio.get(
        '/products/categories/',
        // data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );
      log(response.statusCode.toString());
      log(response.data.toString());
      return (response.data as List)
          .map((json) => ProductCategory.fromJson(json))
          .toList();
    } catch (e) {
      print('Failed to fetch categories: $e');
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<ProductCategory?> addCategory(ProductCategory category) async {
    final String? accessToken = await _storageService.getToken();
    try {
      final response = await _dio.post(
        '/products/categories/',
        data: category.toJson(),
        options: Options(
          contentType: 'application/json',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );
      if (response.statusCode == 200) {
        return ProductCategory.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<ProductCategory?> updateCategory(ProductCategory category) async {
    final String? accessToken = await _storageService.getToken();
    try {
      final response = await _dio.put(
        '/products/categories/${category.id}',
        data: category.toJson(),
        options: Options(
          contentType: 'application/json',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );
      if (response.statusCode == 200) {
        return ProductCategory.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> deleteCategory(ProductCategory category) async {
    final String? accessToken = await _storageService.getToken();
    try {
      final response = await _dio.delete(
        '/products/categories/${category.id}',
        options: Options(
          contentType: 'application/json',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );

      return;
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<List<StockMovementModel>> getProductMovements(int productId) async {
    try {
      final String? accessToken = await _storageService.getToken();

      final response = await _dio.get(
        '/products/stock-movements/',
        // data: formData,
        queryParameters: {
          'skip': 0,
          'limit': 100,
          'product_id': productId,
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
      return (response.data as List)
          .map((json) => StockMovementModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetchProduct Movements: $e');
    }
  }

  Future<StockMovementModel> getAProductMovements(int movementId) async {
    try {
      final String? accessToken = await _storageService.getToken();

      final response = await _dio.get(
        '/products/stock-movements/$movementId',
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
      return StockMovementModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetchProduct Movement: $e');
    }
  }

  Future<StockMovementModel?> createProductMovement({
    required int productId,
    required String movementType,
    required double quantity,
    required double unitPrice,
    required String reference,
    required String remarks,
  }) async {
    final String? accessToken = await _storageService.getToken();
    print("repo");
    try {
      final response = await _dio.post(
        '/products/stock-movements/',
        data: {
          "product_id": productId,
          "movement_type": movementType,
          "quantity": quantity,
          "unit_price": unitPrice,
          "reference_number": reference,
          "remarks": remarks
        },
        options: Options(
          contentType: 'application/json',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );
      if (response.statusCode == 200) {
        return StockMovementModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Failed to add product: $e');
      throw Exception('Failed to add product: $e');
    }
  }
  // createProductMovement(StockMovementModel newMovement) {}

  Future<StockMovementModel?> updateProductMovement({
    required int movementId,
    required double quantity,
    required double unitPrice,
    required String reference,
    required String remarks,
  }) async {
    final String? accessToken = await _storageService.getToken();

    try {
      final response = await _dio.put(
        '/products/stock-movements/$movementId',
        data: {
          "quantity": quantity,
          "unit_price": unitPrice,
          "reference_number": reference,
          "remarks": remarks
        },
        options: Options(
          contentType: 'application/json',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );
      if (response.statusCode == 200) {
        return StockMovementModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Failed to dit product: $e');
      throw Exception('Failed to edit product: $e');
    }
  }

  deleteProductMovement(int movementId) async {
    final String? accessToken = await _storageService.getToken();

    try {
      final response = await _dio.delete(
        '/products/stock-movements/$movementId',
        options: Options(
          contentType: 'application/json',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${accessToken ?? ""}'
          },
        ),
      );
      if (response.statusCode == 200) {
        return StockMovementModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Failed to delete movement: $e');
      throw Exception('Failed to delete movement: $e');
    }
  }
}
