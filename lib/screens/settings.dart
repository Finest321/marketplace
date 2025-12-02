import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Theme',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: Text(_isDarkMode ? 'Dark Mode' : 'Light Mode'),
            value: _isDarkMode,
            onChanged: (val) {
              setState(() => _isDarkMode = val);

              // Apply theme change immediately
              final theme = val ? ThemeMode.dark : ThemeMode.light;
              // Use InheritedWidget or Provider in a real app
              // For now, just show feedback
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(val
                      ? 'Dark Mode Enabled'
                      : 'Light Mode Enabled'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            secondary: Icon(
              _isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: _isDarkMode ? Colors.deepOrange : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}