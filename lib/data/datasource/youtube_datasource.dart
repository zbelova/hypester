//реализация датасорса для реддита
//для каждого источника отдельный класс наследник от DataSource
import 'dart:async';
import 'package:chaleno/chaleno.dart';

import 'package:hypester/data/hive/feed_filters.dart';
import 'package:hypester/data/user_preferences.dart';

import '../models/post_model.dart';
import 'abstract_datasource.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeDataSource extends DataSource {
  SearchClient client = SearchClient(YoutubeHttpClient());

  //возвращает список постов по всем ключевым словам
  @override
  Future<List<Post>> getByKeyword(FeedFilters feedFilters) async {
    List<Post> posts = [];
    List<String> urls = [];
    try {
      var result = await client.search(feedFilters.keyword, filter: UploadDateFilter.today);
      for (var video in result) {
        if (video.engagement.viewCount > feedFilters.youtubeViewsFilter) {
          if((checkForNsfwKeywords(video.title) || checkForNsfwKeywords(video.description)) && !UserPreferences().getNSFWActive()) continue;
          posts.add(Post(
            title: video.title,
            body: video.description,
            id: video.id.value,
            imageUrl: video.thumbnails.highResUrl,
            date: video.uploadDate ?? DateTime.now(),
            sourceName: 'Youtube',
            views: video.engagement.viewCount,
            linkToOriginal: video.url,
            relinkUrl: video.url,
            channel: video.author,
            isGallery: false,
            videoUrl: video.url,
          ));
        }
      }
      //парсер поисковой страницы гугла
      // var parser = await Chaleno().load('https://www.google.com/search?q=youtube+${feedFilters.keyword}&tbm=vid&tbs=qdr:d');
      // //get all url from google search
      // var i = 0;
      // var results = parser!.getElementsByTagName('a');
      // for (var result in results!) {
      //   if (result.href!.contains('https://www.youtube.com/watch%3Fv%3D')) {
      //     var url = extractYouTubeLink(result.href);
      //     if (url != '' && !urls.contains(url)) {
      //       if (i++ < 5) {
      //         urls.add(url);
      //         var yt = YoutubeExplode();
      //         var video = await yt.videos.get(url);
      //         if (video.engagement.viewCount > feedFilters.youtubeViewsFilter) {
      //
      //           posts.add(Post(
      //             title: video.title,
      //             body: video.description,
      //             id: video.id.value,
      //             imageUrl: video.thumbnails.highResUrl,
      //             date: video.publishDate!,
      //             sourceName: 'Youtube',
      //             views: video.engagement.viewCount,
      //             linkToOriginal: url,
      //             relinkUrl: url,
      //             channel: video.author,
      //             isGallery: false,
      //             videoUrl: url,
      //           ));
      //         }
      //       }
      //     }
      //   }
      // }
    } catch (e) {
      print(e);
    }

    return posts;
  }
}

String extractYouTubeLink(String? address) {
  // Ищем индекс первого вхождения "watch?v="
  final int startIndex = address!.indexOf('watch%3Fv%3D');

  // Если индекс найден
  if (startIndex != -1) {
    // Получаем подстроку, начиная с индекса "watch?v=" плюс длина "watch?v="
    final String subString = address.substring(startIndex + 12);
    // Ищем индекс первого вхождения символа "&"
    final int endIndex = subString.indexOf("&");

    // Если индекс найден
    if (endIndex != -1) {
      // Получаем подстроку, начиная с индекса 0 и длиной до индекса символа "&"
      final String finalString = subString.substring(0, endIndex);

      // Возвращаем конечную ссылку
      return "https://www.youtube.com/watch?v=$finalString";
    }
  }
  return '';
}

bool checkForNsfwKeywords(String text) {
  List<String> nsfwKeywords = [
    'sex',
    'porn',
    'gore',
    'nude',
    'naked',
    'nsfw',
    'xxx',
    '18+',
    'nsfl',
    'nsfp',
    'nsfwl',
    'nsfwp',
    'suicide',
    'lesbian',
    'gay',
    'hentai',
    'xnxx',
    'jav',
    'bokep',
    'dick',
    'fuck',
    'darknet',

  ]; // Здесь вы можете добавить любые другие NSFW ключевые слова

  // Преобразуем текст в нижний регистр для регистронезависимого сравнения
  String lowerCaseText = text.toLowerCase();

  // Проверяем, содержит ли текст NSFW ключевые слова
  for (String keyword in nsfwKeywords) {
    if (lowerCaseText.contains(keyword)) {
      return true;
    }
  }
  return false;
}
