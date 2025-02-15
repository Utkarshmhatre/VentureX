import 'package:flutter/material.dart';

class SwipeButtons extends StatelessWidget {
  final VoidCallback onLike;
  final VoidCallback onPass;

  const SwipeButtons({super.key, required this.onLike, required this.onPass});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _SwipeButton(icon: Icons.close, color: Colors.red, onTap: onPass),
          _SwipeButton(
            icon: Icons.favorite,
            color: Colors.green,
            onTap: onLike,
          ),
        ],
      ),
    );
  }
}

class _SwipeButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SwipeButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 32),
        onPressed: onTap,
      ),
    );
  }
}
