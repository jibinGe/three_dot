import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:three_dot/features/products/data/models/product_category_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  final ProductCategory category;
  final void Function() onTap;
  final void Function() onDelete;
  final void Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              category.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${category.description} - ${category.code}'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: onTap,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Icon(Icons.edit),
                  onTap: () => onEdit(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Icon(Icons.delete),
                  onTap: () => onDelete(),
                ),
              ),
              // IconButton.outlined(
              //   onPressed: onEdit,
              //   icon: Icon(Icons.edit),
              // ),
              // IconButton.outlined(
              //   onPressed: onDelete,
              //   icon: Icon(Icons.delete),
              // )
            ],
          )
        ],
      ),
    );
  }
}

class SwipeableCategoryCard extends StatefulWidget {
  final ProductCategory category;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SwipeableCategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  State<SwipeableCategoryCard> createState() => _SwipeableCategoryCardState();
}

class _SwipeableCategoryCardState extends State<SwipeableCategoryCard> {
  bool _showActions = false;

  void _toggleActions() {
    setState(() {
      _showActions = !_showActions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < -50) {
          // Swipe left
          setState(() => _showActions = true);
        } else if (details.primaryVelocity! > 50) {
          // Swipe right
          setState(() => _showActions = false);
        }
      },
      onTap: widget.onTap,
      child: Stack(
        children: [
          // Background with buttons
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: widget.onEdit,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label:
                      const Text("Edit", style: TextStyle(color: Colors.blue)),
                ),
                TextButton.icon(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label:
                      const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
          // Foreground with ListTile
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _showActions ? -100 : 0,
            right: _showActions ? 100 : 0,
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                title: Text(
                  widget.category.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    '${widget.category.description} - ${widget.category.code}'),
                onTap: _toggleActions,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
