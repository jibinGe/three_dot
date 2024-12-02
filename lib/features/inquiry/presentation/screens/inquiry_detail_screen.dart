import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/models/selected_product_model.dart';
import 'package:three_dot/features/inquiry/data/providers/inquiry_providers.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_stage2_screen.dart';
import 'package:three_dot/features/inquiry/presentation/widgets/products_table.dart';
import 'package:three_dot/features/project/presentation/widgets/project_form.dart';
import 'package:three_dot/shared/services/location_service.dart';

class InquiryDetailScreen extends ConsumerStatefulWidget {
  final int inquiryId;
  final bool? isJustCreated;

  const InquiryDetailScreen({
    Key? key,
    required this.inquiryId,
    this.isJustCreated = false,
  }) : super(key: key);

  @override
  ConsumerState<InquiryDetailScreen> createState() =>
      _InquiryDetailScreenState();
}

class _InquiryDetailScreenState extends ConsumerState<InquiryDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (!(widget.isJustCreated ?? false)) {
      Future.microtask(() => ref
          .read(inquiryNotifierProvider.notifier)
          .getInquiry(widget.inquiryId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final inquiryState = ref.watch(inquiryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiry Details'),
        // actions: [
        //   if (inquiryState.inquiry != null)
        //     IconButton(
        //       icon: const Icon(Icons.edit),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => InquiryStage2Screen(
        //               inquiryId: widget.inquiryId,
        //             ),
        //           ),
        //         );
        //       },
        //     ),
        // ],
      ),
      body: Builder(
        builder: (context) {
          if (inquiryState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final inquiry = inquiryState.inquiry;
          if (inquiry == null) {
            return const Center(child: Text('No data available'));
          }

          return _buildInquiryDetails(inquiry);
        },
      ),
      floatingActionButton: (inquiryState.inquiry != null &&
              inquiryState.inquiry?.inquiryStage == 4)
          ? ElevatedButton.icon(
              icon: const Icon(Icons.build),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) =>
                      ProjectForm(inquiry: inquiryState.inquiry!),
                );
              },
              label: const Text("Start Project"),
            )
          : null,
    );
  }

  Widget _buildInquiryDetails(InquiryModel inquiry) {
    final List<Widget> sections = [];

    // Add sections dynamically based on available data
    final basicInfo = _buildSection(
      'Basic Information',
      [
        _buildInfoRow('Name', inquiry.name),
        if (inquiry.consumerNumber != null)
          _buildInfoRow('Consumer Number', inquiry.consumerNumber!),
        if (inquiry.mobileNumber != null)
          _buildInfoRow('Mobile', inquiry.mobileNumber!),
        if (inquiry.email != null) _buildInfoRow('Email', inquiry.email!),
      ],
    );

    if (basicInfo != null) sections.add(basicInfo);

    final locationDetails = _buildSection(
      'Location Details',
      [
        if (inquiry.address != null) _buildInfoRow('Address', inquiry.address!),
        if (inquiry.location != null) const SizedBox.shrink(),
        // if (inquiry.location != null)
        //   Row(
        //     children: [
        //       const Spacer(),
        //       Transform.scale(
        //         scale: 0.7,
        //         child: ElevatedButton.icon(
        //           onPressed: () {
        //             LocationService.launchMap(
        //                 inquiry.location!.lat, inquiry.location!.lng);
        //           },
        //           icon: const Icon(Icons.location_on),
        //           label: const Text("Open Map"),
        //         ),
        //       ),
        //     ],
        //   ),
      ],
      titleButton: Transform.scale(
        scale: 0.7,
        child: ElevatedButton.icon(
          onPressed: () {
            LocationService.launchMap(
                inquiry.location!.lat, inquiry.location!.lng);
          },
          icon: const Icon(Icons.location_on),
          label: const Text("Open Map"),
        ),
      ),
    );

    if (locationDetails != null) sections.add(locationDetails);

    if ((inquiry.roofType?.isNotEmpty ?? false)) {
      final technicalDetails = _buildSection(
        'Technical Details',
        [
          if (inquiry.roofType != null)
            _buildInfoRow('Roof Type', inquiry.roofType!),
          if (inquiry.roofSpecification != null)
            _buildInfoRow('Specification', inquiry.roofSpecification!),
          if (inquiry.proposedAmount != null)
            _buildInfoRow(
              'Proposed Amount',
              '₹ ${inquiry.proposedAmount!.toStringAsFixed(2)}',
            ),
          if (inquiry.proposedCapacity != null)
            _buildInfoRow(
              'Proposed Capacity',
              '${inquiry.proposedCapacity} kW',
            ),
        ],
      );
      sections.add(technicalDetails);
    }

    if (inquiry.selectedProducts?.isNotEmpty ?? false) {
      final productsSection = _buildSection(
        'Selected Products',
        [
          ProductTable(
            products: inquiry.selectedProducts ?? <SelectedProductModel>[],
          ),
        ],
      );
      sections.add(productsSection);
    }

    final quotationDetails = _buildSection("Quotation Details", [
      if (inquiry.quotationStatus != null)
        _buildInfoRow('Quotation Status', inquiry.quotationStatus!),
      if (inquiry.confirmationStatus != null)
        _buildInfoRow('Confirmation Status', inquiry.confirmationStatus!),
      if (inquiry.paymentTerms != null)
        _buildInfoRow('Payment Terms', inquiry.paymentTerms!),
      if (inquiry.totalCost != null)
        _buildInfoRow(
          'Total Cost',
          "₹ ${inquiry.totalCost!.toStringAsFixed(2)}",
        ),
    ]);

    if (quotationDetails != null && inquiry.inquiryStage == 4) {
      sections.add(quotationDetails);
    }
    if (inquiry.inquiryStage == 1) {
      sections.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InquiryStage2Screen(
                        inquiryId: widget.inquiryId,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_chart_outlined),
                label: const Text("Go to Stage 2"),
              ),
            ],
          ),
        ),
      );
    }
    if (inquiry.inquiryStage == 2) {
      sections.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  await ref
                      .read(inquiryNotifierProvider.notifier)
                      .updateInquiryStage3(inquiryId: inquiry.id);
                },
                icon: const Icon(Icons.add_chart_outlined),
                label: const Text("Go to Stage 3"),
              ),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: sections,
    );
  }

  Widget _buildSection(String title, List<Widget> children,
      {Widget? titleButton}) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                titleButton ?? const SizedBox.shrink()
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
