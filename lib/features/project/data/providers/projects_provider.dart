import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/project/data/model/projectModel.dart';
import 'package:three_dot/features/project/data/providers/projects_list_provider.dart';
import 'package:three_dot/features/project/data/repositories/project_repository.dart';

final projectProvider =
    StateNotifierProvider<ProjectNotifier, AsyncValue<ProjectModel?>>((ref) {
  return ProjectNotifier(ref.watch(projectRepositoryProvider));
});

class ProjectNotifier extends StateNotifier<AsyncValue<ProjectModel?>> {
  final ProjectRepository _repository;

  ProjectNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> getProject(int id) async {
    state = const AsyncValue.loading();
    try {
      final inquiry = await _repository.getProject(id);
      state = AsyncValue.data(inquiry);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createProject({
    required int inquiryId,
    required int statusId,
    required double amountCollected,
    required double balenceAmount,
    required bool subsidyStatus,
    required String latestStatus,
  }) async {
    state = const AsyncValue.loading();
    debugPrint("Notifire called >>>>>>>>>>>>>>>>>>>>>>>");
    try {
      final project = await _repository.createProject(
          amountCollected: amountCollected,
          balenceAmount: balenceAmount,
          inquiryId: inquiryId,
          latestStatus: latestStatus,
          statusId: statusId,
          subsidyStatus: subsidyStatus);
      state = AsyncValue.data(project);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Future<void> updateInquiryStage2({
  //   required int inquiryId,
  //   required String roofType,
  //   required String quotationStatus,
  //   required String confirmationStatus,
  //   required String roofSpecification,
  //   required double proposedAmount,
  //   required double proposedCapacity,
  //   required String paymentTerms,
  //   required String quotationRejectionReason,
  //   required String confirmationRejectionReason,
  //   required List<SelectedProductModel> selectedProducts,
  // }) async {
  //   state = const AsyncValue.loading();
  //   try {
  //     final inquiry = await _repository.updateInquiryStage2(
  //       inquiryId: inquiryId,
  //       roofType: roofType,
  //       quotationStatus: quotationStatus,
  //       confirmationStatus: confirmationStatus,
  //       roofSpecification: roofSpecification,
  //       quotationRejectionReason: quotationRejectionReason,
  //       confirmationRejectionReason: confirmationRejectionReason,
  //       proposedAmount: proposedAmount,
  //       proposedCapacity: proposedCapacity,
  //       paymentTerms: paymentTerms,
  //       selectedProducts: selectedProducts,
  //     );
  //     state = AsyncValue.data(inquiry);
  //   } catch (e, st) {
  //     state = AsyncValue.error(e, st);
  //   }
  // }
}
