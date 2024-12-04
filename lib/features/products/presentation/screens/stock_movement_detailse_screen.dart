import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/products/data/models/stock_movement_model.dart';

import 'package:flutter/material.dart';
import 'package:three_dot/features/products/data/providers/stock_movement_provider.dart';

class StockMovementDetailScreen extends ConsumerStatefulWidget {
  final StockMovementModel movement;

  const StockMovementDetailScreen({Key? key, required this.movement})
      : super(key: key);
  @override
  ConsumerState<StockMovementDetailScreen> createState() =>
      _StockMovementDetailScreenState();
}

class _StockMovementDetailScreenState
    extends ConsumerState<StockMovementDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(stockMovementNotifierProvider.notifier)
          .getAStockMovement(widget.movement.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final stockMovementState = ref.watch(stockMovementNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Movement Details'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          if (stockMovementState.isLoading) {
            return _buildLoadingIndicator();
          }

          if (stockMovementState.stockMovement == null) {
            return Center(
              child: Text('No detailss found'),
            );
          }
          final movement = stockMovementState.stockMovement!;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionHeader('Movement Details'),
                    const SizedBox(height: 8),
                    _buildDetailCard([
                      _buildDetailRow(Icons.swap_horiz, 'Movement Type',
                          movement.movementType),
                      _buildDetailRow(Icons.numbers, 'Quantity',
                          movement.quantity.toString()),
                      _buildDetailRow(Icons.price_change, 'Unit Price',
                          '\$${movement.unitPrice.toStringAsFixed(2)}'),
                      _buildDetailRow(Icons.confirmation_number,
                          'Reference Number', movement.referenceNumber),
                      _buildDetailRow(
                          Icons.comment, 'Remarks', movement.remarks ?? 'N/A'),
                      _buildDetailRow(Icons.inventory, 'Stock After',
                          movement.stockAfter.toString()),
                      _buildDetailRow(Icons.price_check, 'Average Cost After',
                          '\$${movement.averageCostAfter.toStringAsFixed(2)}'),
                      _buildDetailRow(Icons.date_range, 'Created At',
                          DateFormat('dd MMM yyyy').format(movement.createdAt)),
                      if (movement.updatedAt != null)
                        _buildDetailRow(
                            Icons.update,
                            'Updated At',
                            DateFormat('dd MMM yyyy')
                                .format(movement.updatedAt!)),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionHeader('Product Details'),
                    const SizedBox(height: 8),
                    _buildDetailCard([
                      _buildDetailRow(Icons.shopping_bag, 'Product Name',
                          movement.product.name),
                      _buildDetailRow(Icons.business, 'Manufacturer',
                          movement.product.manufacturer),
                      _buildDetailRow(Icons.model_training, 'Model',
                          movement.product.model),
                      _buildDetailRow(Icons.price_change, 'Unit Price',
                          '\$${movement.product.unitPrice.toStringAsFixed(2)}'),
                      _buildDetailRow(Icons.inventory, 'Stock',
                          movement.product.stock?.toString() ?? 'N/A'),
                    ]),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(
        color: AppColors.textPrimary,
        size: 24,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> details) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: details,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
