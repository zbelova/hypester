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
    print(key);
    return key;
  }

  String generateDeviceIDKey() {
    // Генерация уникального ключа
    var uuid = Uuid();
    return 'hypester_${uuid.v4()}';

    // В этом примере мы просто используем текущую дату и время в качестве ключа
    // DateTime now = DateTime.now();
    // return now.toString();
  }
}
