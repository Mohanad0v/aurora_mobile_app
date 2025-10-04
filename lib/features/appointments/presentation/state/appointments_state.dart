import 'package:equatable/equatable.dart';
import '../../data/models/appointment_model.dart';

abstract class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AppointmentsInitial extends AppointmentsState {}

/// Loading state
class AppointmentsLoading extends AppointmentsState {}

/// Loaded appointments
class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentModel> appointments;
  const AppointmentsLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

/// Error state
class AppointmentsError extends AppointmentsState {
  final String message;
  const AppointmentsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Scheduling state
class ScheduleAppointmentState extends AppointmentsState {
  final String propertyId; // Added propertyId
  final DateTime? selectedDate;
  final String? selectedTime;
  final String visitType;
  final String? vrCity;
  final String? notes;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;
  final int step;

  const ScheduleAppointmentState({
    required this.propertyId,
    this.selectedDate,
    this.selectedTime,
    this.visitType = 'property',
    this.vrCity,
    this.notes,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.error,
    this.step = 0,
  });

  ScheduleAppointmentState copyWith({
    String? propertyId,
    DateTime? selectedDate,
    String? selectedTime,
    String? visitType,
    String? vrCity,
    String? notes,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
    int? step,
  }) {
    return ScheduleAppointmentState(
      propertyId: propertyId ?? this.propertyId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      visitType: visitType ?? this.visitType,
      vrCity: vrCity ?? this.vrCity,
      notes: notes ?? this.notes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      step: step ?? this.step,
    );
  }

  @override
  List<Object?> get props => [
    propertyId,
    selectedDate,
    selectedTime,
    visitType,
    vrCity,
    notes,
    isSubmitting,
    isSuccess,
    error,
    step,
  ];
}
