import 'package:news_application/src/modal/source.dart';

class Article {
  Article({
    required this.source,
    this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  final Source source;
  final String? author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String? content;

  factory Article.fromJson(Map<dynamic, dynamic> json) => Article(
        source: Source.fromJson(json["source"]),
        author: json["author"].toString(),
        title: json["title"].toString(),
        description: json["description"].toString(),
        url: json["url"].toString(),
        urlToImage: json["urlToImage"].toString(),
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"].toString(),
      );
}
