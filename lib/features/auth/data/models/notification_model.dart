import '../../domain/entites/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.type,
    required super.message,
    required super.read,
    required super.link,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final messageData = json['message'];
    return NotificationModel(
      id: json['_id']?['\$oid'] ?? json['_id'] ?? '',
      type: json['type'] ?? '',
      message: messageData,
      read: json['read'] ?? false,
      link: json['link'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']['\$date'] ?? '') ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'message': message,
      'read': read,
      'link': link,
      'createdAt': {'\$date': createdAt.toIso8601String()},
    };
  }
}