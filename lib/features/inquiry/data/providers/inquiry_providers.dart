import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_state.dart';
import 'package:three_dot/features/inquiry/data/models/location_model.dart';
import 'package:three_dot/features/inquiry/data/models/selected_product_model.dart';
import 'package:three_dot/features/inquiry/data/repositories/inquiry_repository.dart';
import 'package:three_dot/features/inquiry/presentation/screens/pdf_viewer.dart';
import 'package:three_dot/shared/services/pdf_generator.dart';

final inquiryRepositoryProvider = Provider<InquiryRepository>((ref) {
  return InquiryRepository();
});

final inquiryNotifierProvider =
    StateNotifierProvider<InquiryNotifier, InquiryState>((ref) {
  return InquiryNotifier(ref.watch(inquiryRepositoryProvider));
});

class InquiryNotifier extends StateNotifier<InquiryState> {
  final InquiryRepository _repository;

  InquiryNotifier(this._repository) : super(const InquiryState());

  Future<void> getAllInquiries({String? stage}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final inquiries = await _repository.getAllInquiries(stage: stage);
      print("Inquiry : $inquiries");
      state = state.copyWith(isLoading: false, inquiries: inquiries);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> getInquiry(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final inquiry = await _repository.getInquiry(id);
      state = state.copyWith(isLoading: false, inquiry: inquiry);
      print("Inquiry fetched successfully: ${inquiry.id}");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      print("Error fetching inquiry: $e");
    }
  }

  Future<void> createInquiryStage1({
    required String name,
    // required String consumerNumber,
    // required String address,
    required String mobileNumber,
    required LocationModel? location,
    // required String email,
    // required LocationModel location,
    // int? referredById,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final inquiry = await _repository.createInquiryStage1(
        name: name,
        // consumerNumber: consumerNumber,
        // address: address,
        mobileNumber: mobileNumber,
        // email: email,
        location: location,
        // referredById: referredById ?? 1,
      );
      getAllInquiries(stage: "1");
      state = state.copyWith(
        isLoading: false,
        inquiry: inquiry,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateInquiryStage2({
    required int inquiryId,
    required String roofType,
    // required String quotationStatus,
    // required String confirmationStatus,
    required String roofSpecification,
    required double proposedAmount,
    required double proposedCapacity,
    required String paymentTerms,
    // required String quotationRejectionReason,
    // required String confirmationRejectionReason,
    required List<SelectedProductModel> selectedProducts,
    required LocationModel location,
    required String email,
    required String address,
    required String consumerNo,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final inquiry = await _repository.updateInquiryStage2(
        inquiryId: inquiryId,
        roofType: roofType,
        consumerNo: consumerNo,
        address: address,
        email: email,
        location: location,
        // quotationStatus: quotationStatus,
        // confirmationStatus: confirmationStatus,
        roofSpecification: roofSpecification,
        proposedAmount: proposedAmount,
        proposedCapacity: proposedCapacity,
        paymentTerms: paymentTerms,
        // quotationRejectionReason: quotationRejectionReason,
        // confirmationRejectionReason: confirmationRejectionReason,
        selectedProducts: selectedProducts,
      );
      state = state.copyWith(
        isLoading: false,
        inquiry: inquiry,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateQuotationStatus({
    required int inquiryId,
    required String quotationStatus,
    required String confirmationStatus,
    required String quotationRejectionReason,
    required String confirmationRejectionReason,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final inquiry = await _repository.updateQuotationStatus(
        inquiryId: inquiryId,
        quotationStatus: quotationStatus,
        confirmationStatus: confirmationStatus,
        quotationRejectionReason: quotationRejectionReason,
        confirmationRejectionReason: confirmationRejectionReason,
      );
      state = state.copyWith(
        isLoading: false,
        inquiry: inquiry,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateInquiryStage3({
    required int inquiryId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final inquiry = await _repository.updateInquiryStage3(
        inquiryId: inquiryId,
      );
      getAllInquiries(stage: "2");
      state = state.copyWith(
        isLoading: false,
        inquiry: inquiry,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateInquiryStage4({
    required int inquiryId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final inquiry = await _repository.updateInquiryToStage4(
        inquiryId: inquiryId,
      );
      getAllInquiries(stage: "3");
      state = state.copyWith(
        isLoading: false,
        inquiry: inquiry,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateInquiryStage5({
    required int inquiryId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final inquiry = await _repository.updateInquiryToStage5(
        inquiryId: inquiryId,
      );
      getAllInquiries(stage: "4");
      state = state.copyWith(
        isLoading: false,
        inquiry: inquiry,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addProducts({
    required int inquiryId,
    required List<SelectedProductModel> selectedProducts,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final inquiry = await _repository.updateInquiryStage4(
        inquiryId: inquiryId,
        selectedProducts: selectedProducts,
      );
      state = state.copyWith(
        isLoading: false,
        inquiry: inquiry,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> showPdf(BuildContext context, InquiryModel inquiry) async {
    try {
      final generator = QuotationPdfGenerator(inquiry: inquiry);
      final pdf = await generator.generatePdf();

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuotationPdfViewer(
            inquiry: inquiry,
            pdfBytes: pdf,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
