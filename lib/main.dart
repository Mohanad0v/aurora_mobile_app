import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'core/injection/injection.dart';
import 'core/injection/src/depndecy_injection.dart';
import 'features/aurora_app.dart';
/////////change the local host for real devices///////////////
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
   await initInjection();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'),Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const AuroraApp(),
    ),
  );
}
