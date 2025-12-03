import 'package:aurora_app/features/property_details_screen/state/property_details_bloc.dart';
import 'package:aurora_app/features/property_details_screen/state/property_details_event.dart';
import 'package:aurora_app/features/property_details_screen/state/property_details_state.dart';
import 'package:aurora_app/features/property_details_screen/widgets/property_content.dart';
import 'package:aurora_app/features/property_details_screen/widgets/property_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/config/theme/src/colors.dart';
import '../appointments/presentation/state/appointments_bloc.dart';
import '../appointments/presentation/state/appointments_event.dart';
import '../appointments/presentation/widgets/schedule_appointment_dialog.dart';
import '../auth/presentation/state/auth_bloc.dart';
import 'data/models/add_review_params.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String propertyId;
  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  late final PageController _pageController;
  final TextEditingController _reviewController = TextEditingController();
  double _reviewRating = 0.0;
  late final String _userId;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    final authState = context.read<AuthBloc>().state;
    _userId = authState is AuthAuthenticated ? authState.user.id : '';

    final propertyBloc = context.read<PropertyDetailsBloc>();
    propertyBloc.add(FetchPropertyDetails(widget.propertyId));
    propertyBloc.add(FetchPropertyReviews(widget.propertyId));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview(BuildContext context) {
    final comment = _reviewController.text.trim();
    if (_reviewRating == 0 || comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('pleaseFillAllFields'.tr())),
      );
      return;
    }

    context.read<PropertyDetailsBloc>().add(
      AddPropertyReview(
        AddReviewParams(
          userId: _userId,
          propertyId: widget.propertyId,
          rating: _reviewRating.toInt(),
          comment: comment,
        ),
      ),
    );

    _reviewController.clear();
    setState(() => _reviewRating = 0.0);
  }

  void _openScheduleDialog(BuildContext context) {
    final appointmentsBloc = context.read<AppointmentsBloc>();

    appointmentsBloc.add(InitializeScheduleAppointment(propertyId: widget.propertyId));

    showDialog(
      context: context,
      builder: (_) => ScheduleAppointmentDialog(propertyId: widget.propertyId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<PropertyDetailsBloc, PropertyDetailsState>(
        listener: (context, state) {
          if (!state.isAddingReview && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoadingDetails && state.propertyDetails == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.propertyDetails == null) {
            return Center(child: Text(state.error!));
          }

          final property = state.propertyDetails;
          if (property == null) {
            return Center(child: Text("Property not found".tr()));
          }

          return CustomScrollView(
            slivers: [
              PropertySliverAppBar(
                property: property,
                pageController: _pageController,
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: PropertyContent(
                    property: property,
                    reviews: state.reviews,
                    isLoadingReviews: state.isLoadingReviews,
                    reviewController: _reviewController,
                    onRatingChanged: (rating) =>
                        setState(() => _reviewRating = rating),
                    onSubmit: () => _submitReview(context),
                    currentRating: _reviewRating,
                    onSchedulePressed: () => _openScheduleDialog(context),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
