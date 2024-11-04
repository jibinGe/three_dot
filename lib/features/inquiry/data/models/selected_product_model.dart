class SelectedProductModel {
  final int productId;
  final int quantity;
  final double unitPrice;

  SelectedProductModel({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
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
      productId: json['product_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      unitPrice: json['unit_price']?.toDouble() ?? 0.0,
    );
  }
}
