import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
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
              title: Text('Inquiry Form'),
              onTap: () {
                Navigator.pushNamed(context, '/inquires');
                // Navigate to onsite staff portal
              },
            ),
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
      body: Center(
        child: Text('Welcome ${user?.fullName}!'),
      ),
    );
  }
}
