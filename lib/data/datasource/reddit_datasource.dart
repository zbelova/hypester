//реализация датасорса для реддита
//для каждого источника отдельный класс наследник от DataSource
import 'dart:async';
import 'package:draw/draw.dart';
import '../../api_keys.dart';
import '../../dev_screens/reddit_dev.dart';
import '../../globals.dart';
import '../models/post_model.dart';
import '../user_preferences.dart';
import 'abstract_datasource.dart';

class RedditDataSource extends DataSource {
  //возвращает список постов по всем ключевым словам
  @override
  Future<List<Post>> getByKeyword(String keyword) async {
    List<Post> posts = [];

    //инициализация реддита
    var deviceID = UserPreferences().getDeviceId();
    const userAgent = 'hypester by carrot';

    final reddit = await Reddit.createUntrustedReadOnlyInstance(userAgent: userAgent, clientId: redditApiKey, deviceId: deviceID);

    //Completer нужен, чтобы забрать из стрима все посты. Особенности апи реддита
    Completer<List<Post>> completer = Completer<List<Post>>(); // Создаем Completer

    reddit.subreddit('all').search(keyword, sort: Sort.top, timeFilter: TimeFilter.day, params: {'limit': limitFilter.toString()}).listen(
      (event) {
        var data = event as Submission;

        List<String> galleryUrls = [];
        var isGallery = data.data!['is_gallery'] ?? false;
        if (isGallery) {
          data.data!['gallery_data']['items'].forEach((element) {
            galleryUrls.add('https://i.redd.it/${element['media_id']}.jpg');
          });
        }
        posts.add(
          Post(
            title: data.title,
            body: data.selftext,
            id: data.id!,
            imageUrl: urlIsImage(data.url.toString()) ? data.url.toString() : '',
            date: data.createdUtc,
            sourceName: 'Reddit',
            views: 0,
            //views: (data.viewCount !=null)?data.viewCount: 0,
            linkToOriginal: data.url.toString(),
            likes: data.upvotes,
            channel: data.subreddit.displayName,
            relinkUrl: data.url.toString(),
            videoUrl: data.isVideo ? data.url.toString() : '',
            isGallery: isGallery,
            galleryUrls: isGallery ? galleryUrls : null,
          ),
        );
      },
      onDone: () {
        if (!completer.isCompleted) completer.complete(posts); // Завершаем выполнение Completer и передаем готовый список
      },
      onError: (e) {
        if (!completer.isCompleted) completer.complete(posts); // Завершаем выполнение Completer и передаем готовый список
      },
    );

    return completer.future; // Возвращаем Future, который будет завершен, когда Completer будет выполнен
  }
}

//
//     /*
//     Этот код понадобится, если придется подключаться по другому ключу reddit api. В настройках на реддите надо указать redirect http://localhost:8080
//     final reddit = Reddit.createInstalledFlowInstance(userAgent: userAgent,
//                                                         clientId: redditApiKey,);
//
//       // Build the URL used for authentication. See `WebAuthenticator`
//       // documentation for parameters.
//       final auth_url = reddit.auth.url(['*'], 'hypester by carrot');
//
//       // ...
//       // Complete authentication at `auth_url` in the browser and retrieve
//       // the `code` query parameter from the redirect URL.
//       // ...
//
//       // Assuming the `code` query parameter is stored in a variable
//       // `auth_code`, we pass it to the `authorize` method in the
//       // `WebAuthenticator`.
//       await reddit.auth.authorize(auth_code);
//      */
//
