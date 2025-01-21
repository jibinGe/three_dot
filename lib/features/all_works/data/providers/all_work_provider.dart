import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/all_works/data/model/all_works_state.dart';
import 'package:three_dot/features/all_works/data/repositories/all_work_repository.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';

final allWorkRepositoryProvider = Provider((ref) => AllWorkRepository());

final allWorkProvider =
    StateNotifierProvider<AllWorkNotifier, AllWorksState>((ref) {
  return AllWorkNotifier(ref.watch(allWorkRepositoryProvider));
});

class AllWorkNotifier extends StateNotifier<AllWorksState> {
  final AllWorkRepository _repository;

  AllWorkNotifier(this._repository) : super(const AllWorksState()) {
    loadCounts(); // Automatically load counts when notifier is initialized
  }

  Future<void> loadProjects({
    required int inquiryStage,
    String? quotationStatus,
    String? confirmationStatus,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getList(
        pageNo: state.currentPage,
        pageSize: 10,
        inquiryStage: inquiryStage,
        quotationStatus: quotationStatus,
        confirmationStatus: confirmationStatus,
      );
      if (response.statusCode == 200) {
        state = state.copyWith(
          isLoading: false,
          inquiries: (response.data["items"] as List)
              .map((json) => InquiryModel.fromJson(json))
              .toList(),
          currentPage: response.data["page"],
          totalPages: response.data["pages"],
          totalFiltered: response.data["total_filtered"],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.data["message"],
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadCounts() async {
    state = state.copyWith(isLoadingCounts: true, error: null);
    try {
      final counts = await _repository.getcounts();
      state = state.copyWith(isLoadingCounts: false, counts: counts);
    } catch (e) {
      state = state.copyWith(
        isLoadingCounts: false,
        error: e.toString(),
      );
    }
  }
}
