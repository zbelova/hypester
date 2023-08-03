import 'package:hive/hive.dart';
import 'package:hypester/hive/post_local_dto.dart';

//класс дата сорса для хранения в hive
class PostsLocalDataSource {
  static const String _boxName = 'box_with_posts';

  final Future<Box<RedditPostLocalDto>> _postsBox =
  Hive.openBox<RedditPostLocalDto>(_boxName);

  //поменяла на add,так как добавляю только новый пост, не перезаписывая всю базу
  Future<void> add(final RedditPostLocalDto post) async {
    final box = await _postsBox;
    await box.add(post);
  }

  Future<List<RedditPostLocalDto>> getAll() async {
    final box = await _postsBox;
    final List<RedditPostLocalDto> values = box.isNotEmpty ? box.values.toList() : [];

    return values;
  }
}
