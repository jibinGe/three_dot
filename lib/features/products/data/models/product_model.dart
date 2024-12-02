import 'package:three_dot/features/products/data/models/product_category_model.dart';

class Product {
  final ProductCategory category;
  final String name;
  final String manufacturer;
  final String model;
  final Map<String, String> specifications;
  final double unitPrice;
  final String unitType;
  final int? stock;
  final double averageCost;
  final String? description;
  final int id;
  final int categoryId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Product({
    required this.category,
    required this.name,
    required this.manufacturer,
    required this.model,
    required this.specifications,
    required this.unitPrice,
    required this.unitType,
    this.stock,
    required this.averageCost,
    this.description,
    required this.id,
    required this.categoryId,
    required this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      category: ProductCategory.fromJson(json['category']),
      name: json['name'],
      manufacturer: json['manufacturer'],
      model: json['model'],
      specifications: Map<String, String>.from(json['specifications']),
      unitPrice: json['unit_price'].toDouble(),
      unitType: json['unit_type'],
      stock: json['stock'],
      averageCost: json['average_cost'].toDouble(),
      description: json['description'],
      id: json['id'],
      categoryId: json['category_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category.toJson(),
      'name': name,
      'manufacturer': manufacturer,
      'model': model,
      'specifications': specifications,
      'unit_price': unitPrice,
      'unit_type': unitType,
      'stock': stock,
      'average_cost': averageCost,
      'description': description,
      'id': id,
      'category_id': categoryId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
