import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liteline/activity_tracker.dart';
import 'package:liteline/utils/helpers.dart'; 

class CallsPage extends StatelessWidget {
  final ActivityTracker activityTracker;

  const CallsPage({super.key, required this.activityTracker});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      activityTracker.logActivity(
        'Calls Tab',
        details: 'User viewed call history',
      );
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          'Panggilan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call, color: Colors.white70),
            onPressed: () {
              activityTracker.logActivity(
                'Call Action',
                details: 'User initiated new video call',
              );
              showCustomAlert(
                context,
                title: 'Video Call Baru',
                message: 'Pilih kontak untuk memulai video call',
                confirmText: 'Pilih Kontak',
                cancelText: 'Batal', 
                icon: FontAwesomeIcons.video, 
                onConfirm: () {
                  showToast(
                    context,
                    'Membuka daftar kontak untuk video call...',
                    icon: FontAwesomeIcons.addressBook,
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white70),
            onPressed: () {
              activityTracker.logActivity(
                'Call Action',
                details: 'User initiated new voice call',
              );
              showCustomAlert(
                context,
                title: 'Panggilan Baru',
                message: 'Pilih kontak untuk memulai panggilan suara',
                confirmText: 'Pilih Kontak',
                cancelText: 'Batal',
                icon: FontAwesomeIcons.phone,
                onConfirm: () {
                  showToast(
                    context,
                    'Membuka daftar kontak untuk panggilan suara...',
                    icon: FontAwesomeIcons.addressBook,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.phoneSlash,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tidak ada riwayat panggilan.',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Mulai panggilan atau video call baru dari sini.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                activityTracker.logActivity(
                  'Call Action',
                  details: 'User tapped start new call button',
                );
                showCustomAlert(
                  context,
                  title: 'Panggilan Baru',
                  message: 'Apakah Anda ingin memulai panggilan suara atau video?',
                  confirmText: 'Video Call',
                  cancelText: 'Panggilan Suara',
                  icon: FontAwesomeIcons.phoneVolume,
                  confirmColor: Colors.teal,
                  onConfirm: () {
                    showToast(
                      context,
                      'Membuka daftar kontak untuk video call...',
                      icon: FontAwesomeIcons.video,
                    );
                  },
                  onCancel: () {
                    showToast(
                      context,
                      'Membuka daftar kontak untuk panggilan suara...',
                      icon: FontAwesomeIcons.phone,
                    );
                  },
                );
              },
              icon: const Icon(FontAwesomeIcons.plus, color: Colors.white),
              label: const Text(
                'Mulai Panggilan Baru',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}