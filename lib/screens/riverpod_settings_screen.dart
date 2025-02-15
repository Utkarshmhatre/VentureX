import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state =
                    value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
          ListTile(
            title: const Text('Notifications'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Implement notification settings
              },
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: 'English',
              onChanged: (String? newValue) {
                // TODO: Implement language change
              },
              items:
                  <String>[
                    'English',
                    'Spanish',
                    'French',
                    'German',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 300.ms),
        ],
      ),
    );
  }
}
