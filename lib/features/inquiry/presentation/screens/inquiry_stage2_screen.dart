// lib/features/inquiry/presentation/screens/inquiry_stage2_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/inquiry/data/models/selected_product_model.dart';
import 'package:three_dot/features/inquiry/data/providers/inquiry_providers.dart';

class InquiryStage2Screen extends ConsumerStatefulWidget {
  final int inquiryId;

  const InquiryStage2Screen({
    Key? key,
    required this.inquiryId,
  }) : super(key: key);

  @override
  ConsumerState<InquiryStage2Screen> createState() =>
      _InquiryStage2ScreenState();
}

class _InquiryStage2ScreenState extends ConsumerState<InquiryStage2Screen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedRoofType = 'normal';
  String _selectedQuotationStatus = 'pending';
  String _selectedConfirmationStatus = 'pending';
  final _roofSpecificationController = TextEditingController();
  final _proposedAmountController = TextEditingController();
  final _proposedCapacityController = TextEditingController();

  final _confirmationRejectionController = TextEditingController();
  final _quotationRejectionController = TextEditingController();
  final _paymentTermsController = TextEditingController();
  final List<SelectedProductModel> _selectedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadInquiryData();
  }

  void _loadInquiryData() async {
    await ref.read(inquiryProvider.notifier).getInquiry(widget.inquiryId);
    final inquiry = ref.read(inquiryProvider).value;
    if (inquiry != null) {
      setState(() {
        _selectedRoofType = inquiry.roofType;
        _selectedQuotationStatus = inquiry.quotationStatus;
        _selectedConfirmationStatus = inquiry.confirmationStatus;
        _selectedQuotationStatus = inquiry.quotationStatus;
        _selectedConfirmationStatus = inquiry.confirmationStatus;
        _roofSpecificationController.text = inquiry.roofSpecification;
        _proposedAmountController.text = inquiry.proposedAmount.toString();
        _proposedCapacityController.text = inquiry.proposedCapacity.toString();
        _quotationRejectionController.text =
            inquiry.quotationRejectionReason ?? "";
        _confirmationRejectionController.text =
            inquiry.confirmationStatus ?? "";
        _paymentTermsController.text = inquiry.paymentTerms;
        _selectedProducts.addAll(inquiry.selectedProducts);
      });
    }
  }

  @override
  void dispose() {
    _roofSpecificationController.dispose();
    _proposedAmountController.dispose();
    _confirmationRejectionController.dispose();
    _quotationRejectionController.dispose();
    _paymentTermsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Technical Details'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildRoofTypeSelection(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _roofSpecificationController,
              decoration: const InputDecoration(
                labelText: 'Roof Specification',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter roof specification';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _proposedAmountController,
              decoration: const InputDecoration(
                labelText: 'Proposed Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter proposed amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _proposedCapacityController,
              decoration: const InputDecoration(
                labelText: 'Proposed Capacity (kW)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.electric_bolt),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter proposed capacity';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid capacity';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _paymentTermsController,
              decoration: const InputDecoration(
                labelText: 'Payment Terms',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payment),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter payment terms';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildQuotationStatus(),
            const SizedBox(height: 16),
            _buildConfirmationStatus(),
            const SizedBox(height: 16),
            _buildProductsList(),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Technical Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoofTypeSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Roof Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedRoofType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'normal',
                  child: Text('Normal'),
                ),
                DropdownMenuItem(
                  value: 'sheet',
                  child: Text('Sheet'),
                ),
                DropdownMenuItem(
                  value: 'other',
                  child: Text('Other'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRoofType = value;
                  });
                }
              },
            ),
          ],
        ),
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

  Widget _buildProductsList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Selected Products',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _showProductSelectionDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                ),
              ],
            ),
            if (_selectedProducts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text('No products selected'),
                ),
              ),
            ...List.generate(_selectedProducts.length, (index) {
              final product = _selectedProducts[index];
              return ListTile(
                title: Text('Product ${product.productId}'),
                subtitle: Text(
                  'Quantity: ${product.quantity} | Unit Price: \$${product.unitPrice}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _selectedProducts.removeAt(index);
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showProductSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add product selection form here
              // This is a simplified version
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Product ID',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Unit Price',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Add product to list
              setState(() {
                _selectedProducts.add(
                  SelectedProductModel(
                    productId: 1,
                    quantity: 1,
                    unitPrice: 100,
                  ),
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(inquiryProvider.notifier).updateInquiryStage2(
              inquiryId: widget.inquiryId,
              roofType: _selectedRoofType,
              quotationStatus: _selectedQuotationStatus,
              confirmationStatus: _selectedConfirmationStatus,
              roofSpecification: _roofSpecificationController.text,
              quotationRejectionReason: _quotationRejectionController.text,
              confirmationRejectionReason:
                  _confirmationRejectionController.text,
              proposedAmount: double.parse(_proposedAmountController.text),
              proposedCapacity: double.parse(_proposedCapacityController.text),
              paymentTerms: _paymentTermsController.text,
              selectedProducts: _selectedProducts,
            );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Technical details saved successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }
}
