import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/providers/inquiry_providers.dart';

class QuotationRejectionForm extends ConsumerStatefulWidget {
  final InquiryModel inquiry;
  const QuotationRejectionForm({
    Key? key,
    required this.inquiry,
  }) : super(key: key);

  @override
  ConsumerState<QuotationRejectionForm> createState() =>
      _QuotationRejectionFormState();
}

class _QuotationRejectionFormState
    extends ConsumerState<QuotationRejectionForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _quotationRejectionController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadInquiryData();
  }

  void _initializeControllers() {
    _quotationRejectionController = TextEditingController();
  }

  void _loadInquiryData() {
    setState(() {
      _quotationRejectionController.text =
          widget.inquiry.quotationRejectionReason ?? "";
    });
  }

  @override
  void dispose() {
    _quotationRejectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inquiryProvider = ref.watch(inquiryNotifierProvider);
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 15),
          const Center(
            child: Text(
              "Reject Quotation",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
          _buildQuotationStatus(),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _submitForm,
              child: inquiryProvider.isLoading
                  ? LoadingAnimationWidget.threeRotatingDots(
                      color: AppColors.surface, size: 20)
                  : const Text('Save Quotation Rejection'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _quotationRejectionController,
              decoration: const InputDecoration(
                labelText: 'Quotation Rejection Reason',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes_rounded),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if ((value == null || value.isEmpty)) {
                  return 'Please enter rejection Reason';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref
            .read(inquiryNotifierProvider.notifier)
            .updateQuotationRejection(
              inquiryId: widget.inquiry.id,
              quotationStatus: "rejected",
              quotationRejectionReason: _quotationRejectionController.text,
            );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Quotation status saved successfully')),
          );
        }
      } catch (e) {
        _showErrorSnackBar('Error saving Quotation details: ${e.toString()}');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
