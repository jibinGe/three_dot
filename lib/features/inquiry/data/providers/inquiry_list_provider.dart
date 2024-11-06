import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/providers/inquiry_providers.dart';
import 'package:three_dot/features/inquiry/data/repositories/inquiry_repository.dart';

final inquiryListProvider =
    FutureProvider.autoDispose<List<InquiryModel>>((ref) {
  final repository = ref.watch(inquiryRepositoryProvider);
  return repository.getAllInquiries();
});
