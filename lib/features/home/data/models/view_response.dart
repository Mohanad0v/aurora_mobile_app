class ViewsResponse {
  final bool success;
  final double totalViews;

  ViewsResponse({
    required this.success,
    required this.totalViews,
  });

  factory ViewsResponse.fromJson(Map<String, dynamic> json) {
    return ViewsResponse(
      success: json['success'] ?? false,
      totalViews: (json['totalViews'] != null)
          ? double.tryParse(json['totalViews'].toString()) ?? 0.0
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'totalViews': totalViews,
    };
  }
}
class CompletedDealsResponse {
  final bool success;
  final int count;

  CompletedDealsResponse({
    required this.success,
    required this.count,
  });

  factory CompletedDealsResponse.fromJson(Map<String, dynamic> json) {
    return CompletedDealsResponse(
      success: json['success'] ?? false,
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'count': count,
      };
}
