import 'package:three_dot/features/products/data/models/product_category_model.dart';

class CategoriesState {
  final bool isLoading;
  final bool isListLoading;
  final String? error;
  final List<ProductCategory> categories;

  const CategoriesState({
    this.isLoading = false,
    this.isListLoading = false,
    this.error,
    this.categories = const [],
  });

  CategoriesState copyWith({
    bool? isLoading,
    bool? isListLoading,
    String? error,
    List<ProductCategory>? categories,
  }) {
    return CategoriesState(
      isLoading: isLoading ?? this.isLoading,
      isListLoading: isListLoading ?? this.isListLoading,
      error: error ?? this.error,
      categories: categories ?? this.categories,
    );
  }
}
