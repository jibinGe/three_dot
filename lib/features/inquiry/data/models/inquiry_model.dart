import 'package:three_dot/features/inquiry/data/models/location_model.dart';
import 'package:three_dot/features/inquiry/data/models/referred_by_model.dart';
import 'package:three_dot/features/inquiry/data/models/selected_product_model.dart';

class InquiryModel {
  final int id;
  final String inquiryNumber;
  final int inquiryStage;
  final String name;
  final String consumerNumber;
  final String address;
  final String mobileNumber;
  final String email;
  final LocationModel location;
  final ReferredByModel? referredBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String roofType;
  final String roofSpecification;
  final double proposedAmount;
  final double proposedCapacity;
  final String paymentTerms;
  final double totalCost;
  final String quotationStatus;
  final String? quotationRejectionReason;
  final String confirmationStatus;
  final String? confirmationRejectionReason;
  final double agreedAmount;
  final List<SelectedProductModel> selectedProducts;

  InquiryModel({
    required this.id,
    required this.inquiryNumber,
    required this.inquiryStage,
    required this.name,
    required this.consumerNumber,
    required this.address,
    required this.mobileNumber,
    required this.email,
    required this.location,
    this.referredBy,
    required this.createdAt,
    required this.updatedAt,
    required this.roofType,
    required this.roofSpecification,
    required this.proposedAmount,
    required this.proposedCapacity,
    required this.paymentTerms,
    required this.totalCost,
    required this.quotationStatus,
    this.quotationRejectionReason,
    required this.confirmationStatus,
    this.confirmationRejectionReason,
    required this.agreedAmount,
    required this.selectedProducts,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    return InquiryModel(
      id: json['id'] ?? 0,
      inquiryNumber: json['inquiry_number'] ?? '',
      inquiryStage: json['inquiry_stage'] ?? 0,
      name: json['name'] ?? '',
      consumerNumber: json['consumer_number'] ?? '',
      address: json['address'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      email: json['email'] ?? '',
      location: LocationModel.fromJson(json['location'] ?? {}),
      referredBy: json['referred_by'] != null
          ? ReferredByModel.fromJson(json['referred_by'])
          : null,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      roofType: json['roof_type'] ?? '',
      roofSpecification: json['roof_specification'] ?? '',
      proposedAmount: json['proposed_amount']?.toDouble() ?? 0.0,
      proposedCapacity: json['proposed_capacity']?.toDouble() ?? 0.0,
      paymentTerms: json['payment_terms'] ?? '',
      totalCost: json['total_cost']?.toDouble() ?? 0.0,
      quotationStatus: json['quotation_status'] ?? '',
      quotationRejectionReason: json['quotation_rejection_reason'],
      confirmationStatus: json['confirmation_status'] ?? "",
      confirmationRejectionReason: json['confirmation_rejection_reason'],
      agreedAmount: json['agreed_amount']?.toDouble() ?? 0.0,
      selectedProducts: (json['selected_products'] as List<dynamic>? ?? [])
          .map((product) => SelectedProductModel.fromJson(product))
          .toList(),
    );
  }
}
