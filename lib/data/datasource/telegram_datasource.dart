import 'package:hypester/api_keys.dart';
import 'package:hypester/data/datasource/abstract_datasource.dart';
// import 'package:teledart/teledart.dart';
// import 'package:teledart/telegram.dart';
import '../hive/feed_filters.dart';
import '../models/post_model.dart';

class TelegramDataSource extends DataSource {
  @override
  Future<List<Post>> getByKeyword(FeedFilters feedFilters) async {
    List<Post> posts = [];

    // final username = (await Telegram(telegramBotToken).getMe()).username;
    // var teledart = TeleDart(telegramBotToken, Event(username!));



    return posts;
  }
}
