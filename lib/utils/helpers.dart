import 'package:flutter/material.dart';
import 'package:liteline/widgets/toast_notification.dart';
import 'package:liteline/widgets/costum_alert_dialog.dart';

// Show toast helper function
void showToast(
  BuildContext context,
  String message, {
  IconData? icon,
  Color? backgroundColor,
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 50.0,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: ToastNotification(
            message: message,
            icon: icon,
            backgroundColor: backgroundColor ?? const Color(0xFF323232),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

// Custom Alert Dialog helper function
Future<void> showCustomAlert(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'OK',
  String? cancelText,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  Color? confirmColor,
  IconData? icon,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CustomAlertDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor,
        icon: icon,
      );
    },
  );
}