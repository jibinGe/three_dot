import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';

class InquiryState {
  final bool isLoading;
  final InquiryModel? inquiry;
  final String? error;
  final List<InquiryModel> inquiries;

  const InquiryState({
    this.isLoading = false,
    this.inquiry,
    this.error,
    this.inquiries = const [],
  });

  InquiryState copyWith({
    bool? isLoading,
    InquiryModel? inquiry,
    String? error,
    List<InquiryModel>? inquiries,
  }) {
    return InquiryState(
      isLoading: isLoading ?? this.isLoading,
      inquiry: inquiry ?? this.inquiry,
      error: error ?? this.error,
      inquiries: inquiries ?? this.inquiries,
    );
  }
}
