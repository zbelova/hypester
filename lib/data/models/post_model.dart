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
  final bool isVideo;
  final String? relinkUrl; //если пост состоит из одной ссылки на другой сайт, как у реддита
  final bool isGallery;
  final List<String>? galleryUrls; //если пост состоит из галереи картинок, как у телеграма или реддита

  Post({
    this.videoUrl,
    this.title,
    this.body,
    required this.id,
    this.imageUrl,
    required this.date,
    required this.sourceName,
    this.views,
    required this.linkToOriginal,
    this.likes,
    this.channel,
    this.relinkUrl,
    this.galleryUrls,
    this.isGallery = false,
    this.isVideo = false
  });
}
