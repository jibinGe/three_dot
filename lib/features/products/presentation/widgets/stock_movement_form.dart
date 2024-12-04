import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/products/data/models/product_model.dart';
import 'package:three_dot/features/products/data/models/stock_movement_model.dart';
import 'package:three_dot/features/products/data/providers/stock_movement_provider.dart';

class StockMovementForm extends ConsumerStatefulWidget {
  final StockMovementModel? stockMovement;
  final Product product;
  const StockMovementForm(
    this.product, {
    super.key,
    this.stockMovement,
  });

  @override
  ConsumerState<StockMovementForm> createState() => _StockMovementFormState();
}

class _StockMovementFormState extends ConsumerState<StockMovementForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _quantityController;
  late final TextEditingController _unitPriceController;
  late final TextEditingController _referenceController;
  late final TextEditingController _remarksController;
  String _movementType = "in";

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
        text: widget.stockMovement?.quantity.toString() ?? '');
    _unitPriceController = TextEditingController(
        text: widget.stockMovement?.unitPrice.toString() ?? '');
    _referenceController = TextEditingController(
        text: widget.stockMovement?.referenceNumber.toString() ?? '');
    _remarksController = TextEditingController(
        text: widget.stockMovement?.remarks.toString() ?? '');
    _movementType = widget.stockMovement?.movementType ?? "in";
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _unitPriceController.dispose();
    _referenceController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    print("taped");
    if (!_formKey.currentState!.validate()) return;
    print("validate");

    setState(() => _isSubmitting = true);

    try {
      final notifier = ref.read(stockMovementNotifierProvider.notifier);
      final isSuccess = widget.stockMovement == null
          ? await notifier.createStockMovement(
              quantity: double.parse(_quantityController.text),
              movementType: _movementType,
              productId: widget.product.id!,
              reference: _referenceController.text,
              remarks: _referenceController.text,
              unitPrice: double.parse(_unitPriceController.text))
          : await notifier.updateStockMovement(
              movementId: widget.stockMovement!.id,
              quantity: double.parse(_quantityController.text),
              productId: widget.product.id!,
              reference: _referenceController.text,
              remarks: _referenceController.text,
              unitPrice: double.parse(_unitPriceController.text));

      if (isSuccess && mounted) {
        Navigator.pop(context);
        _showSuccessMessage();
      }
    } catch (e) {
      print(e.toString());
      _showErrorMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.stockMovement == null
              ? 'Stock movement added successfully'
              : 'Stock movement updated successfully',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error saving Stock movement: $message'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      enableDrag: true,
      builder: (context) => Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(25.0),
          // shrinkWrap: true,
          children: [
            _buildTextFormField(
              controller: _quantityController,
              label: 'Quantity',
              icon: Icons.numbers,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Stock quantity is required';
                }
                if (int.tryParse(value) == null) {
                  return 'Invalid stock quantity';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _unitPriceController,
              label: 'Unit Price',
              icon: Icons.money,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Unit price is required';
                }
                if (double.tryParse(value) == null) {
                  return 'Invalid price format';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _referenceController,
              label: 'Reference',
              icon: Icons.category,
              // maxLines: 3,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter reference';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _remarksController,
              label: 'Remarks',
              icon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _movementType,
              decoration: const InputDecoration(
                labelText: "Movement",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.swap_horiz),
              ),
              items: const [
                DropdownMenuItem(
                  value: "in",
                  child: Text("In"),
                ),
                DropdownMenuItem(
                  value: "out",
                  child: Text("Out"),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _movementType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitForm,
        child: _isSubmitting
            ? LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.textPrimary,
                size: 24,
              )
            : Text(widget.stockMovement == null ? 'Save' : 'Update'),
      ),
    );
  }
}
