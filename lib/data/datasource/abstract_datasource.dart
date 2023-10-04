
//абстрактный класс всех датасорсов
import 'package:hypester/data/hive/feed_filters.dart';

import '../models/post_model.dart';

abstract class DataSource {
  //возвращает список постов для главной по всем ключевым словам
  // Future<List<Post>> getAll() async {
  //   return [];
  // }

  //возвращает список постов для конкретного ключевого слова, то есть для одной ленты
  Future<List<Post>> getByKeyword(FeedFilters feedFilters) async {
    return [];
  }
}