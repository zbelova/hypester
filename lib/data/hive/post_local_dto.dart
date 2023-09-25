import 'package:hive/hive.dart';

//локальная модель для хранения в hive
part 'post_local_dto.g.dart';

@HiveType(typeId: 0)
class RedditPostLocalDto extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String? image;
  @HiveField(2)
  final String? body;
  @HiveField(3)
  final int likes;
  @HiveField(4)
  final String id;
  @HiveField(5)
  final String author; //ссылка на автора формируется по схеме https://www.reddit.com/user/author
  @HiveField(6)
  final String url;
  @HiveField(7)
  final String subreddit; //ссылка на саббреддит формируется по схеме https://www.reddit.com/r/subbreddit
  @HiveField(8)
  final DateTime date;

  RedditPostLocalDto( {
    required this.title,
    required this.id,
    required this.likes,
    required this.author,
    required this.url,
    required this.subreddit,
    required this.date,
    this.image,
    this.body,
  });
}
