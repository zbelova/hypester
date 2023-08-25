class Post {
  final String title;
  final String? body;
  final String id;
  final String? imageUrl;
  final DateTime date;
  final String source;
  final int views;
  final String linkUrl;
  final String likes;
  final String channel;

  Post({
    required this.title,
    this.body,
    required this.id,
    this.imageUrl,
    required this.date,
    required this.source,
    required this.views,
    required this.linkUrl,
    required this.likes,
    required this.channel,
  });
}