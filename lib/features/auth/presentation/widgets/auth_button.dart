import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String label;

  const AuthButton({
    Key? key,
    required this.onPressed,
    required this.isLoading,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? LoadingAnimationWidget.threeArchedCircle(
              color: Colors.white,
              size: 24,
            )
          : Text(label),
    );
  }
}
