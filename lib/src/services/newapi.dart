import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:news_application/src/modal/article.dart';

class Apiservices {
  final Dio dio = Dio();
  final String baseUrl = 'https://newsapi.org/v2/';
  final String apiKey = 'your-apikey';
  Future<List<Article>> getNewsdata(String country) async {
    try {
      final response = await dio.get(
          '${baseUrl}top-headlines?country=${country.toLowerCase()}&apiKey=$apiKey');

      List<dynamic> body = response.data['articles'];
      List<Article> articles =
          body.map((item) => Article.fromJson(item)).toList();

      return articles;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Article>> getBysearch(String keyword) async {
      
    try {
      final response = await dio.get('${baseUrl}everything?q=$keyword&apiKey=$apiKey');
   
      List<dynamic> body = response.data['articles'];
      List<Article> articles =
          body.map((item) => Article.fromJson(item)).toList();

      return articles;
    } catch (e) {
      throw Exception(e);
    }
  }
}
