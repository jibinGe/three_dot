import 'package:flutter/material.dart';

class ProductCategoriesNavigationBar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const ProductCategoriesNavigationBar({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCategoryIndex(selectedCategory),
      onTap: (index) => onCategorySelected(_getCategoryFromIndex(index)),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.solar_power_rounded),
          label: 'Solar Panel',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.electrical_services_rounded),
          label: 'Inverter',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cable_rounded),
          label: 'Wiring',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.ac_unit_rounded),
          label: 'AC DB',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.battery_charging_full_rounded),
          label: 'BC DB',
        ),
      ],
    );
  }

  int _getCategoryIndex(String category) {
    switch (category) {
      case 'solar_panel':
        return 0;
      case 'inverter':
        return 1;
      case 'wiring':
        return 2;
      case 'ac_db':
        return 3;
      case 'dc_db':
        return 4;
      default:
        return 0;
    }
  }

  String _getCategoryFromIndex(int index) {
    switch (index) {
      case 0:
        return 'solar_panel';
      case 1:
        return 'inverter';
      case 2:
        return 'wiring';
      case 3:
        return 'ac_db';
      case 4:
        return 'dc_db';
      default:
        return 'solar_panel';
    }
  }
}
