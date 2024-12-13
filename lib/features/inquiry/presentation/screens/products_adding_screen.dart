import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/models/selected_product_model.dart';
import 'package:three_dot/features/inquiry/data/providers/inquiry_providers.dart';
import 'package:three_dot/features/products/data/models/product_category_model.dart';
import 'package:three_dot/features/products/data/models/product_model.dart';
import 'package:three_dot/features/products/data/providers/category_provider.dart';
import 'package:three_dot/features/products/data/providers/product_provider.dart';

class ProductsAddingScreenScreen extends ConsumerStatefulWidget {
  final int inquiryId;

  const ProductsAddingScreenScreen({
    Key? key,
    required this.inquiryId,
  }) : super(key: key);

  @override
  ConsumerState<ProductsAddingScreenScreen> createState() =>
      _ProductsAddingScreenScreenState();
}

class _ProductsAddingScreenScreenState
    extends ConsumerState<ProductsAddingScreenScreen> {
  final List<SelectedProductModel> _selectedProducts = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    Future.microtask(() {
      ref.read(categoriesSateProvider.notifier).getAllCategories();
    });

    // await ref.read(categoriesSateProvider.notifier).getAllCategories();
    _loadInquiryData();
  }

  void _loadInquiryData() async {
    try {
      final inquiry = ref.read(inquiryNotifierProvider).inquiry;
      if (inquiry != null) {
        _updateStateFromInquiry(inquiry);
      }
    } catch (e) {
      _showErrorSnackBar('Error loading inquiry data');
    }
  }

  void _updateStateFromInquiry(InquiryModel inquiry) {
    setState(() {
      _selectedProducts
          .addAll(inquiry.selectedProducts ?? <SelectedProductModel>[]);
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoriesSateProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Products'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade300,
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(categoriesState.categories, selectedCategory),
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => _buildErrorState(),
              data: (products) => products.isEmpty
                  ? _buildEmptyState()
                  : _buildProductContent(products),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeader(List<ProductCategory> categories, int selectedCategory) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Category',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: InputBorder.none,
              ),
              value: selectedCategory == 0 && categories.isNotEmpty
                  ? categories.first.id
                  : selectedCategory,
              items: categories.map((category) {
                Future.microtask(() {
                  ref.read(selectedCategoryProvider.notifier).state =
                      selectedCategory == 0 && categories.isNotEmpty
                          ? categories.first.id!
                          : selectedCategory;
                });

                return DropdownMenuItem(
                  value: category.id,
                  child: Text(
                    category.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(selectedCategoryProvider.notifier).state = value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductContent(List<Product> products) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: _buildSelectedProductsSection(),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildProductCard(products[index]),
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedProductsSection() {
    if (_selectedProducts.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected Products',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(_selectedProducts.length, (index) {
            final product = _selectedProducts[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.product?.name ?? "Product ${product.id}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Qty: ${product.quantity} × \₹ ${product.unitPrice}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _selectedProducts.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showProductSelectionDialog([product]),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.inventory_2_outlined, size: 48),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '\₹ ${product.unitPrice}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No products found in this category',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          const Text(
            'Failed to load products',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    if (_selectedProducts.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Save ${_selectedProducts.length} Products',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  // Modified product selection dialog
  void _showProductSelectionDialog(List<Product> products) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ProductSelectionDialog(
          products: products,
          onAdd: (p0) {
            if (p0 != null) {
              setState(() {
                _selectedProducts.add(p0);
              });
              Navigator.pop(context);
            }
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _submitForm() async {
    try {
      await ref.read(inquiryNotifierProvider.notifier).addProducts(
            inquiryId: widget.inquiryId,
            selectedProducts: _selectedProducts,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Products added successfully')),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Error saving products: ${e.toString()}');
    }
  }
}

class ProductSelectionDialog extends StatefulWidget {
  final List<Product> products;
  final void Function(SelectedProductModel?) onAdd;
  final void Function() onCancel;
  const ProductSelectionDialog(
      {super.key,
      required this.products,
      required this.onAdd,
      required this.onCancel});

  @override
  State<ProductSelectionDialog> createState() => _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<ProductSelectionDialog> {
  Product? _selectedProduct;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedProduct = widget.products[0];
    });
  }

  final TextEditingController quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Product',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onCancel,
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Product>(
              value: _selectedProduct,
              decoration: InputDecoration(
                labelText: 'Select Product',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: List.generate(
                widget.products.length,
                (index) => DropdownMenuItem(
                  value: widget.products[index],
                  child: Text(
                    widget.products[index].name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedProduct = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: const Icon(Icons.numbers),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the quantity';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              controller: quantityController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  widget.onAdd(_selectedProduct != null
                      ? SelectedProductModel(
                          productId: _selectedProduct!.id ?? 0,
                          quantity: double.parse(quantityController.text),
                          unitPrice: _selectedProduct!.unitPrice,
                          name: _selectedProduct!.name)
                      : null);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
