import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:liteline/utils/helpers.dart'; 

class PreferencePage extends StatefulWidget {
  const PreferencePage({super.key});

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  String _savedText = 'No text saved yet.';
  bool _isDarkMode = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedText = prefs.getString('my_text_preference') ?? 'No text saved yet.';
      _isDarkMode = prefs.getBool('dark_mode_preference') ?? false;
      _textController.text = _savedText == 'No text saved yet.' ? '' : _savedText;
    });
  }

  Future<void> _saveTextPreference(String text) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('my_text_preference', text);
    setState(() {
      _savedText = text;
    });
    showToast(context, 'Text preference saved!');
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode_preference', value);
    setState(() {
      _isDarkMode = value;
    });
    showToast(context, 'Dark mode preference ${value ? 'enabled' : 'disabled'}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Preferences'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Text Preference:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter text to save',
                labelStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                filled: true,
                fillColor: const Color(0xFF2C2C2C),
              ),
              onSubmitted: _saveTextPreference,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _saveTextPreference(_textController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Save Text', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Saved Text: $_savedText',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const Divider(height: 40, color: Colors.white24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Dark Mode:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Switch(
                  value: _isDarkMode,
                  onChanged: _toggleDarkMode,
                  activeColor: Colors.blueAccent,
                ),
              ],
            ),
            Text(
              'Dark Mode is currently ${_isDarkMode ? 'enabled' : 'disabled'}.',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}