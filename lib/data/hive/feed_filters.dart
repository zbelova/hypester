import 'package:hive/hive.dart';

//локальная модель для хранения в hive
part 'feed_filters.g.dart';

@HiveType(typeId: 2)
class FeedFilters extends HiveObject {
  @HiveField(0)
  final String keyword;
  @HiveField(1)
  final int redditLikesFilter;
  @HiveField(2)
  final bool searchInSubreddits;
  @HiveField(3)
  final int vkLikesFilter;
  @HiveField(4)
  final int vkViewsFilter;
  @HiveField(5)
  final int youtubeLikesFilter;
  @HiveField(6)
  final int youtubeViewsFilter;
  @HiveField(7)
  final bool searchInChannels;
  @HiveField(8)
  final int telegramViewsFilter;
  @HiveField(9)
  final int instagramLikesFilter;
  @HiveField(10)
  final int instagramViewsFilter;

  FeedFilters({
    required this.keyword,
    this.redditLikesFilter = 0,
    this.searchInSubreddits = false,
    this.vkLikesFilter = 0,
    this.vkViewsFilter = 0,
    this.youtubeLikesFilter = 0,
    this.youtubeViewsFilter = 0,
    this.searchInChannels = false,
    this.telegramViewsFilter = 0,
    this.instagramLikesFilter = 0,
    this.instagramViewsFilter = 0,
  });

}