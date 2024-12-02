import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:three_dot/core/theme/app_colors.dart';
import 'package:three_dot/features/inquiry/data/models/inquiry_model.dart';
import 'package:three_dot/features/inquiry/data/providers/inquiry_providers.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_detail_screen.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_form_screen.dart';

class InquiryListScreen extends ConsumerStatefulWidget {
  const InquiryListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<InquiryListScreen> createState() => _InquiryListScreenState();
}

class _InquiryListScreenState extends ConsumerState<InquiryListScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _screens = [
    {'title': 'Inquiry', 'stage': '1'},
    {'title': 'Detailed Inquiry', 'stage': '2'},
    {'title': 'Costing', 'stage': '3'},
    {'title': 'Quotation', 'stage': '4'},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(inquiryNotifierProvider.notifier).getAllInquiries(stage: '1');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    ref.read(inquiryNotifierProvider.notifier).getAllInquiries(
          stage: _screens[index]['stage'],
        );
  }

  @override
  Widget build(BuildContext context) {
    final inquiryState = ref.watch(inquiryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selectedIndex]['title']),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(inquiryNotifierProvider.notifier)
                .getAllInquiries(stage: _screens[_selectedIndex]['stage']),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (inquiryState.isLoading) {
            return Center(
                child: LoadingAnimationWidget.threeArchedCircle(
              color: AppColors.textPrimary,
              size: 24,
            ));
          }

          // if (inquiryState.error != null) {
          //   return Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Spacer(),
          //         Text('Error: ${inquiryState.error}'),
          //         Spacer(),
          //         ElevatedButton(
          //           onPressed: () => ref
          //               .read(inquiryNotifierProvider.notifier)
          //               .getAllInquiries(
          //                   stage: _screens[_selectedIndex]['stage']),
          //           child: const Text('Retry'),
          //         ),
          //         SizedBox(
          //           height: 100,
          //         )
          //       ],
          //     ),
          //   );
          // }

          if (inquiryState.inquiries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No ${_screens[_selectedIndex]['title']} found'),
                  const SizedBox(height: 16),
                  if (_selectedIndex == 0)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InquiryFormScreen(),
                          ),
                        );
                      },
                      child: const Text('Create New Inquiry'),
                    ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: inquiryState.inquiries.length,
            itemBuilder: (context, index) =>
                _buildInquiryCard(context, inquiryState.inquiries[index]),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Inquiry',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Detailed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Costing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Quotation',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InquiryFormScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildInquiryCard(BuildContext context, InquiryModel inquiry) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          inquiry.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (inquiry.consumerNumber != null && inquiry.consumerNumber != "")
              Text('Consumer Number: ${inquiry.consumerNumber}'),
            Text('Mobile: ${inquiry.mobileNumber}'),
            if (inquiry.proposedAmount != null)
              Text(
                'Proposed Amount: ₹${inquiry.proposedAmount?.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green),
              ),
            if (inquiry.proposedCapacity != null)
              Text(
                'Capacity: ${inquiry.proposedCapacity?.toStringAsFixed(2)} kW',
                style: const TextStyle(color: Colors.blue),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InquiryDetailScreen(inquiryId: inquiry.id),
            ),
          );
        },
      ),
    );
  }
}
