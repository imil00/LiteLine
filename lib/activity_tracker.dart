import 'package:liteline/models/activity_log.dart'; 

class ActivityTracker {
  static final ActivityTracker _instance = ActivityTracker._internal();
  factory ActivityTracker() => _instance;
  ActivityTracker._internal();

  final List<ActivityLog> _logs = [];

  void logActivity(String activity, {String? details}) {
    _logs.add(
      ActivityLog(
        activity: activity,
        timestamp: DateTime.now(),
        details: details,
      ),
    );
    print('Activity logged: $activity | ${details ?? ""}');
  }

  List<ActivityLog> get recentActivities => _logs.reversed.take(20).toList();
}