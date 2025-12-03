import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme/src/colors.dart';
import '../../../../core/navigation/Routes.dart';
import '../../../appointments/presentation/widgets/user_appointments_bottom_sheet.dart';
import '../../../auth/presentation/state/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showAppointments(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return UserAppointmentsBottomSheet(
          title: 'Your Appointments'.tr(),
          userId: userId,
        );
      },
    );
  }

  void _navigateToContactUs(BuildContext context) {
    Navigator.pushNamed(context, Routes.contactUs);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userName = state is AuthAuthenticated ? state.user.name : '';
        final userEmail = state is AuthAuthenticated ? state.user.email : '';
        final userId = state is AuthAuthenticated ? state.user.id : '';

        return Scaffold(
          backgroundColor: AppColors.gray50,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: Text('Profile'.tr()),
            centerTitle: true,
            iconTheme: const IconThemeData(color: AppColors.gray800),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColors.gray200,
                      child: Icon(Icons.person, size: 40, color: AppColors.white),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName.isNotEmpty ? userName : 'Client Name',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail.isNotEmpty ? userEmail : 'client@email.com',
                          style: const TextStyle(color: AppColors.gray600),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.auroraBluePrimary,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: userId.isNotEmpty ? () => _showAppointments(context, userId) : null,
                  icon: const Icon(Icons.calendar_today, color: AppColors.white),
                  label: Text(
                    'View Appointments'.tr(),
                    style: const TextStyle(fontSize: 16, color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.auroraBluePrimary,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _navigateToContactUs(context),
                  icon: const Icon(Icons.contact_mail, color: AppColors.white),
                  label: Text(
                    'تواصل معنا'.tr(),
                    style: const TextStyle(fontSize: 16, color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 24),

                ListTile(
                  leading: const Icon(Icons.settings, color: AppColors.gray800),
                  title: Text('الإعدادات'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.warning),
                  title: Text(
                    'Logout'.tr(),
                    style: const TextStyle(color: AppColors.warning),
                  ),
                  onTap: () {
                    context.read<AuthBloc>().add(SignOutRequested());
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.auth,
                          (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
