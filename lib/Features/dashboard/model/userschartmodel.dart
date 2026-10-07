class GenderChartModel {
  final List<String> months;
  final List<int> man;
  final List<int> women;
  final List<int> other;

  GenderChartModel({
    required this.months,
    required this.man,
    required this.women,
    required this.other,
  });

  factory GenderChartModel.fromJson(Map<String, dynamic> json) {
    return GenderChartModel(
      months: List<String>.from(json['months'] ?? []),
      man: List<int>.from(json['Man'] ?? []),
      women: List<int>.from(json['Women'] ?? []),
      other: List<int>.from(json['Other'] ?? []),
    );
  }
}
