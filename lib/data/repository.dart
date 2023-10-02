import 'package:flutter/cupertino.dart';
import 'package:hypester/data/user_preferences.dart';

import 'datasource/reddit_datasource.dart';
import 'datasource/vk_datasource.dart';
import 'models/feed_model.dart';
import 'models/post_model.dart';

class PostsRepository extends ChangeNotifier{
  final RedditDataSource _redditDataSource;
  final VKDataSource _vkDataSource;
  double progress = 0.0;
  double oldProgress = 0.0;
  bool isLoaded = false;

  PostsRepository(this._redditDataSource, this._vkDataSource);

  Future<List<Feed>> getAllFeeds() async {
    //print('getAllFeeds');
    progress = 0;
    oldProgress = 0.0;
    List<Feed> feeds = [];
    Feed homeFeed = Feed(posts: [], keyword: 'All');
    final List<String> keywords = UserPreferences().getKeywords();
    var progressSteps = keywords.length * 2;
    //TODO брать включенные источники из UserPreferences
    for (var keyword in keywords) {
      List<Post> _redditPosts = await _redditDataSource.getByKeyword(keyword);
      progress += 1/progressSteps;
      if (oldProgress != 0) {
        oldProgress += 1/progressSteps;
      }
      notifyListeners();
      List<Post> _vkPosts = await _vkDataSource.getByKeyword(keyword);
      progress += 1/progressSteps;
      oldProgress += 1/progressSteps;
      notifyListeners();
     // print('reddit: ${_redditPosts.length} vk: ${_vkPosts.length}');
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
    isLoaded = true;
    notifyListeners();
    return feeds;
  }

}
