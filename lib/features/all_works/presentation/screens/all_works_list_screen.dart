import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/all_works/data/providers/all_work_provider.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_detail_screen.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_form_screen.dart';

class AllWorkListScreen extends ConsumerStatefulWidget {
  final int inquirySate;
  final String title;
  final String? quetationSataus;
  final String? confirmationStatus;
  const AllWorkListScreen({
    Key? key,
    required this.inquirySate,
    required this.title,
    this.quetationSataus,
    this.confirmationStatus,
  }) : super(key: key);

  @override
  ConsumerState<AllWorkListScreen> createState() => _AllWorkListScreenState();
}

class _AllWorkListScreenState extends ConsumerState<AllWorkListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(
      () => ref.read(allWorkProvider.notifier).loadProjects(
          inquiryStage: widget.inquirySate,
          quotationStatus: widget.quetationSataus,
          confirmationStatus: widget.confirmationStatus),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(allWorkProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: state.isLoading
          ? Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.textPrimary,
                size: 24,
              ),
            )
          : state.error != null
              ? Center(child: Text('Error: ${state.error}'))
              : state.inquiries.isEmpty
                  ? widget.inquirySate == 1
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('No projects found'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const InquiryFormScreen(),
                                    ),
                                  );
                                },
                                child: const Text('Create New Inquiry'),
                              ),
                            ],
                          ),
                        )
                      : const Center(child: Text('No projects found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.inquiries.length,
                      itemBuilder: (context, index) =>
                          _buildInquiryCard(context, state.inquiries[index])),
    );
  }

  Widget _buildInquiryCard(BuildContext context, InquiryModel inquiry) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          inquiry.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (inquiry.consumerNumber != null && inquiry.consumerNumber != "")
              Text('Consumer Number: ${inquiry.consumerNumber}'),
            Text('Mobile: ${inquiry.mobileNumber}'),
            if (inquiry.proposedAmount != null)
              Text(
                'Proposed Amount: ₹${inquiry.proposedAmount?.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green),
              ),
            if (inquiry.proposedCapacity != null)
              Text(
                'Capacity: ${inquiry.proposedCapacity?.toStringAsFixed(2)} kW',
                style: const TextStyle(color: Colors.blue),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InquiryDetailScreen(
                inquiryId: inquiry.id,
                isFromHomePage: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
