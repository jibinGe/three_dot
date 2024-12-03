import 'package:three_dot/features/products/data/models/product_category_model.dart';

class CategoriesState {
  final bool isLoading;
  final bool isListLoading;
  // final InquiryModel? inquiry;
  final String? error;
  final List<ProductCategory> categories;

  const CategoriesState({
    this.isLoading = false,
    this.isListLoading = false,
    // this.inquiry,
    this.error,
    this.categories = const [],
  });

  CategoriesState copyWith({
    bool? isLoading,
    bool? isListLoading,
    // InquiryModel? inquiry,
    String? error,
    List<ProductCategory>? categories,
  }) {
    return CategoriesState(
      isLoading: isLoading ?? this.isLoading,
      isListLoading: isListLoading ?? this.isListLoading,
      // inquiry: inquiry ?? this.inquiry,
      error: error ?? this.error,
      categories: categories ?? this.categories,
    );
  }
}
