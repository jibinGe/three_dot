import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/providers/inquiry_list_provider.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_detail_screen.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_form_screen.dart';

class InquiryListScreen extends ConsumerWidget {
  const InquiryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inquiriesAsync = ref.watch(inquiryListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiries'),
      ),
      body: inquiriesAsync.when(
        // data: (products) => ProductGrid(products: products),
        data: (inquiries) => inquiries.isEmpty
            ? const Center(child: Text('No products found'))
            : InquiryList(inquiries: inquiries),
        loading: () => Center(
            child: LoadingAnimationWidget.threeArchedCircle(
          color: AppColors.textPrimary,
          size: 24,
        )),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InquiryFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInquiryCard(BuildContext context, InquiryModel inquiry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: Text(inquiry.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(inquiry.consumerNumber),
            Text('Stage: ${inquiry.inquiryStage}'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InquiryDetailScreen(inquiryId: inquiry.id),
            ),
          );
        },
      ),
    );
  }

  InquiryList({required List<InquiryModel> inquiries}) {
    return ListView.builder(
        itemCount: inquiries.length,
        itemBuilder: (context, index) =>
            _buildInquiryCard(context, inquiries[index]));
  }
}
