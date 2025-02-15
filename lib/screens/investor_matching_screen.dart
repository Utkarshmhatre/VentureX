import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/investor_card.dart';
import '../providers/investor_provider.dart';
import '../models/investor_filter.dart';
import '../models/investor_data.dart';
import 'dart:math' as math;
import 'investor_detail_screen.dart';

class InvestorMatchingScreen extends ConsumerWidget {
  const InvestorMatchingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(investorFilterProvider);
    final investors = ref.watch(filteredInvestorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Investor Insights'),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, ref, filters),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildAnalyticsSummary(investors),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildGraphCard(
                    'Industry Distribution',
                    SizedBox(
                      width: 400,
                      height: 300,
                      child: _buildBarChart(investors),
                    ),
                  ),
                  _buildGraphCard(
                    'Regional Distribution',
                    SizedBox(width: 300, height: 300, child: _buildPieChart()),
                  ),
                  _buildGraphCard(
                    'Investment Trends',
                    SizedBox(
                      width: 400,
                      height: 300,
                      child: _buildLineChart(investors),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => InvestorCard(
                  investor: investors[index].toMap(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => InvestorDetailScreen(
                              investor: investors[index],
                            ),
                      ),
                    );
                  },
                ),
                childCount: investors.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSummary(List<InvestorData> investors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portfolio Analytics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildMetricCard(
                  'Total Investors',
                  investors.length.toString(),
                  Icons.people,
                ),
                const SizedBox(width: 8),
                _buildMetricCard(
                  'Avg Investment',
                  '\$${_calculateAverageInvestment(investors).toStringAsFixed(1)}M',
                  Icons.attach_money,
                ),
                const SizedBox(width: 8),
                _buildMetricCard(
                  'Active Deals',
                  _calculateTotalDeals(investors).toString(),
                  Icons.trending_up,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphCard(String title, Widget chart) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            chart,
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return SizedBox(
      width: 110, // Fixed width for consistency
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12), // Reduced padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.blue, size: 24),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(
    BuildContext context,
    WidgetRef ref,
    InvestorFilter filters,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Make the sheet larger
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder:
                (context, scrollController) =>
                    _buildFilterPanel(context, ref, filters),
          ),
    );
  }

  Widget _buildFilterPanel(
    BuildContext context,
    WidgetRef ref,
    InvestorFilter filters,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Filter Investors',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildFilterDropdown(
            'Industry',
            filters.selectedIndustry,
            const [
              'All',
              'Technology',
              'Healthcare',
              'E-commerce',
              'AI/ML',
              'Fintech',
              'Biotech',
              'Clean Energy',
              'Transportation',
              'Media & Entertainment',
            ],
            (value) => ref
                .read(investorFilterProvider.notifier)
                .updateIndustry(value!),
          ),
          const SizedBox(height: 16),
          _buildFilterDropdown(
            'Category',
            filters.selectedCategory,
            const [
              'All',
              'AI',
              'SaaS',
              'Fintech',
              'Biotech',
              'Digital Health',
              'MedTech',
              'D2C',
              'Marketplace',
              'Retail Tech',
            ],
            (value) => ref
                .read(investorFilterProvider.notifier)
                .updateCategory(value!),
          ),
          const SizedBox(height: 24),
          Text('Investment Range (\$M)', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Column(
            children: [
              RangeSlider(
                values: filters.investmentRange,
                min: 0,
                max: 10,
                divisions: 20,
                activeColor: Colors.blue,
                inactiveColor: Colors.blue.withOpacity(0.2),
                labels: RangeLabels(
                  '\$${filters.investmentRange.start.toStringAsFixed(1)}M',
                  '\$${filters.investmentRange.end.toStringAsFixed(1)}M',
                ),
                onChanged: (values) {
                  ref
                      .read(investorFilterProvider.notifier)
                      .updateInvestmentRange(values);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    final value = (index * 2).toString();
                    return Text(
                      '\$$value${index == 5 ? 'M+' : 'M'}',
                      style: const TextStyle(fontSize: 12),
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: InputBorder.none,
            ),
            items:
                items
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(List<InvestorData> investors) {
    if (investors.isEmpty) {
      return const Center(
        child: Text(
          'No matching investors found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final industryData = <String, double>{};
    for (var investor in investors) {
      final industry = investor.industry;
      industryData[industry] = (industryData[industry] ?? 0) + 1;
    }

    if (industryData.isEmpty) {
      return const Center(
        child: Text(
          'No industry data available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final maxValue = industryData.values.fold<double>(
      0,
      (previousValue, element) =>
          previousValue > element ? previousValue : element,
    );

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ), // Add bottom padding for labels
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue + 2,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60, // Increased height for labels
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value < 0 || value >= industryData.keys.length) {
                    return const SizedBox.shrink();
                  }
                  final industry = industryData.keys.toList()[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Transform.rotate(
                      angle: -math.pi / 4, // Less rotation angle
                      child: SizedBox(
                        width: 70, // Fixed width for label
                        child: Text(
                          industry,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 1,
            drawVerticalLine: false,
          ),
          borderData: FlBorderData(show: false),
          barGroups:
              industryData.entries
                  .map(
                    (entry) => BarChartGroupData(
                      x: industryData.keys.toList().indexOf(entry.key),
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.blueAccent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          width: 16, // Slightly wider bars
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final regionData = <String, double>{};
    regionData['North America'] = 40;
    regionData['Europe'] = 30;
    regionData['Asia'] = 30;

    final List<Color> availableColors = [
      const Color(0xff0293ee),
      const Color(0xfff8b250),
      const Color(0xff845bef),
      const Color(0xff13d38e),
    ];

    return PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 30, // Smaller center space
        sections:
            regionData.entries
                .toList()
                .asMap()
                .map<int, PieChartSectionData>((index, entry) {
                  final isTouched = false;
                  final fontSize = isTouched ? 16.0 : 12.0; // Smaller font size
                  final radius = isTouched ? 90.0 : 80.0; // Smaller radius
                  final widget = PieChartSectionData(
                    color: availableColors[index % availableColors.length],
                    value: entry.value,
                    title: '${entry.key}\n${entry.value}%',
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff),
                    ),
                  );
                  return MapEntry(index, widget);
                })
                .values
                .toList(),
      ),
    );
  }

  Widget _buildLineChart(List<InvestorData> investors) {
    if (investors.isEmpty) {
      return const Center(
        child: Text(
          'No investment trend data available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Calculate yearly averages
    final yearlyData = <int, List<double>>{};
    for (var investor in investors) {
      for (var history in investor.investmentHistory) {
        final year = history['year'] as int;
        final amount = history['amount'] as double;
        yearlyData.putIfAbsent(year, () => []);
        yearlyData[year]!.add(amount);
      }
    }

    final spots =
        yearlyData.entries.map((entry) {
            final year = entry.key;
            final average =
                entry.value.reduce((a, b) => a + b) / entry.value.length;
            return FlSpot(year.toDouble(), average);
          }).toList()
          ..sort((a, b) => a.x.compareTo(b.x));

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toStringAsFixed(1)}M',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.blueAccent],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.2),
                  Colors.blueAccent.withOpacity(0.2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateAverageInvestment(List<InvestorData> investors) {
    if (investors.isEmpty) return 0;
    return investors.map((e) => e.investment).reduce((a, b) => a + b) /
        investors.length;
  }

  int _calculateTotalDeals(List<InvestorData> investors) {
    if (investors.isEmpty) return 0;
    return investors.map((e) => e.activeInvestments).reduce((a, b) => a + b);
  }
}
