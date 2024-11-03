import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_detail_screen.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_form_screen.dart';

class InquiryListScreen extends ConsumerWidget {
  const InquiryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiries'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInquiryCard(context),
          _buildInquiryCard(context),
          // Add more cards or implement list from API
        ],
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

  Widget _buildInquiryCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: const Text('John Doe'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('INQ-001'),
            Text('Stage: Initial Survey'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InquiryDetailScreen(inquiryId: 1),
            ),
          );
        },
      ),
    );
  }
}
