part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Article> newlist;
  NewsLoaded({required this.newlist});
  @override
  List<Object> get props => [newlist];
}

class NewsFailed extends NewsState {}
