import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/providers/inquiry_providers.dart';

class QuotationForm extends ConsumerStatefulWidget {
  final InquiryModel inquiry;
  const QuotationForm({
    Key? key,
    required this.inquiry,
  }) : super(key: key);

  @override
  ConsumerState<QuotationForm> createState() => _QuotationFormState();
}

class _QuotationFormState extends ConsumerState<QuotationForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _confirmationRejectionController;
  late final TextEditingController _quotationRejectionController;
  String _selectedQuotationStatus = 'pending';
  String _selectedConfirmationStatus = 'pending';
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadInquiryData();
  }

  void _initializeControllers() {
    _confirmationRejectionController = TextEditingController();
    _quotationRejectionController = TextEditingController();
  }

  void _loadInquiryData() {
    setState(() {
      _selectedQuotationStatus = widget.inquiry.quotationStatus ?? 'pending';
      _selectedConfirmationStatus =
          widget.inquiry.confirmationStatus ?? 'pending';

      _quotationRejectionController.text =
          widget.inquiry.quotationRejectionReason ?? "";
      _confirmationRejectionController.text =
          widget.inquiry.confirmationRejectionReason ?? "";
    });
  }

  @override
  void dispose() {
    _quotationRejectionController.dispose();
    _confirmationRejectionController.dispose();
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
              "Quotation Status",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
          _buildQuotationStatus(),
          const SizedBox(height: 16),
          _buildConfirmationStatus(),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _submitForm,
              child: inquiryProvider.isLoading
                  ? LoadingAnimationWidget.threeRotatingDots(
                      color: AppColors.surface, size: 20)
                  : const Text('Save Quotation Details'),
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
            const Text(
              'Quotation Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedQuotationStatus,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'pending',
                  child: Text('Pending'),
                ),
                DropdownMenuItem(
                  value: 'accepted',
                  child: Text('Accepted'),
                ),
                DropdownMenuItem(
                  value: 'rejected',
                  child: Text('Rejected'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedQuotationStatus = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            if (_selectedQuotationStatus == "rejected")
              TextFormField(
                controller: _quotationRejectionController,
                decoration: const InputDecoration(
                  labelText: 'Quotation Rejection Reason',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (_selectedQuotationStatus == 'rejected' &&
                      (value == null || value.isEmpty)) {
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

  Widget _buildConfirmationStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confirmation Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedConfirmationStatus,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'pending',
                  child: Text('Pending'),
                ),
                DropdownMenuItem(
                  value: 'accepted',
                  child: Text('Accepted'),
                ),
                DropdownMenuItem(
                  value: 'rejected',
                  child: Text('Rejected'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedConfirmationStatus = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            if (_selectedConfirmationStatus == "rejected")
              TextFormField(
                controller: _confirmationRejectionController,
                decoration: const InputDecoration(
                  labelText: 'Confirmation Rejection Reason',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (_selectedConfirmationStatus == "rejected" &&
                      (value == null || value.isEmpty)) {
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
        await ref.read(inquiryNotifierProvider.notifier).updateQuotationStatus(
              inquiryId: widget.inquiry.id,
              quotationStatus: _selectedQuotationStatus,
              confirmationStatus: _selectedConfirmationStatus,
              quotationRejectionReason: _quotationRejectionController.text,
              confirmationRejectionReason:
                  _confirmationRejectionController.text,
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
