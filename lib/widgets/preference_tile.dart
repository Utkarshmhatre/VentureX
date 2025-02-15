import 'package:flutter/material.dart';

class PreferenceTile extends StatelessWidget {
  final String title;
  final Widget trailing;
  const PreferenceTile({super.key, required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(title), trailing: trailing);
  }
}
