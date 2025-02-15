import 'package:flutter/material.dart';
import '../models/investor.dart';

class InvestorDetailsSheet extends StatelessWidget {
  final Investor investor;

  const InvestorDetailsSheet({super.key, required this.investor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(investor.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Company: ${investor.company}'),
          Text('Industry: ${investor.industry}'),
          Text(
            'Investment Range: \$${investor.investmentRange.toStringAsFixed(1)}M',
          ),
          const SizedBox(height: 8),
          Text('Bio:', style: Theme.of(context).textTheme.titleMedium),
          Text(investor.bio),
          if (investor.interests.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Interests:', style: Theme.of(context).textTheme.titleMedium),
            Wrap(
              spacing: 8,
              children:
                  investor.interests
                      .map((interest) => Chip(label: Text(interest)))
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
