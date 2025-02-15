import 'package:flutter/material.dart';

class InvestorCard extends StatefulWidget {
  final Map<String, dynamic> investor;
  final VoidCallback onTap;

  const InvestorCard({super.key, required this.investor, required this.onTap});

  @override
  State<InvestorCard> createState() => _InvestorCardState();
}

class _InvestorCardState extends State<InvestorCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      transform:
          Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_isPressed ? 0.05 : 0)
            ..scale(_isPressed ? 0.98 : 1.0),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: Card(
          elevation: _isPressed ? 4 : 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildInvestorImage(),
                const SizedBox(width: 16),
                Expanded(child: _buildInvestorInfo()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvestorImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Image.network(widget.investor['image'], fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildInvestorInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.investor['name'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${widget.investor['company']} - ${widget.investor['industry']}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildMetricBadge(
              icon: Icons.attach_money,
              label: 'Avg. Investment',
              value: '\$${widget.investor['investment']}M',
            ),
            const SizedBox(width: 16),
            _buildMetricBadge(
              icon: Icons.trending_up,
              label: 'Active Deals',
              value: '${widget.investor['activeInvestments']}',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricBadge({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue[700]),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
