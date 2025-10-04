import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme/src/colors.dart';
import '../../../auth/presentation/state/auth_bloc.dart';
import '../state/appointments_bloc.dart';
import '../state/appointments_event.dart';
import '../state/appointments_state.dart'
    show AppointmentsError, AppointmentsLoaded, AppointmentsLoading, AppointmentsState;

class UserAppointmentsBottomSheet extends StatefulWidget {
  final String title;
  final String userId; // ✅ Add userId as a required parameter

  const UserAppointmentsBottomSheet({
    super.key,
    required this.title,
    required this.userId,
  });

  @override
  State<UserAppointmentsBottomSheet> createState() => _UserAppointmentsBottomSheetState();
}

class _UserAppointmentsBottomSheetState extends State<UserAppointmentsBottomSheet> {
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetched) {
      final bloc = context.read<AppointmentsBloc>();
      // Fetch appointments for this user
      bloc.add(FetchUserAppointments(userId: widget.userId));
      _hasFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {},
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2)),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.gray200,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(widget.title,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.gray800)),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: BlocBuilder<AppointmentsBloc, AppointmentsState>(
                        builder: (context, state) {
                          if (state is AppointmentsLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is AppointmentsLoaded) {
                            final appointments = state.appointments;
                            if (appointments.isEmpty) {
                              return Center(child: Text('No Appointments'.tr()));
                            }
                            return ListView.builder(
                              controller: controller,
                              itemCount: appointments.length,
                              itemBuilder: (_, index) {
                                final appt = appointments[index];
                                final property = appt.property;
                                final imageUrl = property.firstImageUrl.isNotEmpty
                                    ? property.firstImageUrl
                                    : null;
                                final title = property.title.ar ?? 'No Title';

                                return ListTile(
                                  leading: imageUrl != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : const Icon(Icons.home, size: 40),
                                  title: Text(title),
                                  subtitle: Text(
                                      '${appt.date.toLocal().toString().split(' ')[0]} • ${appt.time}'),
                                  trailing: Text(
                                    appt.status.tr(),
                                    style: TextStyle(
                                      color: appt.status == 'confirmed'
                                          ? Colors.green
                                          : (appt.status == 'pending' ? Colors.orange : Colors.red),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (state is AppointmentsError) {
                            return Center(child: Text(state.message));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
