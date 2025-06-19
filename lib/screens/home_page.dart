import 'package:flutter/material.dart';
import 'package:liteline/screens/camera_page.dart';
import 'package:liteline/screens/Maps_page.dart';
import 'package:liteline/screens/preference_page.dart';
import 'package:liteline/screens/settings_page.dart';
import 'package:liteline/screens/thread_async_page.dart';
import 'package:liteline/screens/sms_autofill_page.dart';
import 'package:liteline/screens/chart_page.dart';
import 'package:liteline/screens/autocomplete_spinner_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liteline App'),
        backgroundColor: const Color(0xFF1E1E1E),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: <Widget>[
          _buildFeatureCard(
            context,
            'Camera',
            Icons.camera_alt,
            const CameraPage(),
          ),
          _buildFeatureCard(
            context,
            'Google Maps',
            Icons.map,
            const GoogleMapsPage(),
          ),
          _buildFeatureCard(
            context,
            'Preferences',
            Icons.settings_applications,
            const PreferencePage(),
          ),
          _buildFeatureCard(
            context,
            'Threads & Async',
            Icons.cached,
            const ThreadAsyncPage(),
          ),
          _buildFeatureCard(
            context,
            'SMS Autofill',
            Icons.message,
            const SmsAutofillPage(),
          ),
          _buildFeatureCard(
            context,
            'Charts',
            Icons.bar_chart,
            const ChartPage(),
          ),
          _buildFeatureCard(
            context,
            'Autocomplete & Spinner',
            Icons.input,
            const AutocompleteSpinnerPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, String title, IconData icon, Widget page) {
    return Card(
      color: const Color(0xFF2C2C2C),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 50,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}