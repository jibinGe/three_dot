import 'package:three_dot/features/products/data/models/product_model.dart';

class SelectedProductModel {
  final int? id;
  final String? name;
  final int productId;
  final double quantity;
  final double unitPrice;
  final Product? product;

  SelectedProductModel({
    this.id,
    this.name,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.product,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }

  factory SelectedProductModel.fromJson(Map<String, dynamic> json) {
    return SelectedProductModel(
      id: json['id'] ?? 0,
      name: json['name'],
      productId: json['product_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      unitPrice: json['unit_price']?.toDouble() ?? 0.0,
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }
}

// class Product {
//   final int id;
//   final String category;
//   final String name;
//   final String manufacturer;
//   final String model;
//   final Specifications specifications;
//   final double unitPrice;
//   final String unitType;

//   Product({
//     required this.id,
//     required this.category,
//     required this.name,
//     required this.manufacturer,
//     required this.model,
//     required this.specifications,
//     required this.unitPrice,
//     required this.unitType,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'category': category,
//       'name': name,
//       'manufacturer': manufacturer,
//       'model': model,
//       'specifications': specifications.toJson(),
//       'unit_price': unitPrice,
//       'unit_type': unitType,
//     };
//   }

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'] ?? 0,
//       category: json['category'] ?? '',
//       name: json['name'] ?? '',
//       manufacturer: json['manufacturer'] ?? '',
//       model: json['model'] ?? '',
//       specifications: Specifications.fromJson(json['specifications'] ?? {}),
//       unitPrice: json['unit_price']?.toDouble() ?? 0.0,
//       unitType: json['unit_type'] ?? '',
//     );
//   }
// }

// class Specifications {
//   final String powerOutput;
//   final String efficiency;
//   final String dimensions;
//   final String weight;
//   final String cellType;
//   final String warranty;
//   final String additionalFeature;

//   Specifications({
//     required this.powerOutput,
//     required this.efficiency,
//     required this.dimensions,
//     required this.weight,
//     required this.cellType,
//     required this.warranty,
//     required this.additionalFeature,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'power_output': powerOutput,
//       'efficiency': efficiency,
//       'dimensions': dimensions,
//       'weight': weight,
//       'cell_type': cellType,
//       'warranty': warranty,
//       'additional_feature': additionalFeature,
//     };
//   }

//   factory Specifications.fromJson(Map<String, dynamic> json) {
//     return Specifications(
//       powerOutput: json['power_output'] ?? '',
//       efficiency: json['efficiency'] ?? '',
//       dimensions: json['dimensions'] ?? '',
//       weight: json['weight'] ?? '',
//       cellType: json['cell_type'] ?? '',
//       warranty: json['warranty'] ?? '',
//       additionalFeature: json['additional_feature'] ?? '',
//     );
//   }
// }



// Map<String, dynamic> toJson() {
//   return {
//     'product_id': productId,
//     'quantity': quantity,
//     'unit_price': unitPrice,
//   };
// }
