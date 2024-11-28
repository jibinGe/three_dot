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
        actions: [
          if (inquiryState.inquiry != null)
            IconButton(
              icon: const Icon(Icons.edit),
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
                        .getInquiry(widget.inquiryId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final inquiry = inquiryState.inquiry;
          if (inquiry == null) {
            return const Center(child: Text('No data available'));
          }

          return _buildInquiryDetails(inquiry);
        },
      ),
      floatingActionButton: inquiryState.inquiry != null
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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSection(
          'Basic Information',
          [
            _buildInfoRow('Name', inquiry.name),
            _buildInfoRow('Consumer Number', inquiry.consumerNumber ?? 'N/A'),
            _buildInfoRow('Mobile', inquiry.mobileNumber ?? 'N/A'),
            _buildInfoRow('Email', inquiry.email ?? 'N/A'),
          ],
        ),
        const SizedBox(height: 16),
        _buildSection(
          'Location Details',
          [
            _buildInfoRow('Address', inquiry.address ?? 'N/A'),
            _buildInfoRow(
              'Coordinates',
              inquiry.location != null
                  ? 'Lat: ${inquiry.location!.lat}, Long: ${inquiry.location!.lng}'
                  : 'N/A',
            ),
            if (inquiry.location != null)
              Row(
                children: [
                  const Spacer(),
                  Transform.scale(
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
                ],
              ),
          ],
        ),
        if ((inquiry.roofType?.isNotEmpty ?? false)) ...[
          const SizedBox(height: 16),
          _buildSection(
            'Technical Details',
            [
              _buildInfoRow('Roof Type', inquiry.roofType ?? 'N/A'),
              _buildInfoRow(
                  'Specification', inquiry.roofSpecification ?? 'N/A'),
              _buildInfoRow(
                'Proposed Amount',
                inquiry.proposedAmount != null
                    ? '₹ ${inquiry.proposedAmount!.toStringAsFixed(2)}'
                    : 'N/A',
              ),
              _buildInfoRow(
                'Proposed Capacity',
                inquiry.proposedCapacity != null
                    ? '${inquiry.proposedCapacity} kW'
                    : 'N/A',
              ),
            ],
          ),
        ],
        if (inquiry.selectedProducts?.isNotEmpty ?? false) ...[
          const SizedBox(height: 16),
          _buildSection('Selected Products', [
            ProductTable(
              products: inquiry.selectedProducts ?? <SelectedProductModel>[],
            ),
          ]),
        ],
        _buildSection("Quotation Details", [
          _buildInfoRow(
            'Quotation Status',
            inquiry.quotationStatus ?? 'N/A',
          ),
          _buildInfoRow(
            'Confirmation Status',
            inquiry.confirmationStatus ?? 'N/A',
          ),
          _buildInfoRow(
            'Payment Terms',
            inquiry.paymentTerms ?? 'N/A',
          ),
          _buildInfoRow(
            'Total Cost',
            inquiry.totalCost != null
                ? "₹ ${inquiry.totalCost!.toStringAsFixed(2)}"
                : 'N/A',
          ),
        ]),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
