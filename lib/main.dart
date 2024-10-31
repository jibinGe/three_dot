import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/inquiry/presentation/admin_dashboard.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_form_screen.dart';
import 'package:three_dot/features/products/presentation/screens/procducts_screen.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/home_screen.dart';
import 'features/auth/data/providers/auth_provider.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // // Show a loading indicator while checking authentication
    // if (authState.isLoading) {
    //   return MaterialApp(
    //     home: Scaffold(
    //       body: Center(
    //         child: CircularProgressIndicator(),
    //       ),
    //     ),
    //   );
    // }

    return MaterialApp(
      title: 'Auth App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: authState.isAuthenticated ? HomeScreen() : LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/home': (context) => HomeScreen(),
        '/inquiry-form': (context) => InquiryFormScreen(),
        '/admin_dashboard': (context) => AdminDashboard(),
        '/products': (context) => const ProductsScreen(),
      },
    );
  }
}
