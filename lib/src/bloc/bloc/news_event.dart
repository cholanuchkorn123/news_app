part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
}

class Neweventstart extends NewsEvent {
  final String country;
  final String keyword;
  Neweventstart({this.country = 'us', this.keyword = ''});
  @override
  List<Object> get props => [country, keyword];
}
