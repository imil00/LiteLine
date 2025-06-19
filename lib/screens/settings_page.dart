import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:liteline/utils/helpers.dart';
import 'package:liteline/screens/login_page.dart'; 

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _appLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _appLanguage = prefs.getString('app_language') ?? 'English';
    });
  }

  Future<void> _saveNotificationsSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
    showToast(context, 'Notifications ${value ? 'enabled' : 'disabled'}');
  }

  Future<void> _saveLanguageSetting(String? value) async {
    if (value != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', value);
      setState(() {
        _appLanguage = value;
      });
      showToast(context, 'Language set to $value');
    }
  }

  Future<void> _logout() async {
    showCustomAlert(
      context,
      title: 'Logout',
      message: 'Are you sure you want to log out?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      confirmColor: Colors.red,
      icon: Icons.logout,
      onConfirm: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
        showToast(context, 'Logged out successfully!');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: const Text('Enable Notifications', style: TextStyle(color: Colors.white)),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: _saveNotificationsSetting,
              activeColor: Colors.blueAccent,
            ),
            tileColor: const Color(0xFF2C2C2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text('App Language', style: TextStyle(color: Colors.white)),
            trailing: DropdownButton<String>(
              value: _appLanguage,
              dropdownColor: const Color(0xFF2C2C2C),
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.white,
              onChanged: _saveLanguageSetting,
              items: <String>['English', 'Indonesian', 'Spanish', 'French']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            tileColor: const Color(0xFF2C2C2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text('About Us', style: TextStyle(color: Colors.white)),
            leading: const Icon(Icons.info_outline, color: Colors.blueAccent),
            onTap: () {
              showCustomAlert(
                context,
                title: 'About Liteline',
                message: 'Liteline App v1.0.0\n\nDeveloped to demonstrate various Flutter features including Camera, Maps, Preferences, Async operations, SMS autofill, Charts, Autocomplete, and user authentication.',
                confirmText: 'Close',
                icon: Icons.app_blocking,
              );
            },
            tileColor: const Color(0xFF2C2C2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Logout', style: TextStyle(color: Colors.white, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}