import 'package:hypester/data/user_preferences.dart';

import 'datasource/reddit_datasource.dart';
import 'datasource/vk_datasource.dart';
import 'models/feed_model.dart';
import 'models/post_model.dart';

class PostsRepository {
  final RedditDataSource _redditDataSource;
  final VKDataSource _vkDataSource;

  //final TelegramDataSource _telegramDataSource;
  //PostsRepository(this._redditDataSource, this._telegramDataSource);
  PostsRepository(this._redditDataSource, this._vkDataSource);

  Future<List<Feed>> getAllFeeds() async {
    List<Feed> feeds = [];
    Feed homeFeed = Feed(posts: [], keyword: 'All');
    final List<String> keywords = UserPreferences().getKeywords();
    for (var keyword in keywords) {
      List<Post> _redditPosts = await _redditDataSource.getByKeyword(keyword);
      List<Post> _vkPosts = await _vkDataSource.getByKeyword(keyword);
      //telegram
      //youtube
      //instagram
      List<Post> _allPosts = [];
      _allPosts.addAll(_redditPosts);
      _allPosts.addAll(_vkPosts);
      _allPosts.sort((a, b) => b.date.compareTo(a.date));
      feeds.add(Feed(keyword: keyword, posts: _allPosts));
      homeFeed.posts.addAll(_allPosts);
    }
    homeFeed.posts.sort((a, b) => b.date.compareTo(a.date));
    feeds.insert(0, homeFeed);
    return feeds;
  }
}
