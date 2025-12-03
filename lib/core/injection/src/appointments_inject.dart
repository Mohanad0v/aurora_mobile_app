import 'package:aurora_app/features/appointments/presentation/state/appointments_bloc.dart';
import 'package:dio/dio.dart';
import '../../../features/appointments/data/data_source/appointments_remote_data_source.dart';
import '../../../features/appointments/data/repo/appointment_repository_Impl.dart';
import '../../networking/dio/dio_client.dart';
import '../injection.dart';

Future<void> appointmentsInject() async {
  locator.registerLazySingleton<AppointmentsRemoteDataSource>(
    () => AppointmentsRemoteDataSource(
      dioClient: locator<DioClient>(),
      dio: locator<Dio>(),
    ),
  );

  locator.registerLazySingleton<AppointmentRepositoryImpl>(
    () => AppointmentRepositoryImpl(
      remoteDataSource: locator<AppointmentsRemoteDataSource>(),
      networkInfo: locator(),
    ),
  );

  locator.registerFactory<AppointmentsBloc>(
    () => AppointmentsBloc(
      repository: locator<AppointmentRepositoryImpl>(),
    ),
  );
}
