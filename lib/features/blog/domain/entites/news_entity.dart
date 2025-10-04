import 'package:equatable/equatable.dart';
import '../../../home/domain/entity/localized_text_entity.dart';

class NewsEntity extends Equatable {
  final String id;
  final LocalizedTextEntity title;
  final LocalizedTextEntity content;
  final LocalizedTextEntity excerpt;
  final String imageUrl;
  final String category;
  final String author;
  final List<String> tags;
  final bool featured;
  final int views;
  final DateTime publishedAt;

  const NewsEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.imageUrl,
    required this.category,
    required this.author,
    required this.tags,
    required this.featured,
    required this.views,
    required this.publishedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    excerpt,
    imageUrl,
    category,
    author,
    tags,
    featured,
    views,
    publishedAt,
  ];
}
