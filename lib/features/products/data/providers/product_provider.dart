import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/products/data/models/product_category_model.dart';
import 'package:three_dot/features/products/data/models/product_model.dart';
import 'package:three_dot/features/products/data/models/stock_movement_model.dart';
import 'package:three_dot/features/products/data/repositories/product_repository.dart';

final selectedCategoryProvider = StateProvider<int>((ref) => 0);
final selectedProductProvider = StateProvider<int>((ref) => 0);

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductsByCategory(category);
});
final productMovementProvider =
    FutureProvider.autoDispose<List<StockMovementModel>>((ref) {
  final productId = ref.watch(selectedProductProvider);
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductMovements(productId);
});
final allProductsProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getallProducts();
});
