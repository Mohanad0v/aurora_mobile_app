import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/config/theme/src/colors.dart';
import '../../../../core/constants/app_url/app_url_strings.dart';
import '../state/auth_bloc.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_header.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/navigation/Routes.dart';
import '../../../../core/helper_functions/dialog_utils.dart';
import '../../data/models/login_params.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  bool _isSignUp = false;
  bool _showPassword = false;
  int _loginTapCount = 0;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _animCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  late final NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _navigationService = locator<NavigationService>();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _slideAnim = Tween(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
    );
    _fadeAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // Count taps for hidden Base URL dialog
    _loginTapCount++;
    if (_loginTapCount >= 7) {
      _loginTapCount = 0;
      _showBaseUrlDialog();
      return;
    }

    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        (_isSignUp && _nameController.text.isEmpty)) {
      DialogUtils.showAlertDialog(
        context,
        title: 'inputError'.tr(),
        message: 'fillAllRequiredFields'.tr(),
      );
      return;
    }

    final bloc = context.read<AuthBloc>();

    if (_isSignUp) {
      bloc.add(SignUpRequested(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ));
    } else {
      bloc.add(SignInRequested(
        loginParams: LoginParams(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      ));
    }
  }

  void _showBaseUrlDialog() {
    final _urlController = TextEditingController(text: AppUrls.baseUrl);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Set Base URL'),
        content: TextField(
          controller: _urlController,
          decoration: const InputDecoration(
            hintText: 'http://192.168.1.xxx:4000',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final url = _urlController.text.trim();
              if (url.isNotEmpty) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('baseUrl', url);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Base URL updated!')),
                );
                AppUrls.init(); // reload the new URL
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      resizeToAvoidBottomInset: false, // 🔥 Make sure keyboard pushes content safely
      backgroundColor: AppColors.gray50,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            DialogUtils.showLoadingDialog(context);
          } else if (state is AuthAuthenticated) {
            DialogUtils.dismissLoadingDialog(context);
            _navigationService.pushReplacementNamed(
              Routes.home,
              arguments: state.user,
            );
          } else if (state is AuthFailure) {
            DialogUtils.dismissLoadingDialog(context);
            DialogUtils.showAlertDialog(
              context,
              title: 'authenticationError'.tr(),
              message: state.message,
            );
          }
        },
        child: Stack(
          children: [
            // Fixed background
            Positioned.fill(
              child: Image.asset('assets/images/hero_bg.png', fit: BoxFit.cover),
            ),

            // Scrollable content
            Align(
              alignment: Alignment.center,
              child: SlideTransition(
                position: _slideAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AuthHeader(isSignUp: _isSignUp, screenWidth: screenWidth),
                        AuthForm(
                          isSignUp: _isSignUp,
                          showPassword: _showPassword,
                          togglePassword: () => setState(() => _showPassword = !_showPassword),
                          nameController: _nameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          onSubmit: _handleSubmit,
                          isArabic: isArabic,
                          toggleAuthMode: () => setState(() => _isSignUp = !_isSignUp),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'termsAndPrivacy'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: AppColors.gray500,
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
