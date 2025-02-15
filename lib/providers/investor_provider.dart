import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/investor_data.dart';
import '../models/investor_filter.dart';
import '../data/investors_data.dart';

class InvestorFilterNotifier extends StateNotifier<InvestorFilter> {
  InvestorFilterNotifier() : super(const InvestorFilter());

  void updateIndustry(String industry) {
    state = state.copyWith(selectedIndustry: industry);
  }

  void updateCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void updateInvestmentRange(RangeValues range) {
    state = state.copyWith(investmentRange: range);
  }
}

final investorFilterProvider =
    StateNotifierProvider<InvestorFilterNotifier, InvestorFilter>(
      (ref) => InvestorFilterNotifier(),
    );

final filteredInvestorsProvider = Provider<List<InvestorData>>((ref) {
  final filters = ref.watch(investorFilterProvider);

  try {
    if (rawInvestorsData.isEmpty) {
      return [];
    }

    final investors =
        rawInvestorsData.map((map) => InvestorData.fromMap(map)).where((
          investor,
        ) {
          bool industryMatch =
              filters.selectedIndustry == 'All' ||
              investor.industry == filters.selectedIndustry;
          bool investmentMatch =
              investor.investment >= filters.investmentRange.start &&
              investor.investment <= filters.investmentRange.end;
          bool categoryMatch =
              filters.selectedCategory == 'All' ||
              investor.interests.contains(filters.selectedCategory);

          return industryMatch && investmentMatch && categoryMatch;
        }).toList();

    return investors;
  } catch (e) {
    print('Error filtering investors: $e');
    return [];
  }
});
