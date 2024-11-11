import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/models/selected_product_model.dart';
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
        if (inquiry.selectedProducts?.isNotEmpty ?? false) ...[
          const SizedBox(height: 16),
          _buildSection('Selected Products', [
            ProductTable(
                products: inquiry.selectedProducts ?? <SelectedProductModel>[])
          ]
              // List.generate(
              //   inquiry.selectedProducts.length,
              //   (index) => _buildInfoRow(
              //       "Product ID : ${inquiry.selectedProducts[index].id?.toString() ?? ""}",
              //       "Quantity : ${inquiry.selectedProducts[index].quantity.toString()}"),
              // )
              ),
        ],
        _buildSection("Quotation Details", [
          _buildInfoRow(
            'Quotation Satatus',
            inquiry.quotationStatus,
          ),
          _buildInfoRow(
            'Confirmation Satatus',
            inquiry.confirmationStatus,
          ),
          _buildInfoRow(
            'Payment Terms',
            inquiry.paymentTerms,
          ),
          _buildInfoRow(
            'Total Cost',
            inquiry.totalCost.toStringAsFixed(2),
          ),
        ])
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
            // width: 120,
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

class ProductTable extends StatelessWidget {
  final List<SelectedProductModel> products;

  ProductTable({required this.products});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 10, // Reduces space between columns
        columns: const [
          DataColumn(label: SizedBox(width: 40, child: Text('Index'))),
          DataColumn(label: Text('Product Name')),
          DataColumn(label: Text('Unit Price')),
          DataColumn(label: Text('Quantity')),
        ],
        rows: List.generate(products.length, (index) {
          final product = products[index];
          return DataRow(cells: [
            DataCell(
              SizedBox(
                width: 40,
                child: Center(child: Text((index + 1).toString())),
              ),
            ),
            DataCell(
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text(
                  product.name ?? product.product?.name ?? 'N/A',
                  // overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
            DataCell(
              FittedBox(
                child: Text('${product.unitPrice.toStringAsFixed(0)}'),
              ),
            ),
            DataCell(
              FittedBox(
                child: Text(
                    '${product.quantity.toStringAsFixed(0)} (${product.product?.unitType ?? ""})'),
              ),
            ),
          ]);
        }),
      ),
    );
  }
}
