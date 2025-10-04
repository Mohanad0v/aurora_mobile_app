import 'package:equatable/equatable.dart';
import '../../data/models/news_model.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class NewsInitial extends NewsState {
  const NewsInitial();
}

/// Loading state
class NewsLoading extends NewsState {
  const NewsLoading();
}

/// Loaded state for list of news
class NewsLoaded extends NewsState {
  final List<NewsModel> news;
  const NewsLoaded(this.news);

  @override
  List<Object?> get props => [news];
}

/// Loaded state for a single news item
class NewsLoadedById extends NewsState {
  final NewsModel news;
  const NewsLoadedById(this.news);

  @override
  List<Object?> get props => [news];
}

/// Error state
class NewsError extends NewsState {
  final String message;
  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}
