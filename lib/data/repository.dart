import 'package:flutter/cupertino.dart';
import 'package:hypester/data/hive/feed_filters.dart';
import 'package:hypester/data/hive/feed_filters_local_data_source.dart';
import 'package:hypester/data/user_preferences.dart';

import 'datasource/reddit_datasource.dart';
import 'datasource/vk_datasource.dart';
import 'datasource/youtube_datasource.dart';
import 'models/feed_model.dart';
import 'models/post_model.dart';

class PostsRepository extends ChangeNotifier {
  final RedditDataSource _redditDataSource;
  final VKDataSource _vkDataSource;
  final FeedFiltersLocalDataSource _feedFiltersLocalDataSource;
  final YoutubeDataSource _youtubeDataSource = YoutubeDataSource();
  double progress = 0.0;
  double oldProgress = 0.0;
  bool isLoaded = false;

  PostsRepository(this._redditDataSource, this._vkDataSource, this._feedFiltersLocalDataSource);

  Future<List<Feed>> getAllFeeds() async {
    progress = 0;
    oldProgress = 0.0;
    List<Feed> feeds = [];
    Feed homeFeed = Feed(posts: [], keyword: 'All');
    final List<FeedFilters> feedFilters = await _feedFiltersLocalDataSource.getAll();
    Map<String, bool> activeSources = {
      'Reddit': UserPreferences().getRedditActive(),
      'VK': UserPreferences().getVKActive(),
      'Telegram': UserPreferences().getTelegramActive(),
      'Youtube': UserPreferences().getYoutubeActive(),
      'Instagram': UserPreferences().getInstagramActive(),
    };

    var progressSteps = feedFilters.length * activeSources.values.where((element) => element).length;

    for(var feedFilter in feedFilters){
      List<Post> _allPosts = [];
      if (activeSources['Reddit']!) {
        List<Post> _redditPosts = await _redditDataSource.getByKeyword(feedFilter);
        oldProgress = progress;
        progress += 1 / progressSteps;
        notifyListeners();
        _allPosts.addAll(_redditPosts);
        homeFeed.posts.addAll(_redditPosts);
      }
      if (activeSources['VK']!) {
        List<Post> _vkPosts = await _vkDataSource.getByKeyword(feedFilter);
        oldProgress = progress;
        progress += 1 / progressSteps;
        notifyListeners();
        _allPosts.addAll(_vkPosts);
        homeFeed.posts.addAll(_vkPosts);
      }
      if (activeSources['Youtube']!) {
        List<Post> _youtubePosts = await _youtubeDataSource.getByKeyword(feedFilter);
        oldProgress = progress;
        progress += 1 / progressSteps;
        notifyListeners();
        _allPosts.addAll(_youtubePosts);
        homeFeed.posts.addAll(_youtubePosts);
      }
      //telegram
      //instagram

      _allPosts.sort((a, b) => b.date.compareTo(a.date));
      feeds.add(Feed(keyword: feedFilter.keyword, posts: _allPosts));
    }
    homeFeed.posts.sort((a, b) => b.date.compareTo(a.date));
    feeds.insert(0, homeFeed);
    isLoaded = true;
    notifyListeners();
    return feeds;
  }
}
