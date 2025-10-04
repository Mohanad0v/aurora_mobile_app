import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/config/theme/src/colors.dart';
import '../../../core/widgets/logo_widget.dart';
import '../../auth/presentation/state/auth_bloc.dart';
import '../../../core/injection/injection.dart';
import '../../../core/navigation/Routes.dart';
import '../../../core/navigation/navigation_service.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onAuthenticated;
  final VoidCallback? onUnauthenticated;
  final AuthBloc authBloc;

  const SplashScreen({super.key, required this.authBloc, this.onAuthenticated, this.onUnauthenticated});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _animationFinished = false;
  AuthState? _authState;

  late final NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _navigationService = locator<NavigationService>();

    // Trigger auth check
    widget.authBloc.add(AuthCheckStatus());

    // Wait for animation duration
    Future.delayed(const Duration(milliseconds: 2600), () {
      _animationFinished = true;
      _navigateIfReady();
    });
  }

  void _navigateIfReady() {
    if (!_animationFinished || _authState == null || !mounted) return;

    if (_authState is AuthAuthenticated) {
      _navigationService.pushReplacementNamed(Routes.home);
    } else {
      _navigationService.pushReplacementNamed(Routes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = size.width * 0.22;
    final titleFontSize = size.width * 0.09;
    final subtitleFontSize = size.width * 0.04;
    final spacing = size.height * 0.025;

    return BlocListener<AuthBloc, AuthState>(
      bloc: widget.authBloc,
      listener: (context, state) {
        _authState = state;
        _navigateIfReady();
      },
      child: Scaffold(
        body: Stack(
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
                        fontSize: subtitleFontSize * 1.1,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.8,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
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
