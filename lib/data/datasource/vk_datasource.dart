import 'package:dio/dio.dart';
import 'package:hypester/api_keys.dart';
import 'package:hypester/data/user_preferences.dart';

import '../models/post_model.dart';
import 'abstract_datasource.dart';
import 'package:flutter_login_vk/flutter_login_vk.dart';

class VKDataSource extends DataSource {
  List<Post> posts = [];
  final Dio _dio;

  VKDataSource(this._dio);

  @override
  Future<List<Post>> getByKeyword(String keyword) async {
    // _getSdkVersion();
    // _initSdk();
    String token = UserPreferences().getVKToken();
    if (token != '') {
      try {
        final response = await _dio.get<Map<String, dynamic>>('https://api.vk.com/method/groups.search?access_token=$token&q=$keyword&count=10&v=5.131');

        final result = response.data;
        // print(result);
        var groups = result!['response']['items'];
        for (var group in groups) {
          print(group['name']);
          var groupPostsResponse = await _dio.get<Map<String, dynamic>>('https://api.vk.com/method/wall.get?access_token=$token&owner_id=-${group['id']}&count=1&v=5.131');
          if(groupPostsResponse.data != null) {
            var groupPosts = groupPostsResponse.data!['response']['items'];
            if (groupPosts.length > 0) {
              for (var post in groupPosts) {
                print(post['id' ]);

                //if(post['date'] > DateTime.now().millisecondsSinceEpoch/1000 - 86400) {
                posts.add(Post(
                  title: '',
                  body: post['text'],
                  id: post['id'].toString(),
                  imageUrl: '',
                  date: DateTime.fromMillisecondsSinceEpoch(post['date'] * 1000),
                  sourceName: 'VK',
                  views: post['views']['count'],
                  linkToOriginal: '',
                  likes: post['likes']['count'],
                  channel: group['name'],
                  relinkUrl: '',
                  videoUrl: '',
                  isGallery: false,
                  galleryUrls: null,
                ));


                // }
              }
            }
          }
        }
        // var answer = result!.keys.map((key) => AnswerDto(
        //   text: result[key],
        // )).toList()[0];
        return posts;
      } catch (e) {
        print(e);
        return const [];
      }
    }

    return posts;
  }
}
