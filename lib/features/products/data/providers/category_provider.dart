import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/products/data/models/categories_state.dart';
import 'package:three_dot/features/products/data/models/product_category_model.dart';
import 'package:three_dot/features/products/data/providers/product_provider.dart';
import 'package:three_dot/features/products/data/repositories/product_repository.dart';

final categoriesSateProvider =
    StateNotifierProvider<CategoryNotifier, CategoriesState>((ref) {
  return CategoryNotifier(ref.watch(productRepositoryProvider));
});

class CategoryNotifier extends StateNotifier<CategoriesState> {
  final ProductRepository _repository;

  CategoryNotifier(this._repository) : super(const CategoriesState());

  Future getAllCategories() async {
    try {
      state = state.copyWith(
        isListLoading: true,
      );
      final categories = await _repository.getallProductCategories();
      state = state.copyWith(
        categories: categories,
        isListLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isListLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<bool> createCategory(
      {required String name,
      required String code,
      required String description,
      required WidgetRef ref}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final category = await _repository.addCategory(
          ProductCategory(name: name, code: code, description: description));
      getAllCategories();
      state = state.copyWith(
        isLoading: false,
      );
      if (category != null) {
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateCategory(
      {required int id,
      required String name,
      required String code,
      required String description,
      required WidgetRef ref}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final category = await _repository.updateCategory(ProductCategory(
          id: id, name: name, code: code, description: description));
      getAllCategories();
      state = state.copyWith(
        isLoading: false,
      );
      if (category != null) {
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteCategory(
      {required ProductCategory category, required WidgetRef ref}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteCategory(category);
      getAllCategories();
      state = state.copyWith(
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
}
