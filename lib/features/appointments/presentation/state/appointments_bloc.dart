// features/appointments/presentation/state/appointments_bloc.dart
import 'dart:async';
import 'package:aurora_app/features/appointments/data/repo/appointment_repository_Impl.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/networking/failure.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/schedule_appointment_params.dart';
import '../../domain/repo/appointments_repository.dart';
import 'appointments_event.dart';
import 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final AppointmentRepositoryImpl repository;

  AppointmentsBloc({required this.repository}) : super(AppointmentsInitial()) {
    on<FetchUserAppointments>(_onFetchUserAppointments);
    on<InitializeScheduleAppointment>(_onInitializeScheduleAppointment);
    on<SubmitScheduleAppointment>(_onSubmitScheduleAppointment);
    on<SetScheduleStep>((e, emit) => _updateScheduleField(step: e.step, emit: emit));
    on<UpdateScheduleDate>((e, emit) => _updateScheduleField(selectedDate: e.date, selectedTime: null, emit: emit));
    on<UpdateScheduleTime>((e, emit) => _updateScheduleField(selectedTime: e.time, emit: emit));
    on<UpdateScheduleVisitType>((e, emit) => _updateScheduleField(visitType: e.visitType, vrCity: null, emit: emit));
    on<UpdateScheduleVrCity>((e, emit) => _updateScheduleField(vrCity: e.vrCity, emit: emit));
    on<UpdateScheduleNotes>((e, emit) => _updateScheduleField(notes: e.notes, emit: emit));
  }

  ScheduleAppointmentState get _currentScheduleState =>
      state is ScheduleAppointmentState ? state as ScheduleAppointmentState : ScheduleAppointmentState(propertyId: '');

  Future<void> _onFetchUserAppointments(FetchUserAppointments event, Emitter<AppointmentsState> emit) async {
    emit(AppointmentsLoading());
    final Either<Failure, List<AppointmentModel>> result = await repository.fetchUserAppointments();
    result.fold(
      (failure) => emit(AppointmentsError(failure.message)),
      (appointments) => emit(AppointmentsLoaded(appointments)),
    );
  }

  void _onInitializeScheduleAppointment(InitializeScheduleAppointment event, Emitter<AppointmentsState> emit) {
    emit(ScheduleAppointmentState(
      propertyId: event.propertyId,
      step: 0,
      selectedDate: DateTime.now(),
      selectedTime: "09:00",
      visitType: "property",
      vrCity: '',
      notes: '',
      isSubmitting: false,
      isSuccess: false,
      error: null,
    ));
  }

  Future<void> _onSubmitScheduleAppointment(SubmitScheduleAppointment event, Emitter<AppointmentsState> emit) async {
    final current = _currentScheduleState;

    emit(current.copyWith(isSubmitting: true, error: null, isSuccess: false));

    final Either<Failure, void> result = await repository.scheduleAppointment(event.params);

    result.fold(
      (failure) => emit(current.copyWith(isSubmitting: false, isSuccess: false, error: failure.message)),
      (_) async {
        emit(current.copyWith(isSubmitting: false, isSuccess: true, error: null));

        final appointmentsResult = await repository.fetchUserAppointments();
        appointmentsResult.fold(
          (failure) => print('Error refreshing appointments: ${failure.message}'),
          (appointments) => emit(AppointmentsLoaded(appointments)),
        );
      },
    );
  }

  void _updateScheduleField({
    int? step,
    DateTime? selectedDate,
    String? selectedTime,
    String? visitType,
    String? vrCity,
    String? notes,
    required Emitter<AppointmentsState> emit,
  }) {
    final current = _currentScheduleState;
    emit(current.copyWith(
      step: step ?? current.step,
      selectedDate: selectedDate ?? current.selectedDate,
      selectedTime: selectedTime ?? current.selectedTime,
      visitType: visitType ?? current.visitType,
      vrCity: vrCity ?? current.vrCity,
      notes: notes ?? current.notes,
    ));
  }
}
