class InvestorData {
  final String name;
  final String company;
  final String industry;
  final double investment;
  final String image;
  final String experience;
  final List<String> portfolio;
  final List<String> interests;
  final List<Map<String, dynamic>> investmentHistory;
  final int successfulExits;
  final int activeInvestments;
  final double averageTicketSize;
  final Map<String, int> sectorAllocation;

  InvestorData({
    required this.name,
    required this.company,
    required this.industry,
    required this.investment,
    required this.image,
    required this.experience,
    required this.portfolio,
    required this.interests,
    required this.investmentHistory,
    required this.successfulExits,
    required this.activeInvestments,
    required this.averageTicketSize,
    required this.sectorAllocation,
  });

  factory InvestorData.fromMap(Map<String, dynamic> map) {
    return InvestorData(
      name: map['name'],
      company: map['company'],
      industry: map['industry'],
      investment: map['investment'],
      image: map['image'],
      experience: map['experience'],
      portfolio: List<String>.from(map['portfolio']),
      interests: List<String>.from(map['interests']),
      investmentHistory: List<Map<String, dynamic>>.from(
        map['investmentHistory'],
      ),
      successfulExits: map['successfulExits'],
      activeInvestments: map['activeInvestments'],
      averageTicketSize: map['averageTicketSize'],
      sectorAllocation: Map<String, int>.from(map['sectorAllocation']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'company': company,
      'industry': industry,
      'investment': investment,
      'image': image,
      'experience': experience,
      'portfolio': portfolio,
      'interests': interests,
      'investmentHistory': investmentHistory,
      'successfulExits': successfulExits,
      'activeInvestments': activeInvestments,
      'averageTicketSize': averageTicketSize,
      'sectorAllocation': sectorAllocation,
    };
  }
}
