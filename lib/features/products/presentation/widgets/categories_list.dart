import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/products/data/models/product_category_model.dart';
import 'package:three_dot/features/products/data/providers/product_provider.dart';
import 'package:three_dot/features/products/presentation/screens/procducts_screen.dart';
import 'package:three_dot/features/products/presentation/screens/products_list_screen.dart';

class CategoriesList extends StatelessWidget {
  final List<ProductCategory> categories;

  const CategoriesList({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoriesListItem(category: categories[index]);
      },
    );
  }
}

class CategoriesListItem extends ConsumerWidget {
  final ProductCategory category;

  const CategoriesListItem({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${category.description} - ${category.code}'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          ref.read(selectedCategoryProvider.notifier).state = category.id;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductsListScreen(),
              ));
        },
      ),
    );
  }
}
