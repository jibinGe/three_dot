// Provider for managing form state
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/products/data/models/product_form_state.dart';
import 'package:three_dot/features/products/data/models/product_model.dart';
import 'package:three_dot/features/products/data/providers/product_provider.dart';

final productFormProvider =
    StateNotifierProvider<ProductFormNotifier, ProductFormState>((ref) {
  return ProductFormNotifier();
});

// State notifier for form management
class ProductFormNotifier extends StateNotifier<ProductFormState> {
  ProductFormNotifier() : super(ProductFormState());

  void setInitialProduct(Product product) {
    state = ProductFormState(
      initialProduct: product,
      specifications: Map.from(product.specifications),
    );
  }

  void removeInitialProduct() {
    state = ProductFormState(
      initialProduct: null,
      specifications: null,
    );
  }

  void addSpecification(String key, dynamic value) {
    final updatedSpecs = Map<String, dynamic>.from(state.specifications);
    updatedSpecs[key] = value;
    state = ProductFormState(
      initialProduct: state.initialProduct,
      specifications: updatedSpecs,
      formKey: state.formKey,
    );
  }

  void removeSpecification(String key) {
    final updatedSpecs = Map<String, dynamic>.from(state.specifications);
    updatedSpecs.remove(key);
    state = ProductFormState(
      initialProduct: state.initialProduct,
      specifications: updatedSpecs,
      formKey: state.formKey,
    );
  }

  Future<bool> submitForm(BuildContext context, WidgetRef ref) async {
    if (!state.formKey.currentState!.validate()) {
      return false;
    }

    state.formKey.currentState!.save();

    // Collect form data
    final nameController = ref.read(nameControllerProvider);
    final manufacturerController = ref.read(manufacturerControllerProvider);
    final modelController = ref.read(modelControllerProvider);
    final descriptionController = ref.read(descriptionControllerProvider);
    final unitPriceController = ref.read(unitPriceControllerProvider);
    final unitTypeController = ref.read(unitTypeControllerProvider);
    final stockController = ref.read(stockControllerProvider);
    final categoryController = ref.read(categoryControllerProvider);

    try {
      state = ProductFormState(
        initialProduct: state.initialProduct,
        specifications: state.specifications,
        formKey: state.formKey,
        isLoading: true,
      );

      final product = Product(
        id: state.initialProduct?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: nameController.text,
        manufacturer: manufacturerController.text,
        model: modelController.text,
        description: descriptionController.text,
        unitPrice: double.parse(unitPriceController.text),
        unitType: unitTypeController.text,
        stock: int.parse(stockController.text),
        category: categoryController.text,
        specifications: state.specifications,
      );

      final repository = ref.read(productRepositoryProvider);

      // Determine if we're adding or updating
      if (state.initialProduct == null) {
        await repository.addProduct(product);
      } else {
        // Update existing product
        await repository.updateProduct(product);
      }

      // Refresh the products list
      ref.refresh(productsProvider);

      return true;
    } catch (e) {
      state = ProductFormState(
        initialProduct: state.initialProduct,
        specifications: state.specifications,
        formKey: state.formKey,
        errorMessage: e.toString(),
      );
      return false;
    } finally {
      state = ProductFormState(
        initialProduct: state.initialProduct,
        specifications: state.specifications,
        formKey: state.formKey,
        isLoading: false,
      );
    }
  }
}

// Text controllers providers
final nameControllerProvider = Provider((_) => TextEditingController());
final manufacturerControllerProvider = Provider((_) => TextEditingController());
final modelControllerProvider = Provider((_) => TextEditingController());
final descriptionControllerProvider = Provider((_) => TextEditingController());
final unitPriceControllerProvider = Provider((_) => TextEditingController());
final unitTypeControllerProvider = Provider((_) => TextEditingController());
final stockControllerProvider = Provider((_) => TextEditingController());
final categoryControllerProvider = Provider((_) => TextEditingController());
