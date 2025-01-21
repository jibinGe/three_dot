import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';

class AllWorksState {
  final bool isLoading;
  final bool isLoadingCounts;
  final List<InquiryModel> inquiries;
  final int currentPage;
  final int totalPages;
  final int totalFiltered;
  final Map<String, int>? counts;
  final String? error;

  const AllWorksState({
    this.isLoading = false,
    this.isLoadingCounts = false,
    this.inquiries = const [],
    this.currentPage = 1,
    this.totalPages = 0,
    this.totalFiltered = 0,
    this.counts,
    this.error,
  });

  AllWorksState copyWith({
    bool? isLoading,
    bool? isLoadingCounts,
    List<InquiryModel>? inquiries,
    int? currentPage,
    int? totalPages,
    int? totalFiltered,
    Map<String, int>? counts,
    String? error,
  }) {
    return AllWorksState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingCounts: isLoadingCounts ?? this.isLoadingCounts,
      inquiries: inquiries ?? this.inquiries,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalFiltered: totalFiltered ?? this.totalFiltered,
      counts: counts ?? this.counts,
      error: error ?? this.error,
    );
  }
}
