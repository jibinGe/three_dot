import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final dateRange = ref.watch(dateRangeProvider);
    final statusFilter = ref.watch(statusFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
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
                  style: TextStyle(fontSize: 24),
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
                leading: Icon(Icons.person),
                title: Text('Users'),
                onTap: () {
                  Navigator.popAndPushNamed(context, "/admin_dashboard");
                  // Navigate to admin dashboard
                },
              ),
              ListTile(
                leading: Icon(Icons.window),
                title: Text('Products'),
                onTap: () {
                  Navigator.popAndPushNamed(context, "/products");
                  // Navigate to admin dashboard
                },
              ),
            ],
            if (user?.permissions.contains('director') ?? false) ...[
              ListTile(
                leading: Icon(Icons.trending_up),
                title: Text('Director Dashboard'),
                onTap: () {
                  // Navigate to director dashboard
                },
              ),
            ],
            if (user?.permissions.contains('offsite_staff') ?? false) ...[
              ListTile(
                leading: Icon(Icons.work),
                title: Text('Offsite Staff Portal'),
                onTap: () {
                  // Navigate to offsite staff portal
                },
              ),
            ],
            if (user?.permissions.contains('onsite_staff') ?? false) ...[
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Onsite Staff Portal'),
                onTap: () {
                  // Navigate to onsite staff portal
                },
              ),
            ],
            ListTile(
              leading: Icon(Icons.edit_note),
              title: Text('Inquiries'),
              onTap: () {
                Navigator.pushNamed(context, '/inquires');
                // Navigate to onsite staff portal
              },
            ),
            ListTile(
              leading: Icon(Icons.build),
              title: Text('Projects'),
              onTap: () {
                Navigator.pushNamed(context, '/projects');
                // Navigate to onsite staff portal
              },
            ),
            Spacer(),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filters',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: Icon(Icons.calendar_today),
                              label: Text(
                                '${DateFormat('MMM d, y').format(dateRange.start)} - ${DateFormat('MMM d, y').format(dateRange.end)}',
                              ),
                              onPressed: () async {
                                final picked = await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                  initialDateRange: dateRange,
                                );
                                if (picked != null) {
                                  ref.read(dateRangeProvider.notifier).state =
                                      picked;
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Status',
                                border: OutlineInputBorder(),
                              ),
                              value: statusFilter,
                              items: [
                                DropdownMenuItem(
                                    value: null, child: Text('All')),
                                DropdownMenuItem(
                                    value: 'pending', child: Text('Pending')),
                                DropdownMenuItem(
                                    value: 'in_progress',
                                    child: Text('In Progress')),
                                DropdownMenuItem(
                                    value: 'completed',
                                    child: Text('Completed')),
                              ],
                              onChanged: (value) {
                                ref.read(statusFilterProvider.notifier).state =
                                    value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Metrics Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 20,
                // childAspectRatio: 1.5,

                children: [
                  MetricCard(
                    title: 'Total Revenue',
                    value: '\$${currencyFormat.format(24500)}',
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                  MetricCard(
                    title: 'Total Expenses',
                    value: '\$${currencyFormat.format(18000)}',
                    icon: Icons.shopping_cart,
                    color: Colors.red,
                  ),
                  MetricCard(
                    title: 'Active Projects',
                    value: '12',
                    icon: Icons.engineering,
                    color: Colors.blue,
                  ),
                  MetricCard(
                    title: 'Completed Projects',
                    value: '45',
                    icon: Icons.check_circle,
                    color: Colors.purple,
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Recent Projects List
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Projects',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('Project ${index + 1}'),
                            subtitle: Text('Client Name ${index + 1}'),
                            trailing: Chip(
                              label: Text('In Progress'),
                              backgroundColor: Colors.blue.shade100,
                            ),
                            onTap: () {
                              // Navigate to project details
                            },
                          );
                        },
                      ),
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
            SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 4),
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
