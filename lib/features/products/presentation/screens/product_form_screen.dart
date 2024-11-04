// lib/features/products/presentation/screens/product_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/products/data/models/product_form_state.dart';
import 'package:three_dot/features/products/data/models/product_model.dart';
import 'package:three_dot/features/products/data/providers/product_form_provider.dart';
import 'package:three_dot/features/products/data/providers/product_provider.dart';

// Product Form Screen
class ProductFormScreen extends ConsumerStatefulWidget {
  final Product? product;

  const ProductFormScreen({
    Key? key,
    this.product,
  }) : super(key: key);

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  late List<TextEditingController> _controllers;
  final List<String> _categories = [
    'solar_panel',
    'inverter',
    'wiring',
    'ac_db',
    'dc_db'
  ];

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    final nameController = ref.read(nameControllerProvider);
    final manufacturerController = ref.read(manufacturerControllerProvider);
    final modelController = ref.read(modelControllerProvider);
    final descriptionController = ref.read(descriptionControllerProvider);
    final unitPriceController = ref.read(unitPriceControllerProvider);
    final unitTypeController = ref.read(unitTypeControllerProvider);
    final stockController = ref.read(stockControllerProvider);
    final categoryController = ref.read(categoryControllerProvider);

    _controllers = [
      nameController,
      manufacturerController,
      modelController,
      descriptionController,
      unitPriceController,
      unitTypeController,
      stockController,
      categoryController,
    ];

    // Populate controllers if editing an existing product
    if (widget.product != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Set initial product in the form provider
        ref
            .read(productFormProvider.notifier)
            .setInitialProduct(widget.product!);

        // Populate text controllers
        nameController.text = widget.product?.name ?? "";
        manufacturerController.text = widget.product?.manufacturer ?? "";
        modelController.text = widget.product?.model ?? "";
        descriptionController.text = widget.product?.description ?? "";
        unitPriceController.text = widget.product?.unitPrice?.toString() ?? "0";
        unitTypeController.text = widget.product?.unitType ?? "";
        stockController.text = widget.product?.stock?.toString() ?? "";
        categoryController.text = widget.product?.category ?? "";
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Set initial product in the form provider
        ref.read(productFormProvider.notifier).removeInitialProduct();

        // Populate text controllers
        nameController.clear();
        manufacturerController.clear();
        modelController.clear();
        descriptionController.clear();
        unitPriceController.clear();
        unitTypeController.clear();
        stockController.clear();
        categoryController.clear();
      });
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    // for (var controller in _controllers) {
    //   controller.dispose();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(productFormProvider);
    final isEditing = formState.initialProduct != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: Form(
        key: formState.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basic Product Information
            _buildTextFormField(
              controller: ref.read(nameControllerProvider),
              label: 'Product Name',
              validator: (value) => value == null || value.isEmpty
                  ? 'Product name is required'
                  : null,
            ),
            _buildTextFormField(
              controller: ref.read(manufacturerControllerProvider),
              label: 'Manufacturer',
              validator: (value) => value == null || value.isEmpty
                  ? 'Manufacturer is required'
                  : null,
            ),
            _buildTextFormField(
              controller: ref.read(modelControllerProvider),
              label: 'Model',
              validator: (value) =>
                  value == null || value.isEmpty ? 'Model is required' : null,
            ),
            // Dropdown for Category
            DropdownButtonFormField<String>(
              value: ref.read(categoryControllerProvider).text.isEmpty
                  ? null
                  : ref.read(categoryControllerProvider).text,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.replaceAll('_', ' ').toUpperCase()),
                );
              }).toList(),
              validator: (value) =>
                  value == null ? 'Please select a category' : null,
              onChanged: (value) {
                ref.read(categoryControllerProvider).text = value!;
              },
            ),
            _buildTextFormField(
              controller: ref.read(descriptionControllerProvider),
              label: 'Description',
              maxLines: 3,
              validator: (value) => value == null || value.isEmpty
                  ? 'Description is required'
                  : null,
            ),
            // Numeric Fields
            _buildTextFormField(
              controller: ref.read(unitPriceControllerProvider),
              label: 'Unit Price',
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
            _buildTextFormField(
              controller: ref.read(unitTypeControllerProvider),
              label: 'Unit Type (e.g., piece, kg)',
              validator: (value) => value == null || value.isEmpty
                  ? 'Unit type is required'
                  : null,
            ),
            _buildTextFormField(
              controller: ref.read(stockControllerProvider),
              label: 'Stock Quantity',
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

            // Specifications Section
            const SizedBox(height: 16),
            const Text(
              'Specifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...formState.specifications.entries
                .map((entry) => _buildSpecificationTile(
                      context,
                      ref,
                      entry.key,
                      entry.value,
                    )),
            ElevatedButton.icon(
              onPressed: () => _showAddSpecificationDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Specification'),
            ),

            // Submit Button
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: formState.isLoading
                  ? null
                  : () async {
                      final success = await ref
                          .read(productFormProvider.notifier)
                          .submitForm(context, ref);

                      if (success && context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
              child: formState.isLoading
                  ? const CircularProgressIndicator()
                  : Text(isEditing ? 'Update Product' : 'Add Product'),
            ),

            // Error Message
            if (formState.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  formState.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
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
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  Widget _buildSpecificationTile(
    BuildContext context,
    WidgetRef ref,
    String key,
    dynamic value,
  ) {
    return ListTile(
      title: Text(key),
      subtitle: Text(value.toString()),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          ref.read(productFormProvider.notifier).removeSpecification(key);
        },
      ),
    );
  }

  Future<void> _showAddSpecificationDialog(
      BuildContext context, WidgetRef ref) async {
    final keyController = TextEditingController();
    final valueController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Specification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: 'Specification Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Specification Value',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              if (keyController.text.isNotEmpty &&
                  valueController.text.isNotEmpty) {
                ref.read(productFormProvider.notifier).addSpecification(
                      keyController.text,
                      valueController.text,
                    );
                Navigator.of(context).pop();
              }
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }
}

// Update the ProductListItem to include edit functionality
// extension on ProductListItem {
//   void showEditProductForm(BuildContext context, WidgetRef ref) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => ProductFormScreen(product: product),
//       ),
//     );
//   }
// }

// Update the