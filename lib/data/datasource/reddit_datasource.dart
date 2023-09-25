//реализация датасорса для реддита
//для каждого источника отдельный класс наследник от DataSource
import 'package:draw/draw.dart';

import '../../api_keys.dart';
import '../../dev_screens/reddit_dev.dart';
import '../../models/post_model.dart';
import '../user_preferences.dart';
import 'abstract_datasource.dart';

class RedditDataSource extends DataSource {
  @override
  Future<List<Post>> getAll() async {
    List<Post> posts = [];
//достаем список ключевых слов, то есть всех лент пользователя
    final List<String> _keywords = UserPreferences().getKeywords();
//достаем фильтры
    final int _likesFilter = UserPreferences().getRedditLikesFilter();
    final int _viewsFilter = UserPreferences().getRedditViewsFilter();
//.. и дальше остальные фильтры, которые относятся к этому источнику

    var deviceID = UserPreferences().getDeviceId();
    const userAgent = 'hypester by carrot';
    //здесь иногда возникает ошибка, связанная с тем, что reddit не дает доступ к api. Причина неизвестна
    //надо ловить эксепшн
    final reddit = await Reddit.createUntrustedReadOnlyInstance(userAgent: userAgent, clientId: redditApiKey, deviceId: deviceID);

    reddit.subreddit('all').search('bitcoin').listen((event) {
      var data = event as Submission;
      //сравниваю пост из стрима с постами из hive
      //если поста нет в hive, то добавляю его в hive
      //функция firstWhereOrNull взята из пакета collection

      posts.add(
        Post(
          title: data.title,
          body: data.selftext,
          id: data.id!,
          imageUrl: urlIsImage(data.url.toString()) ? data.url.toString() : '',
          date: data.createdUtc,
          sourceName: data.subreddit.displayName,
          views: data.upvotes,
          linkToOriginal: data.url.toString(),
          likes: data.upvotes,
          channel: data.author,
          relinkUrl: data.url.toString(),
          videoUrl: data.url.toString(),
        ),
      );
    });

    /*
    Этот код понадобится, если придется подключаться по другому ключу reddit api. В настройках на реддите надо указать redirect http://localhost:8080
    final reddit = Reddit.createInstalledFlowInstance(userAgent: userAgent,
                                                        clientId: redditApiKey,);

      // Build the URL used for authentication. See `WebAuthenticator`
      // documentation for parameters.
      final auth_url = reddit.auth.url(['*'], 'hypester by carrot');

      // ...
      // Complete authentication at `auth_url` in the browser and retrieve
      // the `code` query parameter from the redirect URL.
      // ...

      // Assuming the `code` query parameter is stored in a variable
      // `auth_code`, we pass it to the `authorize` method in the
      // `WebAuthenticator`.
      await reddit.auth.authorize(auth_code);
     */

//возвращаем список постов для главной по всем ключевым словам в таком формате
    return posts;
  }

  @override
  Future<List<Post>> getByKeyword(String keyword) async {
    List<Post> posts = [];

//достаем фильтры
    final int _likesFilter = UserPreferences().getRedditLikesFilter();
    final int _viewsFilter = UserPreferences().getRedditViewsFilter();
//.. и дальше остальные фильтры, которые относятся к этому источнику
    var deviceID = UserPreferences().getDeviceId();
    const userAgent = 'hypester by carrot';
    //здесь иногда возникает ошибка, связанная с тем, что reddit не дает доступ к api. Причина неизвестна
    //надо ловить эксепшн
    final reddit = await Reddit.createUntrustedReadOnlyInstance(userAgent: userAgent, clientId: redditApiKey, deviceId: deviceID);

    reddit.subreddit('all').search(keyword).listen((event) {
      var data = event as Submission;

      posts.add(
        Post(
          title: data.title,
          body: data.selftext,
          id: data.id!,
          imageUrl: urlIsImage(data.url.toString()) ? data.url.toString() : '',
          date: data.createdUtc,
          sourceName: data.subreddit.displayName,
          views: data.upvotes,
          linkToOriginal: data.url.toString(),
          likes: data.upvotes,
          channel: data.author,
          relinkUrl: data.url.toString(),
          videoUrl: data.url.toString(),
        ),
      );
    });
    return posts;
  }
}