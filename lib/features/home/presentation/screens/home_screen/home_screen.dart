import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/config/theme/src/colors.dart';
import '../../../../../core/constants/enums.dart';
import '../../../../../core/navigation/Routes.dart';
import '../../../../../core/widgets/filter_drawer.dart';
import '../../../../../core/injection/injection.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../aurora_app.dart';
import '../../../../auth/domain/entites/user_enntity.dart';
import '../../../../listings_screen/widgets/property_filters.dart';
import '../state/property_bloc.dart';
import '../state/property_event.dart';
import '../state/property_state.dart';
import 'widgets/header_scetion.dart';
import 'widgets/stats_grid.dart';
import 'widgets/features_grid.dart';
import 'widgets/featured_properties_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavigationService _navigationService = locator<NavigationService>();
  late final String _userId;

  final List<Map<String, dynamic>> _features = [];

  @override
  void initState() {
    super.initState();
    _features.addAll([
      {
        'icon': Icons.messenger_outline,
        'title': 'تواصل مباشر'.tr(),
        'description': 'احصل على ردود فورية من وكلائنا ذوي الخبرة عبر نظام الدردشة الفورية'.tr(),
        'gradient': AppColors.blueToCyanGradient,
      },
      {
        'icon': Icons.security,
        'title': 'عقارات موثوقة',
        'description': 'يتم فحص كل عقار بدقة والتحقق منه لضمان الجودة والمصداقية'.tr(),
        'gradient': AppColors.blueToCyanGradient,
      },
      {
        'icon': Icons.home_outlined,
        'title': 'الجودة أولاً',
        'description': 'نحافظ على معايير عالية لجميع العقارات. لضمان حصولك على أفضل قيمة.'.tr(),
        'gradient': AppColors.redToPinkGradient,
      },
      {
        'icon': Icons.person_2_outlined,
        'title': 'مناسب للعائلات',
        'description': 'اعثر على منازل تناسب احتياجات عائلتك وأسلوب حياتك تماما'.tr(),
        'gradient': AppColors.greenToTealGradient,
      },
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ModalRoute.of(context)?.settings.arguments as UserEntity?;
      _userId = user?.id ?? '';

      // Initial fetch
      context.read<PropertyBloc>().add(FetchProperties());
    });
  }

  void _onSearchPressed(String? initialQuery) {
    final mainScaffoldState = context.findAncestorStateOfType<MainScaffoldState>();
    if (mainScaffoldState == null) return;

    mainScaffoldState.onNavigate(Screen.listings);
  }

  /// Pull-to-refresh handler
  Future<void> _refreshProperties() async {
    context.read<PropertyBloc>().add(FetchProperties());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<PropertyBloc>(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.gray50,
          body: RefreshIndicator(
            onRefresh: _refreshProperties,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                    child: HeaderSection(
                      searchController: TextEditingController(),
                      selectedPropertyType: '',
                      onPropertyTypeSelected: (_) {},
                      onSearchPressed: () => _onSearchPressed(null),
                      onSearchTextChanged: (_) {},
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                  sliver: SliverToBoxAdapter(
                    child: BlocBuilder<PropertyBloc, PropertyState>(
                      builder: (context, state) {
                        return StatsGrid(
                          stats: [
                            {
                              'icon': Icons.home_outlined,
                              'value': state.totalProperties.toString(),
                              'label': 'totalProperties'.tr(),
                              'gradient': AppColors.blueToCyanGradient
                            },
                            {
                              'icon': Icons.handshake,
                              'value': state.completedDeals.toString(),
                              'label': 'الصفقات المنجزة'.tr(),
                              'gradient': AppColors.greenToTealGradient
                            },
                            {
                              'icon': Icons.remove_red_eye_outlined,
                              'value': state.totalViews.toString(),
                              'label': 'إجمالي مشاهدات العقارات'.tr(),
                              'gradient': AppColors.auroraGradientPrimary
                            },
                            {
                              'icon': Icons.star_outline,
                              'value': '4.9',
                              'label': 'متوسط التقييم'.tr(),
                              'gradient': AppColors.yellowToOrangeGradient
                            },
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                  sliver: SliverToBoxAdapter(child: FeaturesGrid(features: _features)),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                  sliver: SliverToBoxAdapter(
                    child: FeaturedPropertiesSection(
                      onViewAllPressed: () => _navigationService.pushNamed(Routes.listings),
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
