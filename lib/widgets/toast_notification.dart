import 'package:flutter/material.dart';

class ToastNotification extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color backgroundColor;

  const ToastNotification({
    Key? key,
    required this.message,
    this.icon,
    this.backgroundColor = const Color(0xFF323232),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12.0),
          ],
          Text(message, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}