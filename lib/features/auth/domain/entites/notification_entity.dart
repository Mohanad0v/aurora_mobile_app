import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String type;
  final String message;
  final bool read;
  final String link;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.message,
    required this.read,
    required this.link,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, type, message, read, link, createdAt];
}
