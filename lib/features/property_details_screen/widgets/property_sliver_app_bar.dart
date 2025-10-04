import 'package:flutter/material.dart';
import '../../../../../core/config/theme/src/colors.dart';
import '../../../../../core/widgets/image_with_fallback.dart';
import '../data/models/property_details_model.dart';

class PropertySliverAppBar extends StatefulWidget {
  final PropertyDetailsModel property;
  final PageController pageController;

  const PropertySliverAppBar({
    super.key,
    required this.property,
    required this.pageController,
  });

  @override
  State<PropertySliverAppBar> createState() => _PropertySliverAppBarState();
}

class _PropertySliverAppBarState extends State<PropertySliverAppBar> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.white,
      expandedHeight: MediaQuery.of(context).size.height * 0.35,
      pinned: true,
      leading: _buildBackButton(context),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              controller: widget.pageController,
              itemCount: widget.property.fullImageUrls.length,
              onPageChanged: (page) => setState(() => _currentPage = page),
              itemBuilder: (_, index) => ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: ImageWithFallback(
                  imageUrl: widget.property.fullImageUrls[index],
                  boxFit: BoxFit.cover,
                ),
              ),
            ),
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6),
          ],
        ),
        child: const Icon(Icons.arrow_back, color: AppColors.gray800),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      bottom: 12,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.property.fullImageUrls.length, (index) {
          final isActive = _currentPage == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 12 : 8,
            height: isActive ? 12 : 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.white
                  : AppColors.white.withOpacity(0.5),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
