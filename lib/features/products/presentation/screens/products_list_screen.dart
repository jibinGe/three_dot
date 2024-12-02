import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/products/data/providers/product_provider.dart';
import 'package:three_dot/features/products/presentation/screens/product_form_screen.dart';
import 'package:three_dot/features/products/presentation/widgets/product_list.dart';

class ProductsListScreen extends ConsumerWidget {
  const ProductsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
          // title: Text(selectedCategory.replaceAll('_', ' ').toUpperCase()),
          ),
      body: productsAsync.when(
        // data: (products) => ProductGrid(products: products),
        data: (categories) => categories.isEmpty
            ? const Center(child: Text('No products found'))
            : ProductList(products: categories),
        loading: () => Center(
            child: LoadingAnimationWidget.threeArchedCircle(
          color: AppColors.textPrimary,
          size: 24,
        )),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      // bottomNavigationBar: ProductCategoriesNavigationBar(
      //   selectedCategory: selectedCategory,
      //   onCategorySelected: (category) {
      //     ref.read(selectedCategoryProvider.notifier).state = category;
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditProductForm(context, ref),
        child: Icon(Icons.add),
        isExtended: true,
      ),
    );
  }

  void _showEditProductForm(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ProductFormScreen(),
      ),
    );
  }
}
