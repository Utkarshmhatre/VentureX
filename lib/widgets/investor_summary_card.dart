import 'package:flutter/material.dart';

class InvestorSummaryCard extends StatelessWidget {
  final double averageInvestment;
  final int activeDeals;
  final int matchingScore;

  const InvestorSummaryCard({
    super.key,
    required this.averageInvestment,
    required this.activeDeals,
    required this.matchingScore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Investor Snapshot',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricColumn(
                  context,
                  'Avg. Investment',
                  averageInvestment,
                  '\$M',
                ),
                _buildMetricColumn(context, 'Active Deals', activeDeals, ''),
                _buildMatchingScoreColumn(context, matchingScore),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricColumn(
    BuildContext context,
    String label,
    num value,
    String unit,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 30,
          width: 70,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: AnimatedCount(
              count: value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              suffix: unit,
              duration: const Duration(milliseconds: 800),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMatchingScoreColumn(BuildContext context, int matchingScore) {
    return Column(
      children: [
        const Text(
          'Matching Score',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Replace AnimatedRadialGauge with a simple progress indicator
              CircularProgressIndicator(
                value: matchingScore / 100,
                strokeWidth: 8,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.grey.shade300,
              ),
              Text(
                '$matchingScore%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedCount extends StatelessWidget {
  const AnimatedCount({
    super.key,
    required this.count,
    required this.style,
    required this.duration,
    this.prefix = '',
    this.suffix = '',
  });

  final num count;
  final TextStyle style;
  final Duration duration;
  final String prefix;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: count.toDouble()),
      duration: duration,
      builder:
          (context, value, child) => Text(
            '$prefix${value.toStringAsFixed(count is int ? 0 : 1)}$suffix',
            style: style,
            textAlign: TextAlign.center,
          ),
    );
  }
}
