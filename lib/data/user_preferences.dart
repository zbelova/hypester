import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';


class UserPreferences {
  //создание переменной для сохранения preferences
  static SharedPreferences? _preferences;

  //инициализация preferences
  Future init() async => _preferences = await SharedPreferences.getInstance();

  //функция очистки сохраненных данных пользователя - вызывать если надо сбросить данные
  Future clear() async => _preferences?.clear();

  Future<void> setDeviceId() async {
    String? key = _preferences?.getString('api_key');

    // Проверка, был ли ключ уже создан или нет
    if (key == null) {
      // Генерация нового ключа
      key = generateDeviceIDKey();

      // Сохранение ключа в пользовательских настройках
      await _preferences?.setString('api_key', key);
    }

  }

  String? getDeviceId() {
    setDeviceId();
    var key= _preferences?.getString('api_key');
    return key;
  }

  String generateDeviceIDKey() {
    // Генерация уникального ключа
    var uuid = Uuid();
    return 'hypester_${uuid.v4()}';
  }

  List<String> getKeywords() {
    //return _preferences?.getStringList('keywords') ?? [];
    //TODO убрать тестовые данные
    return ['Game of Thrones', 'Apple'];
  }

  Future<void> setKeywords(List<String> keywords) async {
    await _preferences?.setStringList('keywords', keywords);
  }

  int getRedditLikesFilter() {
    return _preferences?.getInt('reddit_likes_filter') ?? 0;
  }

  Future<void> setRedditLikesFilter(int filter) async {
    await _preferences?.setInt('reddit_likes_filter', filter);
  }

  int getRedditViewsFilter() {
    return _preferences?.getInt('reddit_views_filter') ?? 0;
  }

  Future<void> setRedditViewsFilter(int filter) async {
    await _preferences?.setInt('reddit_views_filter', filter);
  }
}
