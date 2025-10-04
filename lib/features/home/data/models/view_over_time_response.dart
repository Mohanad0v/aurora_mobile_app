class ViewsOverTimeResponse {
  final bool success;
  final Map<String, int> views;

  ViewsOverTimeResponse({
    required this.success,
    required this.views,
  });

  factory ViewsOverTimeResponse.fromJson(Map<String, dynamic> json) {
    return ViewsOverTimeResponse(
      success: json['success'] ?? false,
      views: (json['views'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as int? ?? 0)) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'views': views,
    };
  }
}
