import 'package:flutter/material.dart';

enum SnackbarType { sucess, error, info }

class CustomSnackbar extends StatelessWidget {
  const CustomSnackbar({
    super.key,
    required this.message,
    required this.type,
  });
  final String message;
  final SnackbarType type;

  static void showSnackbar({
    required BuildContext context,
    required String message,
    required SnackbarType type,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomSnackbar(message: message, type: type),
        duration: const Duration(seconds: 3),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        dismissDirection: DismissDirection.down,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.black.withAlpha(150);
    switch (type) {
      case SnackbarType.sucess:
        bgColor = Colors.green.withAlpha(150);
      case SnackbarType.error:
        bgColor = Colors.red.withAlpha(150);
      case SnackbarType.info:
        bgColor = Colors.black.withAlpha(150);
    }
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
