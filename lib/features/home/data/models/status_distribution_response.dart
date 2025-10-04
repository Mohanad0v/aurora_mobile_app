class StatusDistributionResponse {
  final bool success;
  final Map<String, int> distribution;

  StatusDistributionResponse({
    required this.success,
    required this.distribution,
  });

  factory StatusDistributionResponse.fromJson(Map<String, dynamic> json) {
    return StatusDistributionResponse(
      success: json['success'] ?? false,
      distribution: (json['distribution'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as int? ?? 0)) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'distribution': distribution,
    };
  }
}
