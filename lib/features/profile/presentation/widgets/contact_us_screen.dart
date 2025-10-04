// lib/features/contact_us/presentation/screens/contact_us_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/state/auth_bloc.dart';
import '../widgets/contact_form.dart';
import '../widgets/contact_hero.dart';
import '../widgets/contact_info.dart';
import '../../../../core/injection/injection.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      AuthBloc(authRepository: locator())..add(AuthCheckStatus()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تواصل معنا"),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              ContactHero(),
              SizedBox(height: 24),
              ContactForm(),
              SizedBox(height: 24),
            //  ContactInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
