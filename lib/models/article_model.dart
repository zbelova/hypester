class Article {
  String id;
  String title;
  String body;
  String source;
  String imageUrl;
  int views;
  DateTime date;
  String category;

  Article(
      {required this.id,
      required this.title,
      required this.body,
      required this.source,
      required this.imageUrl,
      required this.views,
      required this.date,
      required this.category});

  List<Article> articles = [];
}
