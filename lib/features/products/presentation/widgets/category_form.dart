import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/products/data/models/product_category_model.dart';
import 'package:three_dot/features/products/data/providers/category_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/products/data/models/product_category_model.dart';
import 'package:three_dot/features/products/data/providers/category_provider.dart';

class CategoryForm extends ConsumerStatefulWidget {
  final ProductCategory? category;

  const CategoryForm({
    super.key,
    this.category,
  });

  @override
  ConsumerState<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends ConsumerState<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _descriptionController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _codeController = TextEditingController(text: widget.category?.code ?? '');
    _descriptionController =
        TextEditingController(text: widget.category?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final notifier = ref.read(categoriesSateProvider.notifier);
      final isSuccess = widget.category == null
          ? await notifier.createCategory(
              name: _nameController.text,
              code: _codeController.text,
              description: _descriptionController.text,
              ref: ref,
            )
          : await notifier.updateCategory(
              id: widget.category!.id!,
              name: _nameController.text,
              code: _codeController.text,
              description: _descriptionController.text,
              ref: ref,
            );

      if (isSuccess && mounted) {
        Navigator.pop(context);
        _showSuccessMessage();
      }
    } catch (e) {
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
          widget.category == null
              ? 'Category added successfully'
              : 'Category updated successfully',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error saving category: $message'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(25.0),
          shrinkWrap: true,
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Name',
              icon: Icons.category,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _codeController,
              label: 'Code',
              icon: Icons.code,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a code';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              icon: Icons.description,
              maxLines: 3,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      maxLines: maxLines,
      validator: validator,
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
            : Text(widget.category == null ? 'Save' : 'Update'),
      ),
    );
  }
}
