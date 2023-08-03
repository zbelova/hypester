import 'package:hive/hive.dart';
import 'package:hypester/hive/subreddit_local_dto.dart';

class SubredditsLocalDataSource {
  static const String _boxName = 'box_with_subreddits';

  final Future<Box<SubredditLocalDto>> _subredditsBox =
  Hive.openBox<SubredditLocalDto>(_boxName);

  Future<void> add(final SubredditLocalDto subreddit) async {
    final box = await _subredditsBox;
    await box.add(subreddit);
  }

  Future<List<SubredditLocalDto>> getAll() async {
    final box = await _subredditsBox;
    final List<SubredditLocalDto> values = box.isNotEmpty ? box.values.toList() : [];
    return values;
  }

  void delete(SubredditLocalDto subreddit) {
    final box = Hive.box<SubredditLocalDto>(_boxName);
    box.delete(subreddit.key);
  }
}