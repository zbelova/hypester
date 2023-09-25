
//абстрактный класс всех датасорсов
import '../../models/post_model.dart';

abstract class DataSource {
  //возвращает список постов для главной по всем ключевым словам
  // Future<List<Post>> getAll() async {
  //   return [];
  // }

  //возвращает список постов для конкретного ключевого слова, то есть для одной ленты
  Future<List<Post>> getByKeyword(String keyword) async {
    return [];
  }
}