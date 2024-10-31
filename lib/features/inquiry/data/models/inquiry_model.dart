class Inquiry {
  final int id;
  final String inquiryNumber;
  final String name;
  final String consumerNumber;
  final String address;
  final String mobileNumber;
  final String email;
  final Map<String, double> location;
  final Map<String, dynamic> referredBy;
  final String roofType;
  final String roofSpecification;
  final double proposedAmount;
  final double agreedAmount;
  final String paymentTerms;
  final String quotationStatus;
  final String quotationRejectionReason;
  final bool confirmationStatus;
  final String confirmationRejectionReason;
  final List<InquiryProduct> selectedProducts;
  final DateTime createdAt;
  final DateTime updatedAt;

  Inquiry({
    required this.id,
    required this.inquiryNumber,
    required this.name,
    required this.consumerNumber,
    required this.address,
    required this.mobileNumber,
    required this.email,
    required this.location,
    required this.referredBy,
    required this.roofType,
    required this.roofSpecification,
    required this.proposedAmount,
    required this.agreedAmount,
    required this.paymentTerms,
    required this.quotationStatus,
    required this.quotationRejectionReason,
    required this.confirmationStatus,
    required this.confirmationRejectionReason,
    required this.selectedProducts,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: json['id'],
      inquiryNumber: json['inquiry_number'],
      name: json['name'],
      consumerNumber: json['consumer_number'],
      address: json['address'],
      mobileNumber: json['mobile_number'],
      email: json['email'],
      location: Map<String, double>.from(json['location']),
      referredBy: Map<String, dynamic>.from(json['referred_by']),
      roofType: json['roof_type'],
      roofSpecification: json['roof_specification'],
      proposedAmount: json['proposed_amount'].toDouble(),
      agreedAmount: json['agreed_amount'].toDouble(),
      paymentTerms: json['payment_terms'],
      quotationStatus: json['quotation_status'],
      quotationRejectionReason: json['quotation_rejection_reason'],
      confirmationStatus: json['confirmation_status'],
      confirmationRejectionReason: json['confirmation_rejection_reason'],
      selectedProducts: (json['selected_products'] as List)
          .map((product) => InquiryProduct.fromJson(product))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inquiry_number': inquiryNumber,
      'name': name,
      'consumer_number': consumerNumber,
      'address': address,
      'mobile_number': mobileNumber,
      'email': email,
      'location': location,
      'referred_by': referredBy,
      'roof_type': roofType,
      'roof_specification': roofSpecification,
      'proposed_amount': proposedAmount,
      'agreed_amount': agreedAmount,
      'payment_terms': paymentTerms,
      'quotation_status': quotationStatus,
      'quotation_rejection_reason': quotationRejectionReason,
      'confirmation_status': confirmationStatus,
      'confirmation_rejection_reason': confirmationRejectionReason,
      'selected_products':
          selectedProducts.map((product) => product.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class InquiryProduct {
  final int id;
  final int productId;
  final int quantity;
  final double unitPrice;
  final Map<String, dynamic> product;

  InquiryProduct({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.product,
  });

  factory InquiryProduct.fromJson(Map<String, dynamic> json) {
    return InquiryProduct(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
      product: Map<String, dynamic>.from(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'product': product,
    };
  }
}
