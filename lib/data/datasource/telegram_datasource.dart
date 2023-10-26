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
  var parser = await Chaleno().load('https://www.google.com/search?q=site:t.me+${feedFilters.keyword}&tbs=qdr:w'
      );
    //get all url from google search
    var i = 0;
    var results = parser!.getElementsByTagName('a');
    for (var result in results!) {
      if (result.href!.contains('https://t.me/s/')) {
        var channel = extractTelegramChannel(result.href!);
        if (channel != '' && !channels.contains(channel)) {
          if (i++ < 5) {
            channels.add(channel);
            // ´
            // var results2 = parser2!.getElementsByClassName('time');
            // if(isWithinSevenDays(results2[0].attr('datetime')!)) {
            //
            // }
            posts.add(Post(
              title: channel,
              body: '',
              id: channel,
              imageUrl: '',
              date: DateTime.now(),
              sourceName: 'Telegram',
              views: 0,
              linkToOriginal: 'https://t.me/s/$channel',
              //relinkUrl: 'https://t.me/s/$channel',
              channel: channel,
              isGallery: false,
              videoUrl: '',
            ));
          }
        }
      }
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

