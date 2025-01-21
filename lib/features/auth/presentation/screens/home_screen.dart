import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:three_dot/features/all_works/data/providers/all_work_provider.dart';
import 'package:three_dot/features/all_works/presentation/screens/all_works_list_screen.dart';
import '../../data/providers/auth_provider.dart';

final dateRangeProvider = StateProvider<DateTimeRange>((ref) {
  final now = DateTime.now();
  return DateTimeRange(
    start: DateTime(now.year, now.month, 1),
    end: now,
  );
});

final statusFilterProvider = StateProvider<String?>((ref) => null);

class HomeScreen extends ConsumerWidget {
  final currencyFormat = NumberFormat("#,##0.00", "en_US");
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countState = ref.watch(allWorkProvider);
    final counNotifier = ref.read(allWorkProvider.notifier);

    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    // final dateRange = ref.watch(dateRangeProvider);
    // final statusFilter = ref.watch(statusFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: Drawer(
        child: Column(
          // padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.fullName ?? ''),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  user?.fullName.substring(0, 1).toUpperCase() ?? '',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            if (user?.permissions.contains('admin') ?? false) ...[
              // ListTile(
              //   leading: Icon(Icons.admin_panel_settings),
              //   title: Text('Admin Dashboard'),
              //   onTap: () {
              //     Navigator.popAndPushNamed(context, "/admin_dashboard");
              //     // Navigate to admin dashboard
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Users'),
                onTap: () {
                  Navigator.popAndPushNamed(context, "/admin_dashboard");
                  // Navigate to admin dashboard
                },
              ),
              ListTile(
                leading: const Icon(Icons.window),
                title: const Text('Products'),
                onTap: () {
                  Navigator.popAndPushNamed(context, "/products");
                  // Navigate to admin dashboard
                },
              ),
            ],
            if (user?.permissions.contains('director') ?? false) ...[
              ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text('Director Dashboard'),
                onTap: () {
                  // Navigate to director dashboard
                },
              ),
            ],
            if (user?.permissions.contains('offsite_staff') ?? false) ...[
              ListTile(
                leading: const Icon(Icons.work),
                title: const Text('Offsite Staff Portal'),
                onTap: () {
                  // Navigate to offsite staff portal
                },
              ),
            ],
            if (user?.permissions.contains('onsite_staff') ?? false) ...[
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Onsite Staff Portal'),
                onTap: () {
                  // Navigate to onsite staff portal
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('Inquiries'),
              onTap: () {
                Navigator.pushNamed(context, '/inquires');
                // Navigate to onsite staff portal
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Projects'),
              onTap: () {
                Navigator.pushNamed(context, '/projects');
                // Navigate to onsite staff portal
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                ref.read(authStateProvider.notifier).logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filters Section
              // Card(
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           'Filters',
              //           style: Theme.of(context).textTheme.titleLarge,
              //         ),
              //         const SizedBox(height: 16),
              //         Row(
              //           children: [
              //             Expanded(
              //               child: OutlinedButton.icon(
              //                 icon: const Icon(Icons.calendar_today),
              //                 label: Text(
              //                   '${DateFormat('MMM d, y').format(dateRange.start)} - ${DateFormat('MMM d, y').format(dateRange.end)}',
              //                 ),
              //                 onPressed: () async {
              //                   final picked = await showDateRangePicker(
              //                     context: context,
              //                     firstDate: DateTime(2020),
              //                     lastDate: DateTime.now(),
              //                     initialDateRange: dateRange,
              //                   );
              //                   if (picked != null) {
              //                     ref.read(dateRangeProvider.notifier).state =
              //                         picked;
              //                   }
              //                 },
              //               ),
              //             ),
              //             const SizedBox(width: 16),
              //             Expanded(
              //               child: DropdownButtonFormField<String>(
              //                 decoration: const InputDecoration(
              //                   labelText: 'Status',
              //                   border: OutlineInputBorder(),
              //                 ),
              //                 value: statusFilter,
              //                 items: [
              //                   const DropdownMenuItem(
              //                       value: null, child: Text('All')),
              //                   const DropdownMenuItem(
              //                       value: 'pending', child: Text('Pending')),
              //                   const DropdownMenuItem(
              //                       value: 'in_progress',
              //                       child: Text('In Progress')),
              //                   const DropdownMenuItem(
              //                       value: 'completed',
              //                       child: Text('Completed')),
              //                 ],
              //                 onChanged: (value) {
              //                   ref.read(statusFilterProvider.notifier).state =
              //                       value;
              //                 },
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 24),

              // // Metrics Grid
              // GridView.count(
              //   crossAxisCount: 2,
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   crossAxisSpacing: 16,
              //   mainAxisSpacing: 20,
              //   // childAspectRatio: 1.5,

              //   children: [
              //     MetricCard(
              //       title: 'Total Revenue',
              //       value: '\₹${currencyFormat.format(24500)}',
              //       icon: Icons.attach_money,
              //       color: Colors.green,
              //     ),
              //     MetricCard(
              //       title: 'Total Expenses',
              //       value: '\₹${currencyFormat.format(18000)}',
              //       icon: Icons.shopping_cart,
              //       color: Colors.red,
              //     ),
              //     const MetricCard(
              //       title: 'Active Projects',
              //       value: '12',
              //       icon: Icons.engineering,
              //       color: Colors.blue,
              //     ),
              //     const MetricCard(
              //       title: 'Completed Projects',
              //       value: '45',
              //       icon: Icons.check_circle,
              //       color: Colors.purple,
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 24),

              // Recent Projects List
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: countState.isLoadingCounts
                      ? Center(child: CircularProgressIndicator())
                      : ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _categoryCard(context,
                                title: 'Initial Contact',
                                inquirySate: 1,
                                count:
                                    countState.counts?["initial_contact"] ?? 0),
                            _categoryCard(context,
                                title: 'Waiting for Site Assessment',
                                inquirySate: 2,
                                count:
                                    countState.counts?["site_assessment"] ?? 0),
                            _categoryCard(context,
                                title: 'Create Project Estimation',
                                inquirySate: 3,
                                count:
                                    countState.counts?["project_estimation"] ??
                                        0),
                            _categoryCard(context,
                                title: 'Order Confirmation',
                                inquirySate: 3,
                                confirmationStatus: 'accepted',
                                count:
                                    countState.counts?["order_confirmation"] ??
                                        0),
                            _categoryCard(context,
                                title: 'Quote Pending',
                                inquirySate: 3,
                                confirmationStatus: 'accepted',
                                count:
                                    countState.counts?["quote_pending"] ?? 0),
                            _categoryCard(context,
                                title: 'Quote Generation',
                                inquirySate: 4,
                                quetationSataus: "accepted",
                                count: countState.counts?["quote_generation"] ??
                                    0),
                            _categoryCard(context,
                                title: 'Inquiry Completed',
                                inquirySate: 5,
                                count:
                                    countState.counts?["inquiry_completed"] ??
                                        0),
                            _categoryCard(context,
                                title: 'Order Rejected',
                                inquirySate: 6,
                                confirmationStatus: "rejected",
                                quetationSataus: "rejected",
                                count:
                                    countState.counts?["order_rejected"] ?? 0),
                            // _categoryCard(
                            // context,
                            // title: 'Project Completed',
                            // inquirySate: 6,
                            //         count:
                            //             countState.counts?["initial_contact"] ?? 0),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _categoryCard(BuildContext context,
      {required int inquirySate,
      required String title,
      required int count,
      String? quetationSataus,
      String? confirmationStatus}) {
    return Card(
      child: ListTile(
        title: Text(title),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        trailing: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(count.toString()),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AllWorkListScreen(
                        inquirySate: inquirySate,
                        title: title,
                        quetationSataus: quetationSataus,
                        confirmationStatus: confirmationStatus,
                      )));
        },
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const MetricCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
