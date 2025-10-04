import 'package:aurora_app/features/home/presentation/screens/home_screen/widgets/state_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../core/config/theme/src/colors.dart';

class StatsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> stats;

  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 800 ? 4 : screenWidth > 500 ? 3 : 2;
    final childAspectRatio = screenWidth > 500 ? 1.0 : 0.95;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'platformStatistics'.tr(),
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: AppColors.gray800,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final stat = stats[index];
            return StatCard(
              icon: stat['icon'] as IconData,
              value: stat['value'] as String,
              label: stat['label'] as String,
              gradient: stat['gradient'] as LinearGradient,
            );
          },
        ),
      ],
    );
  }
}
