// features/appointments/data/data_source/appointments_remote_data_source.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/app_url/app_url_strings.dart';
import '../../../../core/networking/dio/dio_client.dart';
import '../models/appointment_model.dart';
import '../models/schedule_appointment_params.dart';

class AppointmentsRemoteDataSource {
  final DioClient dioClient;
  final Dio dio;

  const AppointmentsRemoteDataSource({
    required this.dioClient,
    required this.dio,
  });

  Future<List<AppointmentModel>> fetchUserAppointments() async {
    try {
      final response = await dio.get(AppUrls.getAppointmentsByUser);
      final data = response.data as Map<String, dynamic>?;
      if (data == null || data['appointments'] == null) return [];
      final list = data['appointments'] as List<dynamic>;
      return list.map((a) => AppointmentModel.fromJson(a as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to fetch appointments: $e');
    }
  }

  Future<void> scheduleAppointment(ScheduleAppointmentParams params) async {
    try {
      final res = await dioClient.post(
        url: AppUrls.scheduleAppointment,
        data: params.toJson(),
      );

      if (res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
        final data = res.data;
        if (data is Map<String, dynamic> && data.containsKey('success') && data['success'] != true) {
          throw Exception(data['message'] ?? 'Failed to schedule appointment');
        }
        return;
      }

      throw Exception('Failed to schedule appointment (status code ${res.statusCode})');
    } catch (e) {
      throw Exception('Failed to schedule appointment: $e');
    }
  }
}
