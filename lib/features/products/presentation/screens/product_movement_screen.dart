import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/products/data/models/product_model.dart';
import 'package:three_dot/features/products/data/models/stock_movement_model.dart';
import 'package:three_dot/features/products/data/providers/product_provider.dart';
import 'package:three_dot/features/products/presentation/screens/stock_movement_detailse_screen.dart';

class StockMovementScreen extends ConsumerWidget {
  const StockMovementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockMovementsAsyncValue = ref.watch(productMovementProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Movements'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: stockMovementsAsyncValue.when(
          data: (movements) => _buildContent(context, movements),
          loading: () => _buildLoadingIndicator(),
          error: (error, stackTrace) => _buildErrorWidget(error),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, List<StockMovementModel> movements) {
    if (movements.isEmpty) {
      return const Center(child: Text('No stock movements available.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetailsCard(product: movements.first.product),
        const SizedBox(height: 16),
        Expanded(
          child: StockMovementsList(movements: movements),
        ),
      ],
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

  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Text('Error: ${error.toString()}'),
    );
  }
}

class ProductDetailsCard extends StatelessWidget {
  final Product product;

  const ProductDetailsCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductHeader(context),
            const CustomDivider(),
            _buildProductDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
      child: Text(
        product.name,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      children: [
        ProductDetailRow(
          icon: Icons.factory,
          label: 'Manufacturer',
          value: product.manufacturer,
          iconColor: Colors.blue,
        ),
        ProductDetailRow(
          icon: Icons.widgets,
          label: 'Model',
          value: product.model,
          iconColor: Colors.orange,
        ),
        ProductDetailRow(
          icon: Icons.attach_money,
          label: 'Unit Price',
          value: '\$${product.unitPrice.toStringAsFixed(2)}',
          iconColor: Colors.green,
        ),
        ProductDetailRow(
          icon: Icons.inventory,
          label: 'Stock',
          value: product.stock?.toString() ?? 'N/A',
          valueColor: _getStockColor(product.stock),
          iconColor: Colors.purple,
        ),
      ],
    );
  }

  Color _getStockColor(int? stock) {
    return stock != null && stock > 0 ? Colors.green : Colors.red;
  }
}

class StockMovementsList extends StatelessWidget {
  final List<StockMovementModel> movements;

  const StockMovementsList({
    super.key,
    required this.movements,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movements.length,
      itemBuilder: (context, index) => StockMovementCard(
        movement: movements[index],
        showActions: index == 0,
      ),
    );
  }
}

class StockMovementCard extends StatelessWidget {
  final StockMovementModel movement;
  final bool showActions;

  const StockMovementCard({
    super.key,
    required this.movement,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StockMovementDetailScreen(movement: movement),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const CustomDivider(),
              _buildMovementDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              DateFormat('dd MMM yyyy').format(movement.createdAt),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        if (showActions) _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _handleEdit(),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _handleDelete(),
        ),
      ],
    );
  }

  Widget _buildMovementDetails() {
    return Column(
      children: [
        ProductDetailRow(
          icon: Icons.category,
          label: 'Type',
          value: movement.movementType,
        ),
        ProductDetailRow(
          icon: Icons.bookmark,
          label: 'Reference',
          value: movement.referenceNumber,
        ),
        ProductDetailRow(
          icon: Icons.confirmation_number,
          label: 'Quantity',
          value: movement.quantity.toString(),
        ),
        ProductDetailRow(
          icon: Icons.monetization_on,
          label: 'Unit Price',
          value: '\$${movement.unitPrice.toStringAsFixed(2)}',
        ),
        ProductDetailRow(
          icon: Icons.inventory,
          label: 'Stock After',
          value: movement.stockAfter.toString(),
        ),
        if (movement.remarks != null)
          ProductDetailRow(
            icon: Icons.notes,
            label: 'Remarks',
            value: movement.remarks!,
          ),
      ],
    );
  }

  void _handleEdit() {
    debugPrint('Edit movement: ${movement.id}');
  }

  void _handleDelete() {
    debugPrint('Delete movement: ${movement.id}');
  }
}

class ProductDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final Color? iconColor;

  const ProductDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor ?? Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontWeight: valueColor != null ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 1.5,
      height: 24,
    );
  }
}
