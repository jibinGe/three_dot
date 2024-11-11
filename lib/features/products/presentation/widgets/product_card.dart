import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/products/data/models/product_model.dart';
import 'package:three_dot/features/products/data/providers/product_provider.dart';

// lib/features/products/presentation/widgets/product_card.dart

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with name and manufacturer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.manufacturer,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Product details section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  context,
                  'Model',
                  product.model,
                ),
                _buildDetailRow(
                  context,
                  'Price',
                  '${product.unitPrice.toStringAsFixed(2)} per ${product.unitType}',
                ),
                _buildDetailRow(
                  context,
                  'Stock',
                  '${product.stock} ${product.unitType}',
                ),

                // Specifications preview
                if (product.specifications.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Specifications',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  _buildSpecificationsPreview(context),
                ],
              ],
            ),
          ),

          const Spacer(),

          // Action buttons
          ButtonBar(
            children: [
              TextButton(
                onPressed: () => _showSpecificationsDialog(context),
                child: const Text('VIEW DETAILS'),
              ),
              TextButton(
                onPressed: () => _showEditDialog(context, ref),
                child: const Text('EDIT'),
              ),
              TextButton(
                onPressed: () => _showDeleteDialog(context, ref),
                child: const Text('DELETE'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsPreview(BuildContext context) {
    // Show first 2 specifications as a preview
    final previewSpecs = product.specifications.entries.take(2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: previewSpecs.map((spec) {
        return Text(
          '${spec.key}: ${spec.value}',
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      }).toList(),
    );
  }

  Future<void> _showSpecificationsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(product.description ?? ""),
              const SizedBox(height: 16),
              Text(
                'Specifications',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...product.specifications.entries.map((spec) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${spec.key}:',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(spec.value.toString()),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref
            .read(productRepositoryProvider)
            .deleteProduct(product.id.toString());
        ref.refresh(productsProvider);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete product: $e')),
          );
        }
      }
    }
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref) async {
    // Implement edit dialog here
    // You can create a separate form widget for editing product details
  }
}

// Update the ProductGrid widget to use a more suitable layout
class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a layout that's optimized for detailed product cards
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7, // Taller cards to accommodate more content
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
