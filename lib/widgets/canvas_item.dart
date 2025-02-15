import 'package:flutter/material.dart';

class CanvasItem extends StatelessWidget {
  final String title;
  const CanvasItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueAccent.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(title, style: TextStyle(color: Colors.white)),
    );
  }
}
