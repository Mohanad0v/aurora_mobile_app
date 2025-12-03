import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNews extends NewsEvent {
  final int page;

  const LoadNews({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class LoadNewsById extends NewsEvent {
  final String id;

  const LoadNewsById(this.id);

  @override
  List<Object?> get props => [id];
}

