import 'package:flutter/material.dart';
import 'package:three_dot/features/inquiry/data/models/selected_product_model.dart';

class ProductTable extends StatelessWidget {
  final List<SelectedProductModel> products;

  ProductTable({required this.products});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return Scrollbar(
      controller: scrollController,
      interactive: true,
      thickness: 5,
      radius: Radius.circular(5),
      trackVisibility: true,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DataTable(
            border: TableBorder.all(
                width: 1, borderRadius: BorderRadius.circular(8)),
            columnSpacing: 15,
            horizontalMargin: 15,
            columns: const [
              DataColumn(label: Text('no')),
              DataColumn(label: Text('Product Name')),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Quantity')),
            ],
            rows: List.generate(products.length, (index) {
              final product = products[index];
              return DataRow(cells: [
                DataCell(
                  SizedBox(
                    child: Center(child: Text((index + 1).toString())),
                  ),
                ),
                DataCell(
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: Text(
                      product.name ?? product.product?.name ?? 'N/A',
                      // overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
                DataCell(
                  FittedBox(
                    child: Text('${product.unitPrice.toStringAsFixed(0)}'),
                  ),
                ),
                DataCell(
                  FittedBox(
                    child: Text.rich(
                      TextSpan(
                        text:
                            '${product.quantity.toStringAsFixed(0)} ', // Main text

                        children: [
                          TextSpan(
                            text:
                                '(${product.product?.unitType ?? ""})', // Smaller text
                            style: TextStyle(
                                fontSize: 9), // Smaller size for unitType
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]);
            }),
          ),
        ),
      ),
    );
  }
}
