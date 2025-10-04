import 'package:aurora_app/core/injection/injection.dart';
import 'package:aurora_app/features/auth/presentation/screens/login_screen.dart';
import 'package:aurora_app/features/blog/presentation/state/news_bloc.dart';
import 'package:aurora_app/features/home/favorites/presentation/screen/favorites_screen/favorites_screen.dart';
import 'package:aurora_app/features/home/presentation/screens/home_screen/home_screen.dart';
import 'package:aurora_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:aurora_app/features/profile/presentation/widgets/contact_us_screen.dart';
import 'package:aurora_app/features/property_details_screen/property_details_Screen.dart';
import 'package:aurora_app/features/property_details_screen/state/property_details_bloc.dart';
import 'package:aurora_app/features/property_details_screen/state/property_details_event.dart';
import 'package:aurora_app/features/splash/screen/splash_screen.dart';
import 'package:aurora_app/features/splash/screen/widgets/custom_bottom_navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/config/theme/src/colors.dart';
import '../core/constants/enums.dart';
import '../core/navigation/Routes.dart';
import '../core/navigation/navigation_service.dart';
import 'appointments/presentation/state/appointments_bloc.dart';
import 'appointments/presentation/state/appointments_event.dart';
import 'auth/presentation/state/auth_bloc.dart';
import 'blog/presentation/screens/blog_Screen.dart';
import 'blog/presentation/state/news_event.dart';
import 'home/domain/repositories/realestate_repository.dart';
import 'home/favorites/presentation/screen/states/favorite_bloc.dart';
import 'home/favorites/presentation/screen/states/favorite_event.dart';
import 'home/presentation/screens/state/property_bloc.dart';
import 'home/presentation/screens/state/property_event.dart';
import 'listings_screen/listings_screen.dart';

class AuroraApp extends StatefulWidget {
  const AuroraApp({super.key});

  @override
  State<AuroraApp> createState() => _AuroraAppState();
}

class _AuroraAppState extends State<AuroraApp> {
  late final AuthBloc _authBloc;
  late final NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _authBloc = locator<AuthBloc>()..add(AuthCheckStatus());
    _navigationService = locator<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider<PropertyBloc>(
          create: (_) => locator<PropertyBloc>(),
        ),
        BlocProvider<NewsBloc>(
          create: (_) => locator<NewsBloc>()..add(LoadNews()),
        ),
        BlocProvider<FavoritesBloc>(
          create: (_) => locator<FavoritesBloc>(),
        ),
        BlocProvider<AppointmentsBloc>(
          create: (_) => locator<AppointmentsBloc>(),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // ✅ Dispatch property and favorites events only after authentication
            context.read<PropertyBloc>().add(FetchProperties());
            context.read<FavoritesBloc>().add(LoadFavorites(userId: state.user.id));
            context.read<AppointmentsBloc>().add(FetchUserAppointments(userId: state.user.id));
          }
        },
        child: MaterialApp(
          title: 'appTitle'.tr(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Tajawal',
            scaffoldBackgroundColor: AppColors.background,
          ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          navigatorKey: _navigationService.navigatorKey,
          // ✅ Use NavigationService
          initialRoute: Routes.splash,
          routes: {
            Routes.splash: (context) => SplashScreen(
                  authBloc: _authBloc,
                  onAuthenticated: () => Navigator.pushReplacementNamed(context, Routes.home),
                  onUnauthenticated: () => Navigator.pushReplacementNamed(context, Routes.auth),
                ),
            Routes.contactUs: (context) => const ContactUsScreen(),
            Routes.auth: (context) => const AuthScreen(),
            Routes.home: (context) => const MainScaffold(),
            Routes.listings: (context) => const PropertyListingsScreen(),
            Routes.favorites: (context) => const FavoritesScreen(),
            Routes.profile: (context) => const ProfileScreen(),
            Routes.details: (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              if (args == null || args is! String) {
                throw Exception('Expected propertyId as String for PropertyDetailsScreen');
              }
              return BlocProvider(
                create: (_) => locator<PropertyDetailsBloc>()
                  ..add(FetchPropertyDetails(args))
                  ..add(FetchPropertyReviews(args)),
                child: PropertyDetailsScreen(propertyId: args),
              );
            },
          },
        ),
      ),
    );
  }
}

/// Main Scaffold with persistent IndexedStack and bottom navigation
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold> {
  Screen _currentScreen = Screen.home;
  late final List<Widget> _screens;
  late final String _userId;

  @override
  void initState() {
    super.initState();

    // Fetch userId from AuthBloc
    final authState = context.read<AuthBloc>().state;
    _userId = authState is AuthAuthenticated ? authState.user.id : '';

    _screens = [
      const HomeScreen(),
      BlocProvider(
        create: (_) => locator<FavoritesBloc>()..add(LoadFavorites(userId: _userId)),
        child: const FavoritesScreen(),
      ),
      const BlogScreen(),
      const PropertyListingsScreen(),
      const ProfileScreen(),
    ];
  }

  void onNavigate(Screen screen) {
    setState(() => _currentScreen = screen);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isWide = screenSize.width > 600;

    return Scaffold(
      body: Center(
        child: Container(
          width: isWide ? 400 : screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(isWide ? 16.0 : 0.0),
            boxShadow: isWide
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isWide ? 16.0 : 0.0),
            child: Stack(
              children: [
                Positioned.fill(
                  child: IndexedStack(
                    index: _currentScreen.index.clamp(0, _screens.length - 1),
                    children: _screens,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CustomBottomNavigation(
                    currentScreen: _currentScreen,
                    onNavigate: onNavigate,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
