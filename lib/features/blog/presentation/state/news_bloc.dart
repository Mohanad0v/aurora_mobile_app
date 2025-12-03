import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo_impl/news_repo_impl.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepositoryImpl repository;

  NewsBloc({required this.repository}) : super(const NewsInitial()) {
    on<LoadNews>(_onLoadNews);
    on<LoadNewsById>(_onLoadNewsById);
  }

  Future<void> _onLoadNews(LoadNews event, Emitter<NewsState> emit) async {
    emit(const NewsLoading());

    final result = await repository.getNews(page: event.page);

    result.fold(
          (failure) => emit(NewsError(failure.message)),
          (newsList) => emit(NewsLoaded(newsList)),
    );
  }

  Future<void> _onLoadNewsById(LoadNewsById event, Emitter<NewsState> emit) async {
    emit(const NewsLoading());

    final result = await repository.getNewsById(event.id);

    result.fold(
          (failure) => emit(NewsError(failure.message)),
          (news) => emit(NewsLoadedById(news)),
    );
  }
}
