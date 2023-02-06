import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_application/src/modal/article.dart';
import 'package:news_application/src/services/newapi.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsLoading()) {
    on<Neweventstart>((event, emit) async {
      final service = Apiservices();

      try {
        NewsLoading();
        List<Article> newlist;
  
        if (event.keyword != '') {
          newlist = await service.getBysearch(event.keyword);
          emit(NewsLoaded(newlist: newlist));
        } else {
          newlist = await service.getNewsdata(event.country);
        }

        emit(NewsLoaded(newlist: newlist));
      } catch (e) {
        print(e);
        NewsFailed();
      }
    });
  }
}
