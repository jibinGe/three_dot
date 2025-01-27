import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/models/selected_product_model.dart';
import 'package:three_dot/features/inquiry/data/providers/inquiry_providers.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_stage2_screen.dart';
import 'package:three_dot/features/inquiry/presentation/screens/products_adding_screen.dart';
import 'package:three_dot/features/inquiry/presentation/widgets/products_table.dart';
import 'package:three_dot/features/inquiry/presentation/widgets/quotation_form.dart';
import 'package:three_dot/features/inquiry/presentation/widgets/quotation_rejection_form.dart';
import 'package:three_dot/features/project/presentation/widgets/project_form.dart';
import 'package:three_dot/shared/services/location_service.dart';
import 'package:three_dot/shared/services/pdf_generator.dart';

class InquiryDetailScreen extends ConsumerStatefulWidget {
  final int inquiryId;
  final bool? isJustCreated;
  final bool? isFromHomePage;

  const InquiryDetailScreen({
    Key? key,
    required this.inquiryId,
    this.isJustCreated = false,
    this.isFromHomePage = false,
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
    print("Current State: ${inquiryState.inquiry}");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiry Details'),
      ),
      body: Builder(
        builder: (context) {
          if (inquiryState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (inquiryState.inquiry == null) {
            return const Center(child: Text('No data available'));
          }

          return _buildInquiryDetails(inquiryState.inquiry!);
        },
      ),
      // floatingActionButton: (inquiryState.inquiry != null &&
      //         inquiryState.inquiry?.inquiryStage == 4)
      //     ? ElevatedButton.icon(
      //         icon: const Icon(Icons.build),
      //         onPressed: () {
      //           showModalBottomSheet(
      //             context: context,
      //             isScrollControlled: true,
      //             builder: (context) =>
      //                 ProjectForm(inquiry: inquiryState.inquiry!),
      //           );
      //         },
      //         label: const Text("Start Project"),
      //       )
      //     : null,
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
        _buildInfoRow('Quotation Status', inquiry.quotationStatus!,
            color: inquiry.quotationStatus == "accepted"
                ? Colors.green
                : inquiry.quotationStatus == "rejected"
                    ? Colors.red
                    : Colors.yellow),
      if (inquiry.quotationStatus == "rejected")
        _buildInfoRow('Quotation Rejection Reason',
            inquiry.quotationRejectionReason ?? ""),
      if (inquiry.confirmationStatus != null)
        _buildInfoRow('Confirmation Status', inquiry.confirmationStatus!,
            color: inquiry.confirmationStatus == "accepted"
                ? Colors.green
                : inquiry.confirmationStatus == "rejected"
                    ? Colors.red
                    : Colors.yellow),
      if (inquiry.confirmationStatus == "rejected")
        _buildInfoRow('Confirmation Rejection Reason',
            inquiry.confirmationRejectionReason ?? ""),
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
    if (inquiry.inquiryStage == 3) {
      sections.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  // await ref
                  //     .read(inquiryNotifierProvider.notifier)
                  //     .updateInquiryStage3(inquiryId: inquiry.id);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductsAddingScreenScreen(inquiryId: inquiry.id),
                      ));
                },
                icon: const Icon(Icons.add_box_outlined),
                label: Text((inquiry.selectedProducts?.isEmpty ?? false)
                    ? "Add Products"
                    : "Edit Products"),
              ),
            ],
          ),
        ),
      );
    }
    if (inquiry.inquiryStage == 3 &&
        (inquiry.selectedProducts?.isNotEmpty ?? false) &&
        !widget.isFromHomePage!) {
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
                      .updateInquiryStage4(inquiryId: inquiry.id);
                },
                icon: const Icon(Icons.add_chart_outlined),
                label: Text("Go to Stage 4"),
              ),
            ],
          ),
        ),
      );
    }
    if (inquiry.inquiryStage == 4 && !widget.isFromHomePage!) {
      sections.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => QuotationForm(inquiry: inquiry),
                  );
                },
                icon: const Icon(Icons.edit_document),
                label: Text("Update Quotation Details"),
              ),
            ],
          ),
        ),
      );
    }
    if (inquiry.inquiryStage == 3 &&
        (inquiry.selectedProducts?.isNotEmpty ?? false) &&
        widget.isFromHomePage!) {
      sections.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => QuotationForm(
                      inquiry: inquiry,
                      isConfirmationOnly: true,
                    ),
                  );
                },
                icon: const Icon(Icons.edit_document),
                label: Text("Update Confirmation Satus"),
              ),
            ],
          ),
        ),
      );
    }
    if (inquiry.inquiryStage == 4) {
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
                      .showPdf(context, inquiry);
                  await ref
                      .read(inquiryNotifierProvider.notifier)
                      .updateQuotationStatus(
                          inquiryId: widget.inquiryId,
                          quotationStatus: "accepted",
                          confirmationStatus: "accepted",
                          quotationRejectionReason: "",
                          confirmationRejectionReason: "",
                          isConfirmationOnly: false);
                },
                icon: const Icon(Icons.file_open_sharp),
                label: Text("Generate Quotation"),
              ),
            ],
          ),
        ),
      );
    }
    if (inquiry.inquiryStage == 4) {
      sections.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => QuotationRejectionForm(
                      inquiry: inquiry,
                    ),
                  );
                },
                icon: const Icon(Icons.file_open_sharp),
                label: Text("Reject Quotation"),
              ),
            ],
          ),
        ),
      );
    }
    if (inquiry.inquiryStage == 4 &&
        inquiry.quotationStatus == "accepted" &&
        inquiry.confirmationStatus == "accepted") {
      sections.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => ProjectForm(inquiry: inquiry),
                  );
                },
                icon: const Icon(Icons.build),
                label: Text("Start Project"),
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

  Widget _buildInfoRow(String label, String value,
      {Color? color = AppColors.textPrimary}) {
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
            child: Text(
              value,
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
    );
  }

  // void generatePDF() async {
  //   final pdfGenerator = SolarQuotationPDF();
  //   final file = await pdfGenerator.generateQuotation(
  //     customerName: 'George',
  //     address: 'Nellikunnu\nThrissur',
  //     mobile: '8075693860',
  //     refNumber: '3DOT/SP/431/2024',
  //     date: DateTime.now(),
  //     totalAmount: 210000.00,
  //     subsidyAmount: 78000.00,
  //   );
  //   print(file.path);
  // }

  // void sharePDF() async {
  //   try {
  //     final pdfGenerator = SolarQuotationPDF();
  //     await pdfGenerator.generateAndShareQuotation(
  //       customerName: 'George',
  //       address: 'Nellikunnu\nThrissur',
  //       mobile: '8075693860',
  //       refNumber: '3DOT/SP/431/2024',
  //       date: DateTime.now(),
  //       totalAmount: 210000.00,
  //       subsidyAmount: 78000.00,
  //     );
  //   } catch (e) {
  //     print('Error sharing PDF: $e');
  //     // Handle error appropriately in your UI
  //   }
  // }
}
