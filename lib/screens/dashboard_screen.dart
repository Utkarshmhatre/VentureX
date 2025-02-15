import 'package:flutter/material.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;
  const DashboardScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SummaryCard(title: 'Idea Feedback', value: '85%'),
            SummaryCard(title: 'Business Model', value: 'Complete'),
            SummaryCard(title: 'Investor Match', value: '5 Matches'),
            SummaryCard(title: 'Progress', value: 'Level 2'),
          ],
        ),
      ),
    );
  }
}
