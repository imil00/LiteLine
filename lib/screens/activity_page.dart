import 'package:flutter/material.dart';
import 'package:liteline/activity_tracker.dart';
import 'package:liteline/models/activity_log.dart';
import 'package:intl/intl.dart'; 

class ActivityPage extends StatefulWidget {
  final ActivityTracker activityTracker;

  const ActivityPage({super.key, required this.activityTracker});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<ActivityLog> _activityLogs = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.activityTracker.logActivity(
        'Activity Tab',
        details: 'User viewed activity log',
      );
      _loadActivities(); 
    });
  }

  void _loadActivities() {
    setState(() {
      _activityLogs = widget.activityTracker.recentActivities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          'Log Aktivitas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _loadActivities,
            tooltip: 'Refresh Log Aktivitas',
          ),
        ],
      ),
      body: _activityLogs.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada aktivitas yang tercatat.',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _activityLogs.length,
              itemBuilder: (context, index) {
                final log = _activityLogs[index];
                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.blue),
                    title: Text(
                      log.activity,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log.details ?? 'No details provided.',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMM yyyy, HH:mm:ss').format(log.timestamp),
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}