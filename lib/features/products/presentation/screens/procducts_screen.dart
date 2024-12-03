import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/products/data/models/product_category_model.dart';
import 'package:three_dot/features/products/data/providers/category_provider.dart';
import 'package:three_dot/features/products/data/providers/product_provider.dart';
import 'package:three_dot/features/products/presentation/screens/product_form_screen.dart';
import 'package:three_dot/features/products/presentation/screens/products_list_screen.dart';
import 'package:three_dot/features/products/presentation/widgets/categories_list.dart';
import 'package:three_dot/features/products/presentation/widgets/category_form.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(categoriesSateProvider.notifier).getAllCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoriesSateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Product Categories"),
        actions: [
          Transform.scale(
            scale: 0.9,
            child: ElevatedButton(
              onPressed: () => _openForm(context),
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          if (categoryState.isListLoading) {
            return Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.textPrimary,
                size: 24,
              ),
            );
          }

          if (categoryState.categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No categories found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _openForm(context),
                    child: const Text('Create New Category'),
                  ),
                ],
              ),
            );
          }

          final categories = categoryState.categories;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Dismissible(
                key: ValueKey(category.id),
                child: CategoryCard(
                  category: category,
                  onTap: () {
                    ref.read(selectedCategoryProvider.notifier).state =
                        category.id!;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductsListScreen(),
                      ),
                    );
                  },
                  onDelete: () {
                    print("taped");
                    _deleteCategory(context, ref, category);
                  },
                  onEdit: () => _editCategory(context, category),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openForm(BuildContext context, {ProductCategory? category}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CategoryForm(category: category),
      enableDrag: true,
      showDragHandle: true,
    );
  }

  void _editCategory(BuildContext context, ProductCategory category) {
    // Show edit form dialog or modal
    showModalBottomSheet(
      context: context,
      builder: (context) => CategoryForm(
        category: category, // Pass category to pre-fill form fields
      ),
      enableDrag: true,
      showDragHandle: true,
    );
  }

  void _deleteCategory(
      BuildContext context, WidgetRef ref, ProductCategory category) async {
    print("delete");
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(categoriesSateProvider.notifier).deleteCategory(
            category: category,
            ref: ref,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category deleted successfully')),
      );
    }
  }

  Widget _swipeBackground(Color color, IconData icon, String label) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white)),
            ],
          ),
          Row(
            children: [
              Text(label, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              Icon(icon, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}



  // _openForm(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) => CategoriesForm(),
  //     enableDrag: true,
  //     showDragHandle: true,
  //   );
  // }






// void _showEditProductForm(BuildContext context, WidgetRef ref) {
//   Navigator.of(context).push(
//     MaterialPageRoute(
//       builder: (_) => const ProductFormScreen(),
//     ),
//   );
// }
