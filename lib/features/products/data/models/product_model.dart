class Product {
  final String category;
  final String name;
  final String manufacturer;
  final String model;
  final Map<String, dynamic> specifications;
  final double unitPrice;
  final String unitType;
  final int? stock;
  final String? description;
  final int id;

  Product({
    required this.category,
    required this.name,
    required this.manufacturer,
    required this.model,
    required this.specifications,
    required this.unitPrice,
    required this.unitType,
    this.stock,
    this.description,
    required this.id,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      category: json['category'],
      name: json['name'],
      manufacturer: json['manufacturer'],
      model: json['model'],
      specifications: Map<String, dynamic>.from(json['specifications']),
      unitPrice: json['unit_price'].toDouble(),
      unitType: json['unit_type'],
      stock: json['stock'],
      description: json['description'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'name': name,
      'manufacturer': manufacturer,
      'model': model,
      'specifications': specifications,
      'unit_price': unitPrice.toInt(),
      'unit_type': unitType,
      'stock': stock,
      'description': description,
      // 'id': id,
    };
  }
}
