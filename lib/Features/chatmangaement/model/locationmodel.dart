class HostLocationResponse {
  final List<String> locations;

  HostLocationResponse({required this.locations});

  factory HostLocationResponse.fromJson(Map<String, dynamic> json) {
    return HostLocationResponse(
      locations: List<String>.from(json['data'] ?? []),
    );
  }
}
