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
    return _preferences?.getStringList('keywords') ?? [];
    //TODO убрать тестовые данные
    //return ['Trailer', 'Блины'];
  }

  Future<void> setKeywords(List<String> keywords) async {
    await _preferences?.setStringList('keywords', keywords);
  }

  Future<void> addKeyword(String keyword) async {
    List<String> keywords = getKeywords();
    keywords.add(keyword);
    await _preferences?.setStringList('keywords', keywords);
  }

  Future<void> deleteKeyword(String keyword) async {
    List<String> keywords = getKeywords();
    keywords.remove(keyword);
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

  Future<void> setVKToken(String token) async {
    await _preferences?.setString('vk_token', token);
  }

  String getVKToken() {
    return _preferences?.getString('vk_token') ?? '';
  }

  Future<void> setRedditActive(bool isActive) async {
    await _preferences?.setBool('reddit_active', isActive);
  }

  bool getRedditActive() {
    return _preferences?.getBool('reddit_active') ?? true;
  }

  Future<void> setVKActive(bool isActive) async {
    await _preferences?.setBool('vk_active', isActive);
  }

  bool getVKActive() {
    return _preferences?.getBool('vk_active') ?? false;
  }

  Future<void> setInstagramActive(bool isActive) async {
    await _preferences?.setBool('instagram_active', isActive);
  }

  bool getInstagramActive() {
    return _preferences?.getBool('instagram_active') ?? false;
  }

  Future<void> setYoutubeActive(bool isActive) async {
    await _preferences?.setBool('youtube_active', isActive);
  }

  bool getYoutubeActive() {
    return _preferences?.getBool('youtube_active') ?? true;
  }

  Future<void> setTelegramActive(bool isActive) async {
    await _preferences?.setBool('telegram_active', isActive);
  }

  bool getTelegramActive() {
    return _preferences?.getBool('telegram_active') ?? false;
  }

  Future<void> setNSFWActive(bool isActive) async {
    await _preferences?.setBool('nsfw_active', isActive);
  }

  getNSFWActive() {
    return _preferences?.getBool('nsfw_active') ?? false;
  }
}
