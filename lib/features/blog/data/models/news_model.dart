import '../../../home/domain/entity/localized_text_entity.dart';
import '../../domain/entites/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required super.id,
    required super.title,
    required super.content,
    required super.excerpt,
    required super.imageUrl,
    required super.category,
    required super.author,
    required super.tags,
    required super.featured,
    required super.views,
    required super.publishedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['_id']?.toString() ?? '',
      title: LocalizedTextEntity.fromJson(json['title'] ?? {}),
      content: LocalizedTextEntity.fromJson(json['content'] ?? {}),
      excerpt: LocalizedTextEntity.fromJson(json['excerpt'] ?? {}),
      imageUrl: json['image']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      featured: json['featured'] as bool? ?? false,
      views: (json['views'] as num?)?.toInt() ?? 0,
      publishedAt: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title.toJson(),
      'content': content.toJson(),
      'excerpt': excerpt.toJson(),
      'image': imageUrl,
      'category': category,
      'author': author,
      'tags': tags,
      'featured': featured,
      'views': views,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }
}
