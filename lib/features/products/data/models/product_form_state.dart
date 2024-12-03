// Form state class
import 'package:flutter/material.dart';
import 'package:three_dot/features/products/data/models/product_model.dart';

class ProductFormState {
  final Product? initialProduct;
  final Map<String, dynamic> specifications;
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final String? errorMessage;

  ProductFormState({
    this.initialProduct,
    Map<String, dynamic>? specifications,
    GlobalKey<FormState>? formKey,
    this.isLoading = false,
    this.errorMessage,
  })  : specifications = specifications ?? initialProduct?.specifications ?? {},
        formKey = formKey ?? GlobalKey<FormState>();
}
