import 'package:equatable/equatable.dart';

import '../../../home/domain/entity/proerty_entity.dart';


class AppointmentEntity extends Equatable {
  final String id;
  final PropertyEntity property;
  final String userId;
  final DateTime date;
  final String time;
  final String status;
  final String? meetingPlatform;
  final String? visitType;
  final String? notes;
  final bool? reminderSent;
  final String? meetingLink;
  final String? vrCity;

  const AppointmentEntity({
    required this.id,
    required this.property,
    required this.userId,
    required this.date,
    required this.time,
    required this.status,
    this.meetingPlatform,
    this.visitType,
    this.notes,
    this.reminderSent,
    this.meetingLink,
    this.vrCity,
  });

  @override
  List<Object?> get props => [
    id,
    property,
    userId,
    date,
    time,
    status,
    meetingPlatform,
    visitType,
    notes,
    reminderSent,
    meetingLink,
    vrCity,
  ];
}
