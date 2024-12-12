import 'package:three_dot/features/products/data/models/product_category_model.dart';

class Product {
  final ProductCategory? category;
  final String name;
  final String manufacturer;
  final String model;
  final Map<String, dynamic> specifications;
  final double unitPrice;
  final String unitType;
  final int? stock;
  final double averageCost;
  final String? description;
  final int? id;
  final int categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.category,
    required this.name,
    required this.manufacturer,
    required this.model,
    required this.specifications,
    required this.unitPrice,
    required this.unitType,
    this.stock,
    required this.averageCost,
    this.description,
    this.id,
    required this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    print(json['name']);
    print(json['manufacturer']);
    print(json['model']);
    print(json['unit_type']);
    return Product(
      category: json['category'] != null
          ? ProductCategory.fromJson(json['category'])
          : null,
      name: json['name'] ?? '', // Provide a default value to avoid null issues
      manufacturer: json['manufacturer'] ?? '',
      model: json['model'] ?? '',
      specifications: Map<String, dynamic>.from(json['specifications'] ?? {}),
      unitPrice: json['unit_price'] != null
          ? (json['unit_price'] as num?)?.toDouble() ?? 0.0
          : 0.0,
      unitType: json['unit_type'] ?? '',
      stock: json['stock'] as int?,
      averageCost: json['average_cost'] != null
          ? (json['average_cost'] as num?)?.toDouble() ?? 0.0
          : 0.0,
      description: json['description'],
      id: json['id'] as int?,
      categoryId:
          json['category_id'] as int? ?? 0, // Assign a default value if null
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'category': category.toJson(),
      'name': name,
      'manufacturer': manufacturer,
      'model': model,
      'specifications': specifications,
      'unit_price': unitPrice,
      'unit_type': unitType,
      'stock': stock,
      'average_cost': averageCost,
      'description': description,
      // 'id': id,
      'category_id': categoryId,
      // 'created_at': createdAt?.toIso8601String(),
      // 'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
