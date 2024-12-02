import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_state.dart';
import 'package:three_dot/features/inquiry/data/models/location_model.dart';
import 'package:three_dot/features/inquiry/data/models/selected_product_model.dart';
import 'package:three_dot/features/inquiry/data/repositories/inquiry_repository.dart';

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
      state = state.copyWith(isLoading: false, inquiry: inquiry, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
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
      getAllInquiries();
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

  Future<void> updateInquiryStage3({
    required int inquiryId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final inquiry = await _repository.updateInquiryStage3(
        inquiryId: inquiryId,
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
}
