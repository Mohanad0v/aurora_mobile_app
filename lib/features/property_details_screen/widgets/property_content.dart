import 'package:aurora_app/features/property_details_screen/widgets/property_details_header.dart';
import 'package:flutter/material.dart';
import '../data/models/property_details_model.dart';
import '../data/models/review_model.dart';
import 'review_list.dart';
import 'review_form.dart';

class PropertyContent extends StatelessWidget {
  final PropertyDetailsModel property;
  final List<ReviewModel> reviews;
  final bool isLoadingReviews;
  final TextEditingController reviewController;
  final void Function(double) onRatingChanged;
  final VoidCallback onSubmit;
  final double currentRating;
  final VoidCallback onSchedulePressed;

  const PropertyContent({
    super.key,
    required this.property,
    required this.reviews,
    required this.isLoadingReviews,
    required this.reviewController,
    required this.onRatingChanged,
    required this.onSubmit,
    required this.currentRating,
    required this.onSchedulePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PropertyDetailsHeader(
            property: property,
            onSchedulePressed: onSchedulePressed,
          ),
          const SizedBox(height: 24),

          const SizedBox(height: 24),
          // Reviews section remains
          isLoadingReviews
              ? const Center(child: CircularProgressIndicator())
              : ReviewList(reviews: reviews),
          const SizedBox(height: 24),
          // Review form remains
          ReviewForm(
            reviewController: reviewController,
            onRatingChanged: onRatingChanged,
            onSubmit: onSubmit,
            currentRating: currentRating,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}