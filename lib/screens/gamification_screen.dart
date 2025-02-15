import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GamificationScreen extends StatefulWidget {
  const GamificationScreen({super.key});

  @override
  _GamificationScreenState createState() => _GamificationScreenState();
}

class _GamificationScreenState extends State<GamificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Map<String, dynamic>> _badges = [
    {
      'name': 'First Pitch',
      'icon': Icons.star,
      'unlocked': true,
      'image': 'https://via.placeholder.com/100',
    },
    {
      'name': 'Network Pro',
      'icon': Icons.group,
      'unlocked': false,
      'image': 'https://via.placeholder.com/100',
    },
    {
      'name': 'Funding Master',
      'icon': Icons.attach_money,
      'unlocked': true,
      'image': 'https://via.placeholder.com/100',
    },
    {
      'name': 'Innovation Guru',
      'icon': Icons.lightbulb,
      'unlocked': false,
      'image': 'https://via.placeholder.com/100',
    },
  ];

  final List<Map<String, dynamic>> _leaderboard = [
    {
      'name': 'John Doe',
      'points': 1200,
      'progress': 0.8,
      'image': 'https://via.placeholder.com/100',
    },
    {
      'name': 'Jane Smith',
      'points': 1100,
      'progress': 0.7,
      'image': 'https://via.placeholder.com/100',
    },
    {
      'name': 'Alice Brown',
      'points': 1050,
      'progress': 0.65,
      'image': 'https://via.placeholder.com/100',
    },
    {
      'name': 'Bob White',
      'points': 1000,
      'progress': 0.6,
      'image': 'https://via.placeholder.com/100',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh data from db_service
        },
        child: ListView(
          children: [
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                itemCount: _badges.length,
                itemBuilder:
                    (context, index) => BadgeItem(badge: _badges[index]),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Leaderboard', style: TextStyle(fontSize: 20)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _leaderboard.length,
              itemBuilder:
                  (context, index) => LeaderboardItem(
                    user: _leaderboard[index],
                    rank: index + 1,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class BadgeItem extends StatelessWidget {
  final Map<String, dynamic> badge;

  const BadgeItem({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    badge['unlocked']
                        ? [Colors.blue, Colors.purple]
                        : [Colors.grey.shade300, Colors.grey.shade400],
              ),
              boxShadow: [
                BoxShadow(
                  color: (badge['unlocked'] ? Colors.blue : Colors.grey)
                      .withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(badge['icon'], color: Colors.white, size: 32),
          ).animate().scale(duration: 300.ms).fadeIn(),
          const SizedBox(height: 8),
          Text(
            badge['name'],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: badge['unlocked'] ? Colors.black87 : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardItem extends StatelessWidget {
  final Map<String, dynamic> user;
  final int rank;

  const LeaderboardItem({super.key, required this.user, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // ...existing row content with enhanced styling...
            ],
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: rank * 100))
        .slideX(begin: 0.2, end: 0);
  }
}
