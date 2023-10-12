import 'package:dio/dio.dart';
import 'package:hypester/data/hive/feed_filters.dart';
import 'package:hypester/data/user_preferences.dart';
import '../models/post_model.dart';
import 'abstract_datasource.dart';

class VKDataSource extends DataSource {
  final Dio _dio;

  VKDataSource(this._dio);

  @override
  Future<List<Post>> getByKeyword(FeedFilters feedFilters) async {
    List<Post> posts = [];
    String token = UserPreferences().getVKToken();
    if (token != '') {
      try {
        final response = await _dio.get<Map<String, dynamic>>('https://api.vk.com/method/groups.search?access_token=$token&q=${feedFilters.keyword}&count=5&v=5.131&sort=6');

        final result = response.data;
        var groups = result!['response']['items'];
        for (var group in groups) {
          var groupPostsResponse = await _dio.get<Map<String, dynamic>>('https://api.vk.com/method/wall.get?access_token=$token&owner_id=-${group['id']}&count=3&v=5.131');
          if (groupPostsResponse.data != null && groupPostsResponse.data!['response'] != null) {
            var groupPosts = groupPostsResponse.data!['response']['items'];
            if (groupPosts.length > 0) {
              for (var post in groupPosts) {
                if (post['date'] > DateTime.now().millisecondsSinceEpoch / 1000 - 86400) {
                  bool isRelink = false;
                  bool isVideo = false;
                  for (final attachment in post['attachments']) {
                    if (attachment is Map &&
                        (attachment.containsKey('audio') ||
                            attachment.containsKey('video') ||
                            attachment.containsKey('doc') ||
                            attachment.containsKey('graffiti') ||
                            attachment.containsKey('link') ||
                            attachment.containsKey('note') ||
                            attachment.containsKey('app') ||
                            attachment.containsKey('poll') ||
                            attachment.containsKey('page') ||
                            attachment.containsKey('album'))) {
                      isRelink = true;
                      isVideo = attachment.containsKey('video');
                    }
                  }
                  if (post['likes']['count'] > feedFilters.vkLikesFilter && (post['views'] == null || post['views']['count'] > feedFilters.vkViewsFilter)) {
                    posts.add(Post(
                      title: '',
                      body: post['text'],
                      id: post['id'].toString(),
                      imageUrl: !post['attachments']?.isEmpty ? (post['attachments'][0]['photo'] != null ? post['attachments'][0]['photo']['sizes'][3]['url'] : null) : null,
                      date: DateTime.fromMillisecondsSinceEpoch(post['date'] * 1000),
                      sourceName: 'VK',
                      views: post['views'] != null ? post['views']['count'] : 0,
                      linkToOriginal: 'https://vk.com/wall-${group['id']}_${post['id']}',
                      likes: post['likes']['count'] ?? 0,
                      channel: group['name'],
                      relinkUrl: isRelink ? 'https://vk.com/wall-${group['id']}_${post['id']}' : '',
                      isGallery: false,
                      galleryUrls: null,
                      isVideo: isVideo ? true : false,
                      numComments: post['comments']['count'] ?? 0,
                    ));
                  }
                }
              }
            }
          }
        }
        // var answer = result!.keys.map((key) => AnswerDto(
        //   text: result[key],
        // )).toList()[0];
        return posts;
      } catch (e) {
        // print(e);
        return const [];
      }
    }

    return posts;
  }
}
