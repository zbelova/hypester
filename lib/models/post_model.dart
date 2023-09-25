class Post {
  final String? title;
  final String? body;
  final String id;
  final String? imageUrl;
  final DateTime date;
  final String sourceName; //название источника типа Reddit, Telegram
  final int? views;
  final String? linkToOriginal; //ссылка на оригинальный пост у источника
  final int? likes;
  final String? channel;
  final String? videoUrl;
  final String? relinkUrl; //если пост состоит из одной ссылки на другой сайт, как у реддита

  Post({
    required this.videoUrl,
    required this.title,
    required this.body,
    required this.id,
    required this.imageUrl,
    required this.date,
    required this.sourceName,
    required this.views,
    required this.linkToOriginal,
    required this.likes,
    required this.channel,
    required this.relinkUrl,
  });
}