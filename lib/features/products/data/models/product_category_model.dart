class ProductCategory {
  final int? id;
  final String name;
  final String code;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductCategory({
    this.id,
    required this.name,
    required this.code,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'description': description,
    };
  }
}
