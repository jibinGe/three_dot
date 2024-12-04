import 'package:three_dot/features/products/data/models/product_model.dart';

class StockMovementModel {
  final int productId;
  final String movementType;
  final int quantity;
  final double unitPrice;
  final String referenceNumber;
  final String? remarks;
  final int id;
  final int stockAfter;
  final double averageCostAfter;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Product product;

  StockMovementModel({
    required this.productId,
    required this.movementType,
    required this.quantity,
    required this.unitPrice,
    required this.referenceNumber,
    this.remarks,
    required this.id,
    required this.stockAfter,
    required this.averageCostAfter,
    required this.createdAt,
    this.updatedAt,
    required this.product,
  });

  factory StockMovementModel.fromJson(Map<String, dynamic> json) {
    return StockMovementModel(
      productId: json['product_id'],
      movementType: json['movement_type'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
      referenceNumber: json['reference_number'],
      remarks: json['remarks'],
      id: json['id'],
      stockAfter: json['stock_after'],
      averageCostAfter: json['average_cost_after'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'movement_type': movementType,
      'quantity': quantity,
      'unit_price': unitPrice,
      'reference_number': referenceNumber,
      'remarks': remarks,
      'id': id,
      'stock_after': stockAfter,
      'average_cost_after': averageCostAfter,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'product': product.toJson(),
    };
  }
}
