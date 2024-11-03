import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/models/location_model.dart';
import 'package:three_dot/features/inquiry/data/models/selected_product_model.dart';
import 'package:three_dot/features/inquiry/data/repositories/inquiry_repository.dart';

final inquiryRepositoryProvider = Provider((ref) => InquiryRepository());

final inquiryProvider =
    StateNotifierProvider<InquiryNotifier, AsyncValue<InquiryModel?>>((ref) {
  return InquiryNotifier(ref.watch(inquiryRepositoryProvider));
});

class InquiryNotifier extends StateNotifier<AsyncValue<InquiryModel?>> {
  final InquiryRepository _repository;

  InquiryNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> getInquiry(int id) async {
    state = const AsyncValue.loading();
    try {
      final inquiry = await _repository.getInquiry(id);
      state = AsyncValue.data(inquiry);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createInquiryStage1({
    required String name,
    required String consumerNumber,
    required String address,
    required String mobileNumber,
    required String email,
    required LocationModel location,
    int? referredById,
  }) async {
    state = const AsyncValue.loading();
    debugPrint("Notifire called >>>>>>>>>>>>>>>>>>>>>>>");
    try {
      final inquiry = await _repository.createInquiryStage1(
        name: name,
        consumerNumber: consumerNumber,
        address: address,
        mobileNumber: mobileNumber,
        email: email,
        location: location,
        referredById: referredById ?? 1,
      );
      state = AsyncValue.data(inquiry);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateInquiryStage2({
    required int inquiryId,
    required String roofType,
    required String roofSpecification,
    required double proposedAmount,
    required double proposedCapacity,
    required String paymentTerms,
    required List<SelectedProductModel> selectedProducts,
  }) async {
    state = const AsyncValue.loading();
    try {
      final inquiry = await _repository.updateInquiryStage2(
        inquiryId: inquiryId,
        roofType: roofType,
        roofSpecification: roofSpecification,
        proposedAmount: proposedAmount,
        proposedCapacity: proposedCapacity,
        paymentTerms: paymentTerms,
        selectedProducts: selectedProducts,
      );
      state = AsyncValue.data(inquiry);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
