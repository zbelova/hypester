import 'package:collection/collection.dart';
import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:hypester/data/user_preferences.dart';

import '../hive/post_local_dto.dart';
import '../hive/posts_local_data_source.dart';

class RedditPage extends StatefulWidget {
  const RedditPage({super.key});

  @override
  State<RedditPage> createState() => _RedditPageState();
}

class _RedditPageState extends State<RedditPage> {
  final List<Subreddit> _subreddits = [];
  final TextEditingController _searchController = TextEditingController();

  void _getSubreddits(String query) async {
    if (query.isEmpty) return;
    _subreddits.clear();
    //deviceID уникальный ключ на устройстве. Создается при первом запуске приложения. Сохраняется в shared_preferences
    var deviceID = UserPreferences().getDeviceId();
    const userAgent = 'hypester by carrot';
    final reddit = await Reddit.createUntrustedReadOnlyInstance(userAgent: userAgent, clientId: "LZAPVGNW0N1P_PLTg9argA", deviceId: deviceID);
    reddit.subreddits.search(query, limit: 10).listen((event) {
      var data = event as Subreddit;
      setState(() {
        _subreddits.add(data);
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Reddit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Тема',
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _getSubreddits(_searchController.text);
                },
                child: const Text('Найти саббредиты')),
            Expanded(
              child: ListView.builder(
                itemCount: _subreddits.length,
                itemBuilder: (context, index) {
                  if (_subreddits.isEmpty) {
                    return const Text('Ничего не найдено');
                  } else {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubredditPage(
                                      subreddit: _subreddits[index],
                                    )));
                      },
                      child: ListTile(
                        title: Text(_subreddits[index].title),
                        subtitle: Text(_subreddits[index].displayName),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubredditPage extends StatefulWidget {
  final Subreddit subreddit;

  const SubredditPage({super.key, required this.subreddit});

  @override
  State<SubredditPage> createState() => _SubredditPageState();
}

class _SubredditPageState extends State<SubredditPage> {
  final PostsLocalDataSource _localDataSource = PostsLocalDataSource();
  List<RedditPostLocalDto> _posts = [];

  //функция получения постов из саббредита с помощью пакета draw с сохранением в hive
  //модели Submission (поста) нет, просто запихиваю в hive как есть
  void _getPosts() async {
    //подписываюсь на стрим постов из саббредита, которые получаются по одному
    //вместо стрима тут должен быть блок, который изменяет состояние при появлении новых постов после обновления экрана пользователем (pull to refresh)
    widget.subreddit.newest(limit: 4).listen((event) {
      var data = event as Submission;

      //сравниваю пост из стрима с постами из hive
      //если поста нет в hive, то добавляю его в hive
      //функция firstWhereOrNull взята из пакета collection
      RedditPostLocalDto? oldPost = _posts.firstWhereOrNull((oldPost) => oldPost.id == data.id);
      if (oldPost == null) {
        RedditPostLocalDto newPost = RedditPostLocalDto(
          id: data.id!,
          title: data.title,
          body: data.selftext,
          image: urlIsImage(data.url.toString()) ? data.url.toString() : '',
          likes: data.upvotes,
          author: data.author,
          subreddit: data.subreddit.displayName,
          date: data.createdUtc,
          url: data.url.toString(),
        );
        _localDataSource.add(newPost);
        //добавляю новый пост в начало списка постов
        _posts.insert(0, newPost);
        setState(() {
        });
      }


    });

  }

  void _initPostsList() async {
    //открываю hive и получаю все посты из него
    _posts = await _localDataSource.getAll();
    //переворачиваю список, чтобы сверху были новые посты
    _posts = _posts.reversed.toList();
    setState(() {
    });
  }

  @override
  initState() {
    _initPostsList();
    _getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Reddit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.subreddit.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(widget.subreddit.displayName),
            const SizedBox(
              height: 20,
            ),
            if (_posts.isNotEmpty) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    if (_posts.isEmpty) {
                      return const Text('Ничего не найдено');
                    } else {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostPage(
                                        post: _posts[index],
                                      )));
                        },
                        child: ListTile(
                          leading: const Icon(Icons.text_snippet),
                          title: Text(_posts[index].title),
                        ),
                      );
                    }
                  },
                ),
              ),
            ] else ...[
              const Center(child: CircularProgressIndicator())
            ],
          ],
        ),
      ),
    );
  }
}

class PostPage extends StatefulWidget {
  final RedditPostLocalDto post;

  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text('u/${widget.post.author}'),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: [
                  Text(widget.post.body!),
                ],
              ),
            ),

            if (urlIsImage(widget.post.image.toString())) ...[
              const SizedBox(
                height: 10,
              ),
              Image.network(widget.post.image.toString()),
              const Spacer()
            ],
            // Text(widget.post.comments.toString()),
          ],
        ),
      ),
    );
  }
}

bool urlIsImage(String url) {
  return url.contains('.jpg') || url.contains('.png') || url.contains('.jpeg') || url.contains('.gif');
}
