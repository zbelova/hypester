import 'package:hive/hive.dart';

//локальная модель для хранения в hive
part 'subreddit_local_dto.g.dart';

@HiveType(typeId: 1)
class SubredditLocalDto extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String icon;
  @HiveField(2)
  final String displayName;

  SubredditLocalDto({
   required this.title,
   required this.icon,
   required this.displayName,
  });
}
