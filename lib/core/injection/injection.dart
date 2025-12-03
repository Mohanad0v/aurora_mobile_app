import 'dart:developer';

import 'package:aurora_app/core/injection/src/appointments_inject.dart';
import 'package:aurora_app/core/injection/src/auth_injection.dart';
import 'package:aurora_app/core/injection/src/blog_injection.dart';
import 'package:aurora_app/core/injection/src/general_inject.dart';
import 'package:aurora_app/core/injection/src/home_injection.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> initInjection() async {
  await generalInject();
  await authInject();
  await homeInject();
  await blogInject();
  await appointmentsInject();
  log('HomeScreenWrapper: Injection finished');
}
