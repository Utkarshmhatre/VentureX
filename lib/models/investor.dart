class Investor {
  final String id;
  final String name;
  final String company;
  final String industry;
  final double investmentRange;
  final String bio;
  final List<String> interests;

  Investor({
    String? id,
    required this.name,
    required this.company,
    required this.industry,
    required this.investmentRange,
    required this.bio,
    this.interests = const [],
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  factory Investor.fromJson(Map<String, dynamic> json) {
    return Investor(
      id: json['id'],
      name: json['name'],
      company: json['company'],
      industry: json['industry'],
      investmentRange: json['investmentRange']?.toDouble() ?? 0.0,
      bio: json['bio'],
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'company': company,
    'industry': industry,
    'investmentRange': investmentRange,
    'bio': bio,
    'interests': interests,
  };
}
