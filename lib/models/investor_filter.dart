import 'package:flutter/material.dart';

class InvestorFilter {
  final String selectedIndustry;
  final String selectedCategory;
  final RangeValues investmentRange;

  const InvestorFilter({
    this.selectedIndustry = 'All',
    this.selectedCategory = 'All',
    this.investmentRange = const RangeValues(0, 10),
  });

  InvestorFilter copyWith({
    String? selectedIndustry,
    String? selectedCategory,
    RangeValues? investmentRange,
  }) {
    return InvestorFilter(
      selectedIndustry: selectedIndustry ?? this.selectedIndustry,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      investmentRange: investmentRange ?? this.investmentRange,
    );
  }
}
