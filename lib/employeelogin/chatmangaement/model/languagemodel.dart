class LanguageResponse {
  final List<String> data;

  LanguageResponse({required this.data});

  factory LanguageResponse.fromJson(Map<String, dynamic> json) {
    return LanguageResponse(
      data: List<String>.from(json['data'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
    };
  }
}
