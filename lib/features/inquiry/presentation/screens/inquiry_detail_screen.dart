import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/providers/inquiry_providers.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_stage2_screen.dart';

class InquiryDetailScreen extends ConsumerStatefulWidget {
  final int inquiryId;
  final bool? isJustCreated;

  const InquiryDetailScreen(
      {Key? key, required this.inquiryId, this.isJustCreated = false})
      : super(key: key);

  @override
  ConsumerState<InquiryDetailScreen> createState() =>
      _InquiryDetailScreenState();
}

class _InquiryDetailScreenState extends ConsumerState<InquiryDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Load inquiry details
    if (!widget.isJustCreated!) {
      Future.microtask(() =>
          ref.read(inquiryProvider.notifier).getInquiry(widget.inquiryId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final inquiryState = ref.watch(inquiryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiry Details'),
        actions: [
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
      body: inquiryState.when(
        data: (inquiry) {
          if (inquiry == null) {
            return const Center(child: Text('No data available'));
          }
          return _buildInquiryDetails(inquiry);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
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
            _buildInfoRow('Consumer Number', inquiry.consumerNumber),
            _buildInfoRow('Mobile', inquiry.mobileNumber),
            _buildInfoRow('Email', inquiry.email),
          ],
        ),
        const SizedBox(height: 16),
        _buildSection(
          'Location Details',
          [
            _buildInfoRow('Address', inquiry.address),
            _buildInfoRow(
              'Coordinates',
              'Lat: ${inquiry.location.lat}, Long: ${inquiry.location.lng}',
            ),
          ],
        ),
        if (inquiry.roofType != "") ...[
          const SizedBox(height: 16),
          _buildSection(
            'Technical Details',
            [
              _buildInfoRow('Roof Type', inquiry.roofType),
              _buildInfoRow('Specification', inquiry.roofSpecification),
              _buildInfoRow(
                'Proposed Amount',
                '\$${inquiry.proposedAmount.toStringAsFixed(2)}',
              ),
              _buildInfoRow(
                'Proposed Capacity',
                '${inquiry.proposedCapacity} kW',
              ),
            ],
          ),
        ],
        if (inquiry.selectedProducts.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSection(
              'Selected Products',
              List.generate(
                inquiry.selectedProducts.length,
                (index) => _buildInfoRow(
                    "Product ID : ${inquiry.selectedProducts[index].id?.toString() ?? ""}",
                    "Quantity : ${inquiry.selectedProducts[index].quantity.toString()}"),
              )),
        ]
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
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
