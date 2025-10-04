// features/appointments/domain/repo/appointments_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/networking/failure.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/schedule_appointment_params.dart';

abstract class AppointmentsRepository {
  Future<Either<Failure, List<AppointmentModel>>> fetchUserAppointments();
  Future<Either<Failure, void>> scheduleAppointment(ScheduleAppointmentParams params);
}
