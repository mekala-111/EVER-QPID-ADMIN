class MostActiveClan {
  final String label;
  final int value;

  MostActiveClan({
    required this.label,
    required this.value,
  });

  factory MostActiveClan.fromJson(Map<String, dynamic> json) {
    return MostActiveClan(
      label: json['label'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}
