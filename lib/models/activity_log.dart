import 'package:flutter/foundation.dart';

class ActivityLog {
  final String activity;
  final String? details;
  final DateTime timestamp;

  ActivityLog({
    required this.activity,
    this.details,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'ActivityLog(activity: $activity, details: $details, timestamp: $timestamp)';
  }
}