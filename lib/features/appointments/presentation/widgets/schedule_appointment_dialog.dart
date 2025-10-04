import 'package:aurora_app/core/config/theme/src/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/schedule_appointment_params.dart';
import '../state/appointments_bloc.dart';
import '../state/appointments_event.dart';
import '../state/appointments_state.dart';

class ScheduleAppointmentDialog extends StatelessWidget {
  final String propertyId;

  const ScheduleAppointmentDialog({super.key, required this.propertyId});

  List<String> get timeSlots {
    final slots = <String>[];
    for (int h = 9; h <= 18; h++) {
      slots.add('${h.toString().padLeft(2, '0')}:00');
      if (h != 18) slots.add('${h.toString().padLeft(2, '0')}:30');
    }
    return slots;
  }

  bool _isPastToday(DateTime? date, String hhmm) {
    if (date == null) return false;
    final now = DateTime.now();
    final sameDay = DateTime(now.year, now.month, now.day) ==
        DateTime(date.year, date.month, date.day);
    if (!sameDay) return false;

    final parts = hhmm.split(':');
    return DateTime(now.year, now.month, now.day,
        int.parse(parts[0]), int.parse(parts[1]))
        .isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AppointmentsBloc>()
        ..add(InitializeScheduleAppointment(propertyId: propertyId)),
      child: BlocConsumer<AppointmentsBloc, AppointmentsState>(
        listener: (context, state) {
          if (state is ScheduleAppointmentState) {
            if (state.isSuccess) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم جدولة الزيارة بنجاح✅')));
            } else if (state.error != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error!)));
            }
          }
        },
        builder: (context, state) {
          if (state is! ScheduleAppointmentState) return const SizedBox.shrink();
          final loading = state.isSubmitting;

          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 600),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: state.step == 0
                          ? _buildStepDateTime(context, state, loading)
                          : _buildStepDetails(context, state, loading),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'جدولة موعد زيارة',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildStepDateTime(
      BuildContext context, ScheduleAppointmentState state, bool loading) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDatePicker(context, state, loading),
          const SizedBox(height: 12),
          _buildTimeDropdown(context, state, loading),
          const SizedBox(height: 12),
          _buildVisitTypeDropdown(context, state, loading),
          if (state.visitType == 'office_vr') ...[
            const SizedBox(height: 12),
            _buildVrCityInput(context, state, loading),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: loading ||
                state.selectedDate == null ||
                state.selectedTime == null
                ? null
                : () => context.read<AppointmentsBloc>().add(SetScheduleStep(1)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: AppColors.auroraBluePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('متابعة', style: TextStyle(color: Colors.white)),
          ),
        ],
      );

  Widget _buildStepDetails(
      BuildContext context, ScheduleAppointmentState state, bool loading) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(Icons.access_time, color: Colors.black),
            title: Text(
                "${DateFormat.yMMMMEEEEd('ar').format(state.selectedDate!)}, ${state.selectedTime}"),
            trailing: TextButton(
              onPressed: loading
                  ? null
                  : () => context.read<AppointmentsBloc>().add(SetScheduleStep(0)),
              child: const Text('تغيير'),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: (v) =>
                context.read<AppointmentsBloc>().add(UpdateScheduleNotes(v)),
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'ملاحظات إضافية (اختياري)',
              hintText: 'أي متطلبات خاصة أو أسئلة حول العقار...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: loading
                      ? null
                      : () => context.read<AppointmentsBloc>().add(SetScheduleStep(0)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('رجوع'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: loading
                      ? null
                      : () => context.read<AppointmentsBloc>().add(
                    SubmitScheduleAppointment(
                      ScheduleAppointmentParams(
                        propertyId: state.propertyId ?? propertyId,
                        date: state.selectedDate != null
                            ? DateFormat('yyyy-MM-dd')
                            .format(state.selectedDate!)
                            : '',
                        time: state.selectedTime ?? '',
                        visitType: state.visitType,
                        notes: state.notes,
                        vrCity: state.vrCity,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: AppColors.auroraBluePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('جدولة زيارة', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildDatePicker(
      BuildContext context, ScheduleAppointmentState state, bool loading) {
    return ListTile(
      leading: const Icon(Icons.calendar_today, color: Colors.black),
      title: const Text('اختر التاريخ'),
      subtitle: Text(state.selectedDate != null
          ? DateFormat.yMMMMd('ar').format(state.selectedDate!)
          : 'اختر تاريخًا (السبت/الأحد غير متاح)'),
      onTap: loading
          ? null
          : () async {
        // Ensure initialDate is selectable
        DateTime initialDate = DateTime.now();
        if (initialDate.weekday == DateTime.saturday) {
          initialDate = initialDate.add(const Duration(days: 2));
        } else if (initialDate.weekday == DateTime.sunday) {
          initialDate = initialDate.add(const Duration(days: 1));
        }

        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
          selectableDayPredicate: (d) =>
          d.weekday != DateTime.saturday &&
              d.weekday != DateTime.sunday,
          locale: const Locale('ar'),
        );

        if (picked != null) {
          context.read<AppointmentsBloc>().add(UpdateScheduleDate(picked));
        }
      },
    );
  }
  Widget _buildTimeDropdown(
      BuildContext context, ScheduleAppointmentState state, bool loading) =>
      InputDecorator(
        decoration: const InputDecoration(
            labelText: 'اختر الموعد', border: OutlineInputBorder()),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: state.selectedTime,
            isExpanded: true,
            hint: const Text('اختر موعداً'),
            items: timeSlots.map((t) {
              final disabled =
                  state.selectedDate == null || _isPastToday(state.selectedDate, t);
              return DropdownMenuItem<String>(
                value: t,
                enabled: !disabled,
                child: Opacity(opacity: disabled ? 0.4 : 1, child: Text(t)),
              );
            }).toList(),
            onChanged: loading
                ? null
                : (v) {
              if (v != null && !_isPastToday(state.selectedDate, v)) {
                context.read<AppointmentsBloc>().add(UpdateScheduleTime(v));
              }
            },
          ),
        ),
      );

  Widget _buildVisitTypeDropdown(
      BuildContext context, ScheduleAppointmentState state, bool loading) =>
      DropdownButtonFormField<String>(
        value: state.visitType,
        decoration: const InputDecoration(
            labelText: 'نوع الزيارة', border: OutlineInputBorder()),
        items: const [
          DropdownMenuItem(value: 'property', child: Text('في العقار')),
          DropdownMenuItem(value: 'online', child: Text('اجتماع أونلاين')),
          DropdownMenuItem(value: 'office_vr', child: Text('VR في المكتب')),
        ],
        onChanged: loading
            ? null
            : (v) => context
            .read<AppointmentsBloc>()
            .add(UpdateScheduleVisitType(v ?? 'property')),
      );

  Widget _buildVrCityInput(
      BuildContext context, ScheduleAppointmentState state, bool loading) =>
      TextField(
        decoration: const InputDecoration(
            labelText: 'اختر المدينة (VR)',
            border: OutlineInputBorder(),
            hintText: 'دمشق، حلب، ...'),
        onChanged: (v) =>
            context.read<AppointmentsBloc>().add(UpdateScheduleVrCity(v)),
      );
}
