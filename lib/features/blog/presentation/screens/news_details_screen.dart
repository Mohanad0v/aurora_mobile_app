import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme/src/colors.dart';
import '../../data/models/news_model.dart';
import '../state/news_bloc.dart';
import '../state/news_state.dart';

class NewsDetailsScreen extends StatelessWidget {
  final String newsId;

  const NewsDetailsScreen({super.key, required this.newsId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsError) {
            return Center(child: Text(state.message));
          } else if (state is NewsLoadedById) {
            final post = state.news;
            return _buildContent(context, post); // ✅ Pass context here
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// ✅ Accept both BuildContext and NewsModel
  Widget _buildContent(BuildContext context, NewsModel post) {
    final screenWidth = MediaQuery.of(context).size.width;
    final formattedDate = post.publishedAt.toLocal();
    final dateString =
        "${formattedDate.day}/${formattedDate.month}/${formattedDate.year}";
    final title = post.title.getLocalized();
    final content = post.content.getLocalized();
    final category = post.category;
    final author = post.author;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: screenWidth * 0.6,
          pinned: true,
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.gray800),
            onPressed: () => Navigator.pop(context),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.auroraBluePrimary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          category.toUpperCase(),
                          style: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.remove_red_eye,
                              size: 16, color: AppColors.white),
                          const SizedBox(width: 4),
                          Text('${post.views}',
                              style: const TextStyle(color: AppColors.white)),
                          const SizedBox(width: 16),
                          const Icon(Icons.calendar_today,
                              size: 16, color: AppColors.white),
                          const SizedBox(width: 4),
                          Text(dateString,
                              style: const TextStyle(color: AppColors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author info
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.auroraBluePrimary,
                      child: Text(author[0].toUpperCase(),
                          style: const TextStyle(color: AppColors.white)),
                    ),
                    const SizedBox(width: 8),
                    Text(author,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                // Content
                Text(
                  content,
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
                const SizedBox(height: 24),
                // Share buttons
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.link),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.facebook),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
