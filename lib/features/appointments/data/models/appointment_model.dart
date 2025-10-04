import '../../../home/data/models/property_response_model.dart';

class AppointmentModel {
  final String id;
  final Property property;
  final String userId;
  final DateTime date;
  final String time;
  final String status;
  final String? meetingPlatform;
  final String? visitType;
  final String? notes;
  final bool reminderSent;
  final String? meetingLink;
  final String? vrCity;

  AppointmentModel({
    required this.id,
    required this.property,
    required this.userId,
    required this.date,
    required this.time,
    required this.status,
    this.meetingPlatform,
    this.visitType,
    this.notes,
    this.reminderSent = false,
    this.meetingLink,
    this.vrCity,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final propertyJson = json['propertyId'] as Map<String, dynamic>? ?? {};
    return AppointmentModel(
      id: json['_id']?.toString() ?? '',
      property: Property.fromJson(propertyJson),
      userId: json['userId']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      time: json['time']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      meetingPlatform: json['meetingPlatform']?.toString(),
      visitType: json['visitType']?.toString(),
      notes: json['notes']?.toString(),
      reminderSent: json['reminderSent'] as bool? ?? false,
      meetingLink: json['meetingLink']?.toString(),
      vrCity: json['vrCity']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'propertyId': property.toJson(),
    'userId': userId,
    'date': date.toIso8601String(),
    'time': time,
    'status': status,
    'meetingPlatform': meetingPlatform,
    'visitType': visitType,
    'notes': notes,
    'reminderSent': reminderSent,
    'meetingLink': meetingLink,
    'vrCity': vrCity,
  };
}
