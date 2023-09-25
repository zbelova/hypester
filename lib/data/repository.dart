import 'package:hypester/data/user_preferences.dart';

import 'datasource/reddit_datasource.dart';
import 'models/feed_model.dart';
import 'models/post_model.dart';

class PostsRepository {
  final RedditDataSource _redditDataSource;

  //final TelegramDataSource _telegramDataSource;
  //PostsRepository(this._redditDataSource, this._telegramDataSource);
  PostsRepository(this._redditDataSource);

  //итд для всех датасорсов
  //
  // Future<Feed> getFeed(String keyword) async {
  //   List<Post> _redditPosts;
  //   List<Post> _telegramPosts;
  //   //итд для всех датасорсов
  //
  //   if (keyword == 'all') {
  //     _redditPosts = await _redditDataSource.getAll();
  //     //_telegramPosts = await _telegramDataSource.getAll();
  //   } else {
  //     _redditPosts = await _redditDataSource.getByKeyword(keyword);
  //     //_telegramPosts = await _telegramDataSource.getByKeyword(keyword);
  //   }
  //
  //   //составляем общий список постов
  //   List<Post> _allPosts = [];
  //   _allPosts.addAll(_redditPosts);
  //   //_allPosts.addAll(_telegramPosts);
  //   //итд для всех датасорсов
  //
  //   //сортируем посты по дате
  //   _allPosts.sort((a, b) => b.date.compareTo(a.date));
  //   return Feed(keyword: keyword, posts: _allPosts);
  // }

  Future<List<Feed>> getAllFeeds() async {
    List<Feed> feeds = [];
    Feed homeFeed = Feed(posts: [], keyword: 'All');
    final List<String> keywords = UserPreferences().getKeywords();
    for (var keyword in keywords) {
      List<Post> _redditPosts = await _redditDataSource.getByKeyword(keyword);
      //telegram
      //youtube
      //instagram
      //vk
      List<Post> _allPosts = [];
      _allPosts.addAll(_redditPosts);
      _allPosts.sort((a, b) => b.date.compareTo(a.date));
      feeds.add(Feed(keyword: keyword, posts: _allPosts));
      homeFeed.posts.addAll(_allPosts);
    }
    homeFeed.posts.sort((a, b) => b.date.compareTo(a.date));
    feeds.insert(0, homeFeed);
    return feeds;
  }
}
