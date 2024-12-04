import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:three_dot/features/products/data/models/product_category_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  final ProductCategory category;
  final void Function() onTap;
  final void Function() onDelete;
  final void Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              category.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text('${category.description} - ${category.code}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: onTap,
          ),
          const Divider(height: 1, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
