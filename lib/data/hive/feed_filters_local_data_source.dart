

import 'package:hive/hive.dart';

import 'feed_filters.dart';

class FeedFiltersLocalDataSource {
  static const String _boxName = 'box_with_posts';

  final Future<Box<FeedFilters>> _feedFiltersBox =
  Hive.openBox<FeedFilters>(_boxName);

  Future<void> add(final FeedFilters feedFilters) async {
    final box = await _feedFiltersBox;
    await box.add(feedFilters);
  }

 Future<FeedFilters> get(String keyword) async{
   final box = await _feedFiltersBox;
   final FeedFilters feedFilters = box.values.firstWhere((element) => element.keyword == keyword);
   return feedFilters;
 }

 Future<void> edit(FeedFilters feedFilters) async {
    final box = await _feedFiltersBox;
    final index = box.values.toList().indexWhere((element) => element.keyword == feedFilters.keyword);
    await box.putAt(index, feedFilters);
 }

 Future<void> delete(String keyword) async {
    final box = await _feedFiltersBox;
    final index = box.values.toList().indexWhere((element) => element.keyword == keyword);
    await box.deleteAt(index);
 }
}
