import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/auth/presentation/screens/splash_screen.dart';
import 'package:three_dot/features/inquiry/presentation/admin_dashboard.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_form_screen.dart';
import 'package:three_dot/features/inquiry/presentation/screens/inquiry_list_screen.dart';
import 'package:three_dot/features/products/presentation/screens/procducts_screen.dart';
import 'package:three_dot/shared/services/location_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/home_screen.dart';
import 'features/auth/data/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    LocationService.checkLocationPermission();
    return MaterialApp(
      title: 'Auth App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: authState.isInitialized
          ? (authState.isAuthenticated ? HomeScreen() : LoginScreen())
          : const SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/home': (context) => HomeScreen(),
        '/inquiry-form': (context) => InquiryFormScreen(),
        '/admin_dashboard': (context) => AdminDashboard(),
        '/products': (context) => const ProductsScreen(),
        '/inquires': (context) => const InquiryListScreen(),
      },
    );
  }
}
