import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/theme/src/colors.dart';
import '../../../core/widgets/logo_widget.dart';
import '../../auth/presentation/state/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Trigger auth status check after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthCheckStatus());
    });
  }

  Future<void> _navigateBasedOnState(AuthState state) async {
    // Wait for the full animation to finish
    await Future.delayed(const Duration(milliseconds: 2600));

    if (!mounted) return;

    if (state is AuthAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      await Future.delayed(const Duration(milliseconds: 2600));
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = size.width * 0.22;
    final titleFontSize = size.width * 0.09;
    final subtitleFontSize = size.width * 0.04;
    final spacing = size.height * 0.025;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) => _navigateBasedOnState(state),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/hero_bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInDownBig(
                    duration: const Duration(milliseconds: 1500),
                    child: Container(
                      width: logoSize,
                      height: logoSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.width * 0.05),
                      ),
                      child: const LogoWidget(),
                    ),
                  ),
                  SizedBox(height: spacing),
                  FadeInUpBig(
                    duration: const Duration(milliseconds: 1000),
                    child: Text(
                      'appTitle'.tr(),
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  FadeInUpBig(
                    duration: const Duration(milliseconds: 1000),
                    child: Text(
                      'discoverPerfectHome'.tr(),
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
