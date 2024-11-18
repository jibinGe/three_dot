import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/providers/inquiry_providers.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_detail_screen.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_form_screen.dart';

class InquiryListScreen extends ConsumerStatefulWidget {
  const InquiryListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<InquiryListScreen> createState() => _InquiryListScreenState();
}

class _InquiryListScreenState extends ConsumerState<InquiryListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(inquiryNotifierProvider.notifier).getAllInquiries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final inquiryState = ref.watch(inquiryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(inquiryNotifierProvider.notifier).getAllInquiries(),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (inquiryState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (inquiryState.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${inquiryState.error}'),
                  ElevatedButton(
                    onPressed: () => ref
                        .read(inquiryNotifierProvider.notifier)
                        .getAllInquiries(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (inquiryState.inquiries.isEmpty) {
            return const Center(child: Text('No inquiries found'));
          }

          return ListView.builder(
            itemCount: inquiryState.inquiries.length,
            itemBuilder: (context, index) =>
                _buildInquiryCard(context, inquiryState.inquiries[index]),
          );
        },
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
            // Add inquiry stage or other relevant details
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
}
