import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liteline/screens/friend_list_page.dart';
import 'package:liteline/screens/personal_chats_page.dart';
import 'package:liteline/screens/calls_page.dart';
import 'package:liteline/screens/activity_page.dart';
import 'package:liteline/activity_tracker.dart';
import 'package:liteline/utils/helpers.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  int _selectedIndex = 0;
  final ActivityTracker _activityTracker = ActivityTracker();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      FriendListPage(activityTracker: _activityTracker),
      PersonalChatsPage(activityTracker: _activityTracker),
      CallsPage(activityTracker: _activityTracker),
      ActivityPage(activityTracker: _activityTracker),
    ];

    _activityTracker.logActivity('App Started', details: 'User opened the app');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        showToast(
          context,
          'Selamat datang kembali!',
          icon: FontAwesomeIcons.check,
          backgroundColor: Colors.green.shade700,
        );
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _activityTracker.logActivity(
      'Navigation',
      details:
          'Navigated to ${index == 0 ? 'Beranda' : index == 1 ? 'Obrolan' : index == 2 ? 'Panggilan' : 'Activity'}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xFF121212),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            Expanded(child: _pages[_selectedIndex]),
            BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: const Color(0xFF0a0a0a),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white54,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.home),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.commentAlt),
                  label: 'Obrolan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.phoneAlt),
                  label: 'Panggilan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.listAlt),
                  label: 'Activity',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}