import 'package:equatable/equatable.dart';
import '../../data/models/schedule_appointment_params.dart';

abstract class AppointmentsEvent extends Equatable {
  const AppointmentsEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserAppointments extends AppointmentsEvent {
  final String userId;

  const FetchUserAppointments({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class SetScheduleStep extends AppointmentsEvent {
  final int step;

  const SetScheduleStep(this.step);

  @override
  List<Object?> get props => [step];
}

class UpdateScheduleDate extends AppointmentsEvent {
  final DateTime date;

  const UpdateScheduleDate(this.date);

  @override
  List<Object?> get props => [date];
}

class UpdateScheduleTime extends AppointmentsEvent {
  final String time;

  const UpdateScheduleTime(this.time);

  @override
  List<Object?> get props => [time];
}

class UpdateScheduleVisitType extends AppointmentsEvent {
  final String visitType;

  const UpdateScheduleVisitType(this.visitType);

  @override
  List<Object?> get props => [visitType];
}

class UpdateScheduleVrCity extends AppointmentsEvent {
  final String vrCity;

  const UpdateScheduleVrCity(this.vrCity);

  @override
  List<Object?> get props => [vrCity];
}

class UpdateScheduleNotes extends AppointmentsEvent {
  final String notes;

  const UpdateScheduleNotes(this.notes);

  @override
  List<Object?> get props => [notes];
}

class SubmitScheduleAppointment extends AppointmentsEvent {
  final ScheduleAppointmentParams params;

  const SubmitScheduleAppointment(this.params);

  @override
  List<Object?> get props => [params];
}

class InitializeScheduleAppointment extends AppointmentsEvent {
  final String propertyId;

  const InitializeScheduleAppointment({required this.propertyId});
}
