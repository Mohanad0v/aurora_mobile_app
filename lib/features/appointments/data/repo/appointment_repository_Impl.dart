// features/appointments/data/repo/appointment_repository_impl.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../../../core/networking/error_handler.dart';
import '../../../../core/networking/failure.dart';
import '../../../../core/networking/network_info.dart';
import '../../domain/repo/appointments_repository.dart';
import '../data_source/appointments_remote_data_source.dart';
import '../models/appointment_model.dart';
import '../models/schedule_appointment_params.dart';

class AppointmentRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AppointmentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AppointmentModel>>> fetchUserAppointments() async {
    if (!await networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
    try {
      final appointments = await remoteDataSource.fetchUserAppointments();
      return Right(appointments);
    } catch (error, st) {
      log('Error fetching appointments in repository: $error', stackTrace: st);
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, void>> scheduleAppointment(ScheduleAppointmentParams params) async {
    if (!await networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      // Remote DS now handles 2xx & string success properly
      await remoteDataSource.scheduleAppointment(params);
      return const Right(null);
    } catch (error, st) {
      log('Error scheduling appointment: $error', stackTrace: st);
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
