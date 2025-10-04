import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/config/theme/src/colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/helper_functions/dialog_utils.dart';
import 'widgets/blog_post_card.dart';
import '../state/news_bloc.dart';
import '../state/news_event.dart';
import '../state/news_state.dart';
import 'package:shimmer/shimmer.dart';
import 'news_details_screen.dart'; // import your details screen

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  Future<void> _refreshNews() async {
    context.read<NewsBloc>().add(const LoadNews());
  }

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(const LoadNews());
  }

  void _openNewsDetails(String newsId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => NewsBloc(repository: context.read<NewsBloc>().repository)..add(LoadNewsById(newsId)),
          child: NewsDetailsScreen(newsId: newsId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: BlocConsumer<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is NewsError) {
            DialogUtils.showAlertDialog(
              context,
              title: 'Error',
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is NewsLoading) {
            return _buildShimmerLoading();
          } else if (state is NewsLoaded) {
            if (state.news.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: _refreshNews,
              color: AppColors.auroraBluePrimary,
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0).copyWith(bottom: 16.0),
                itemCount: state.news.length,
                itemBuilder: (context, index) {
                  final post = state.news[index];
                  return GestureDetector(
                    onTap: () => _openNewsDetails(post.id),
                    child: AnimatedPadding(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: BlogPostCard(post: post),
                    ),
                  );
                },
              ),
            );
          } else if (state is NewsError) {
            return _buildErrorState(state.message);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: AppColors.gray100,
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: AppColors.gray200,
            highlightColor: AppColors.gray100,
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: Container(color: AppColors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'noArticlesFound'.tr(),
        style: const TextStyle(color: AppColors.gray600, fontSize: 16),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.error, fontSize: 16),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'retry'.tr(),
            onPressed: () => context.read<NewsBloc>().add(const LoadNews()),
            gradient: AppColors.auroraGradientPrimary,
          ),
        ],
      ),
    );
  }
}
