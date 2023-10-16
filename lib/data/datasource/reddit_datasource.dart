//реализация датасорса для реддита
//для каждого источника отдельный класс наследник от DataSource
import 'dart:async';
import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:hypester/data/hive/feed_filters.dart';
import '../../api_keys.dart';
import '../../globals.dart';
import '../models/post_model.dart';
import '../user_preferences.dart';
import 'abstract_datasource.dart';

class RedditDataSource extends DataSource {
  //возвращает список постов по всем ключевым словам
  @override
  Future<List<Post>> getByKeyword(FeedFilters feedFilters) async {
    List<Post> posts = [];

    //инициализация реддита
    var deviceID = UserPreferences().getDeviceId();
    const userAgent = 'hypester by carrot';

    final reddit = await Reddit.createUntrustedReadOnlyInstance(userAgent: userAgent, clientId: redditApiKey, deviceId: deviceID);

    //Completer нужен, чтобы забрать из стрима все посты. Особенности апи реддита
    Completer<List<Post>> completer = Completer<List<Post>>(); // Создаем Completer
    if (!feedFilters.searchInSubreddits) {
      reddit.subreddit('all').search(feedFilters.keyword, sort: Sort.top, timeFilter: TimeFilter.day, params: {'limit': limitFilter.toString()}).listen(
        (event) {
          var data = event as Submission;

          List<String> galleryUrls = [];
          var isGallery = data.data!['media_metadata'] != null;
          if (isGallery) {
            for (var metadata in data.data!['media_metadata'].values) {
              galleryUrls.add(convertRedditUrl(metadata['s']['u'].toString()));
            }
          }
          if (data.upvotes > feedFilters.redditLikesFilter) {
            if(!data.over18 || (data.over18 && UserPreferences().getNSFWActive())) {
              posts.add(
              Post(
                  title: data.title,
                  body: data.selftext,
                  id: data.id!,
                  imageUrl: data.preview.isNotEmpty ? data.preview[0].source.url.toString() : '',
                  date: data.createdUtc,
                  sourceName: 'Reddit',
                  views: 0,
                  linkToOriginal: data.url.toString(),
                  likes: data.upvotes,
                  channel: data.subreddit.displayName,
                  relinkUrl: data.url.toString().contains('www.reddit.com/') || data.url.toString().contains('redd.it/') ? '' : data.url.toString(),
                  videoUrl: data.isVideo ? data.url.toString() : '',
                  isGallery: isGallery,
                  galleryUrls: isGallery ? galleryUrls : null,
                  numComments: data.numComments,
              ),
            );
            }
          }
        },
        onDone: () {
          if (!completer.isCompleted) completer.complete(posts); // Завершаем выполнение Completer и передаем готовый список
        },
        onError: (e) {
          if (!completer.isCompleted) completer.complete(posts); // Завершаем выполнение Completer и передаем готовый список
        },
      );
    } else {
      int numSubreddits = 5;
      int numPosts = numSubreddits * 10;
      List<String> subreddits = [];
      reddit.subreddits.search(feedFilters.keyword, limit: numSubreddits).listen(
        (event) {
          var data = event as Subreddit;
          subreddits.add(data.displayName);
        },
        onDone: () {
          reddit.subreddit(subreddits.join('+')).top(timeFilter: TimeFilter.day, params: {'limit': numPosts.toString()}).listen(
            (event) {
              var data = event as Submission;
              List<String> galleryUrls = [];
              var isGallery = data.data!['media_metadata'] != null;
              if (isGallery) {
                for (var metadata in data.data!['media_metadata'].values) {
                  galleryUrls.add(convertRedditUrl(metadata['s']['u'].toString()));
                }
              }
              if (data.upvotes > feedFilters.redditLikesFilter) {
                if (!data.over18 || (data.over18 && UserPreferences().getNSFWActive())) {
                  posts.add(
                    Post(
                      title: data.title,
                      body: data.selftext,
                      id: data.id!,
                      imageUrl: data.preview.isNotEmpty ? data.preview[0].source.url.toString() : '',
                      date: data.createdUtc,
                      sourceName: 'Reddit',
                      views: 0,
                      linkToOriginal: data.shortlink.toString(),
                      likes: data.upvotes,
                      channel: data.subreddit.displayName,
                      relinkUrl: data.url.toString().contains('www.reddit.com/') || data.url.toString().contains('redd.it/') ? '' : data.url.toString(),
                      videoUrl: data.isVideo ? data.url.toString() : '',
                      isGallery: isGallery,
                      galleryUrls: isGallery ? galleryUrls : null,
                      numComments: data.numComments,
                    ),
                  );
                }
              }
            },
            onDone: () {
              if (!completer.isCompleted) completer.complete(posts);
            },
            onError: (e) {
              if (!completer.isCompleted) completer.complete(posts); // Завершаем выполнение Completer и передаем готовый список
            },
          );
        },
        onError: (e) {
          if (!completer.isCompleted) completer.complete(posts); // Завершаем выполнение Completer и передаем готовый список
        },
      );
    }
    return completer.future; // Возвращаем Future, который будет завершен, когда Completer будет выполнен
  }
}

String convertRedditUrl(String url) {
  final encodedUrl = Uri.encodeFull(url);
  final regex = RegExp(r'https://preview\.redd\.it/(.*)\?(.*)');
  final match = regex.firstMatch(encodedUrl);
  if (match != null && match.groupCount >= 1) {
    final imageId = match.group(1) ?? '';
    final imageUrl = 'https://i.redd.it/$imageId';
    return imageUrl;
  }
  return url;
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
