import 'package:three_dot/features/inquiry/data/models/location_model.dart';
import 'package:three_dot/features/inquiry/data/models/referred_by_model.dart';
import 'package:three_dot/features/inquiry/data/models/selected_product_model.dart';

class InquiryModel {
  final int id;
  final String inquiryNumber;
  final int inquiryStage;
  final String name;
  final String? consumerNumber; // Nullable
  final String? address; // Nullable
  final String? mobileNumber; // Nullable
  final String? email; // Nullable
  final LocationModel? location; // Nullable
  final ReferredByModel? referredBy; // Nullable
  final DateTime? createdAt; // Nullable
  final DateTime? updatedAt; // Nullable
  final String? roofType; // Nullable
  final String? roofSpecification; // Nullable
  final double? proposedAmount; // Nullable
  final double? proposedCapacity; // Nullable
  final String? paymentTerms; // Nullable
  final double? totalCost; // Nullable
  final String? quotationStatus; // Nullable
  final String? quotationRejectionReason; // Nullable
  final String? confirmationStatus; // Nullable
  final String? confirmationRejectionReason; // Nullable
  final double? agreedAmount; // Nullable
  final List<SelectedProductModel>? selectedProducts; // Nullable

  InquiryModel({
    required this.id,
    required this.inquiryNumber,
    required this.inquiryStage,
    required this.name,
    this.consumerNumber,
    this.address,
    this.mobileNumber,
    this.email,
    this.location,
    this.referredBy,
    this.createdAt,
    this.updatedAt,
    this.roofType,
    this.roofSpecification,
    this.proposedAmount,
    this.proposedCapacity,
    this.paymentTerms,
    this.totalCost,
    this.quotationStatus,
    this.quotationRejectionReason,
    this.confirmationStatus,
    this.confirmationRejectionReason,
    this.agreedAmount,
    this.selectedProducts,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    return InquiryModel(
      id: json['id'] ?? 0,
      inquiryNumber: json['inquiry_number'] ?? '',
      inquiryStage: json['inquiry_stage'] ?? 0,
      name: json['name'] ?? '',
      consumerNumber: json['consumer_number'],
      address: json['address'],
      mobileNumber: json['mobile_number'],
      email: json['email'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      referredBy: json['referred_by'] != null
          ? ReferredByModel.fromJson(json['referred_by'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      roofType: json['roof_type'],
      roofSpecification: json['roof_specification'],
      proposedAmount: json['proposed_amount']?.toDouble(),
      proposedCapacity: json['proposed_capacity']?.toDouble(),
      paymentTerms: json['payment_terms'],
      totalCost: json['total_cost']?.toDouble(),
      quotationStatus: json['quotation_status'],
      quotationRejectionReason: json['quotation_rejection_reason'],
      confirmationStatus: json['confirmation_status'],
      confirmationRejectionReason: json['confirmation_rejection_reason'],
      agreedAmount: json['agreed_amount']?.toDouble(),
      selectedProducts: json['selected_products'] != null
          ? (json['selected_products'] as List<dynamic>?)
              ?.map((product) => SelectedProductModel.fromJson(product))
              .toList()
          : null,
    );
  }
}
