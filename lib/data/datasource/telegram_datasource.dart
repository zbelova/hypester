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

                // print('Text: $text');
                // print('Views: $views');
                // print(dateElement!.attr('datetime'));
                // print('Date: ${isWithinSevenDays(dateElement.attr('datetime')!)}');
                if (isWithinSevenDays(dateElement!.attr('datetime')!)) {
                  posts.add(Post(
                    body: text,
                    id: channel,
                    //imageUrl: '',
                    date: DateTime.parse(dateElement.attr('datetime')!),
                    sourceName: 'Telegram',
                    views: views != null ? int.parse(views) : 0,
                    linkToOriginal: 'https://t.me/s/$channel',
                    //relinkUrl: 'https://t.me/s/$channel',
                    channel: channel,
                    isGallery: false,
                    videoUrl: '',
                    isHtml: true,
                  ));
                }
              }
              // var results2 = parser2!.getElementsByClassName('time');
              // if(isWithinSevenDays(results2[0].attr('datetime')!)) {
              //
              // }
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
