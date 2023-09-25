
import '../models/feed_model.dart';
import '../models/post_model.dart';
import 'datasource/reddit_datasource.dart';

class PostsRepository {
  final RedditDataSource _redditDataSource;
  //final TelegramDataSource _telegramDataSource;
  //PostsRepository(this._redditDataSource, this._telegramDataSource);
  PostsRepository(this._redditDataSource);

  //итд для всех датасорсов

  Future<Feed> getFeed(String keyword) async {
    List<Post> _redditPosts;
    List<Post> _telegramPosts;
    //итд для всех датасорсов

    if (keyword == 'all') {
      _redditPosts = await _redditDataSource.getAll();
      //_telegramPosts = await _telegramDataSource.getAll();
    } else {
      _redditPosts = await _redditDataSource.getByKeyword(keyword);
      //_telegramPosts = await _telegramDataSource.getByKeyword(keyword);
    }

    //составляем общий список постов
    List<Post> _allPosts = [];
    _allPosts.addAll(_redditPosts);
    //_allPosts.addAll(_telegramPosts);
    //итд для всех датасорсов

    //сортируем посты по дате
    _allPosts.sort((a, b) => b.date.compareTo(a.date));
    return Feed(keyword: keyword, posts: _allPosts);
  }
}