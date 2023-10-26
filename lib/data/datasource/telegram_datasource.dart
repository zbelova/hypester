import 'package:chaleno/chaleno.dart';
import 'package:hypester/api_keys.dart';
import 'package:hypester/data/datasource/abstract_datasource.dart';

import '../hive/feed_filters.dart';
import '../models/post_model.dart';

class TelegramDataSource extends DataSource {
  @override
  Future<List<Post>> getByKeyword(FeedFilters feedFilters) async {
    List<Post> posts = [];
    List<String> channels = [];
    List<String> urls = [];
    try {
      var parser = await Chaleno().load('https://www.google.com/search?q=site:t.me+${feedFilters.keyword}&tbs=qdr:w');
      //get all url from google search
      var i = 0;
      var results = parser!.getElementsByTagName('a');
      for (var result in results!) {
        if (result.href!.contains('https://t.me/s/')) {
          var channel = extractTelegramChannel(result.href!);
          if (channel != '' && !channels.contains(channel)) {
            if (i++ < 5) {
              channels.add(channel);
              var parser2 = await Chaleno().load('https://t.me/s/$channel');
              var messages = parser2!.getElementsByClassName('tgme_widget_message_bubble');
              for (var message in messages) {
                var textElement = message.querySelector('.tgme_widget_message_text');
                var text = textElement?.innerHTML;

                var viewsElement = message.querySelector('.tgme_widget_message_views');
                var views = viewsElement?.text;

                var dateElement = message.querySelector('.time');

                var imageElement = message.querySelector('.tgme_widget_message_photo_wrap');
                var image;
                if(imageElement != null){
                  image = extractImage(imageElement.attr('style')!);
                }

                var videoElement = message.querySelector('video');
                var video;
                var isVideo = false;
                if(videoElement != null){
                  video = videoElement.attr('src');
                  isVideo = true;
                  imageElement = message.querySelector('.tgme_widget_message_video_thumb');
                  image = extractImage(imageElement!.attr('style')!);
                }
                if (isWithinSevenDays(dateElement!.attr('datetime')!)) {
                  posts.add(Post(
                    body: text,
                    id: channel,
                    imageUrl: image,
                    date: DateTime.parse(dateElement.attr('datetime')!),
                    sourceName: 'Telegram',
                    views: views != null ? parseViews(views) : 0,
                    linkToOriginal: 'https://t.me/s/$channel',
                    channel: channel,
                    isGallery: false,
                    videoUrl: video,
                    isVideo: isVideo,
                    isHtml: true,
                  ));
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return posts;
  }
}

String extractTelegramChannel(String url) {
  var link = url.split('https://t.me/s/')[1];
  link = link.split('&')[0];
  link = link.split('?')[0];
  link = link.split('%')[0];
  return link;
}

bool isWithinSevenDays(String dateString) {
  DateTime currentDate = DateTime.now();
  DateTime parsedDate = DateTime.parse(dateString);

  Duration difference = parsedDate.difference(currentDate);

  return difference.inDays <= 7;
}

int parseViews(String viewsString) {
  // Удаление пробелов из строки
  viewsString = viewsString.replaceAll(' ', '');

  // Парсинг числа и суффикса
  int views;
  if (viewsString.contains('K')) {
    views = (double.parse(viewsString.replaceAll('K', '')) * 1000).round();
  } else {
    views = int.parse(viewsString);
  }

  return views;
}

String? extractImage(String text) {
  int startIndex = text.indexOf("url('") + 5;
  if (startIndex == -1) {
    return null;
  }

  // Поиск индекса конца ссылки
  int endIndex = text.indexOf("')", startIndex);
  if (endIndex == -1) {
    return null;
  }

  // Извлечение ссылки из строки
  String link = text.substring(startIndex, endIndex);
  return link;
}