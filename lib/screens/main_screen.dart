import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'dashboard_screen.dart';
import 'business_canvas_screen.dart';
import 'investor_matching_screen.dart';
import 'gamification_screen.dart';
import 'settings_screen.dart';
import 'idea_submission_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.add(DashboardScreen(
      toggleTheme: (bool value) {
        // Implement your theme toggling logic here
      },
      isDarkMode: false, // Set the initial value for isDarkMode
    ));
    _pages.add(const BusinessCanvasScreen());
    _pages.add(const InvestorMatchingScreen());
    _pages.add(const GamificationScreen());
    _pages.add(const SettingsScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white, // base color
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4),
          child: GNav(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            gap: 10,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOutCubic,
            haptic: true,
            rippleColor: Colors.grey[300]!,
            // Interactive icon size & border
            iconSize: 26,
            tabBorderRadius: 16,
            tabBorder: Border.all(color: Colors.grey.shade300, width: 1),
            activeColor: Colors.white,
            color: Colors.grey[600],
            backgroundColor: Colors.transparent,
            tabBackgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() => _currentIndex = index);
            },
            tabs: const [
              GButton(icon: Icons.dashboard, text: 'Dashboard'),
              GButton(icon: Icons.grid_view, text: 'Canvas'),
              GButton(icon: Icons.people, text: 'Investors'),
              GButton(icon: Icons.videogame_asset, text: 'Gamification'),
              GButton(icon: Icons.settings, text: 'Settings'),
            ],
          ),
        ),
      ),
      floatingActionButton:
          _currentIndex == 0
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const IdeaSubmissionScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}
