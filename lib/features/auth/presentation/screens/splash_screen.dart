// lib/features/splash/presentation/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../features/auth/data/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize authentication state
    await ref.read(authStateProvider.notifier).validateAuthAndGetUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your app logo or splash screen content here
            // Image.asset(
            //   'assets/logo.png', // Replace with your logo asset
            //   width: 150,
            //   height: 150,
            // ),
            Icon(
              Icons.sunny,
              color: Colors.orange[800],
              size: 150,
            ),
            const SizedBox(height: 20),
            LoadingAnimationWidget.horizontalRotatingDots(
              color: Colors.orange[800]!,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
