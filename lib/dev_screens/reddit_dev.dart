import 'package:collection/collection.dart';
import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:hypester/api_keys.dart';
import 'package:hypester/data/user_preferences.dart';
import '../hive/post_local_dto.dart';
import '../hive/posts_local_data_source.dart';
import '../hive/subreddit_local_dto.dart';
import '../hive/subreddits_local_data_source.dart';

class RedditPage extends StatefulWidget {
  const RedditPage({super.key});

  @override
  State<RedditPage> createState() => _RedditPageState();
}

class _RedditPageState extends State<RedditPage> {
  final PostsLocalDataSource _localDataSource = PostsLocalDataSource();
  final SubredditsLocalDataSource _subredditsLocalDataSource =
      SubredditsLocalDataSource();
  List<RedditPostLocalDto> _posts = [];

  bool _noSavedPosts = false;

  void _getPosts() async {
    //deviceID уникальный ключ на устройстве. Создается при первом запуске приложения. Сохраняется в shared_preferences
    var deviceID = UserPreferences().getDeviceId();
    const userAgent = 'hypester by carrot';
    //здесь иногда возникает ошибка, связанная с тем, что reddit не дает доступ к api. Причина неизвестна
    //надо ловить эксепшн
    final reddit = await Reddit.createUntrustedReadOnlyInstance(userAgent: userAgent, clientId: redditApiKey, deviceId: deviceID);

    /*
    Этот код понадобится, если придется подключаться по другому ключу reddit api. В настройках на реддите надо указать redirect http://localhost:8080
    final reddit = Reddit.createInstalledFlowInstance(userAgent: userAgent,
                                                        clientId: redditApiKey,);

      // Build the URL used for authentication. See `WebAuthenticator`
      // documentation for parameters.
      final auth_url = reddit.auth.url(['*'], 'hypester by carrot');

      // ...
      // Complete authentication at `auth_url` in the browser and retrieve
      // the `code` query parameter from the redirect URL.
      // ...

      // Assuming the `code` query parameter is stored in a variable
      // `auth_code`, we pass it to the `authorize` method in the
      // `WebAuthenticator`.
      await reddit.auth.authorize(auth_code);
     */
    //получаю список сохраненных саббредитов из hive
    List<SubredditLocalDto> subreddits =
        await _subredditsLocalDataSource.getAll();
    String query = subreddits.map((e) => e.displayName).join('+');
    //подписываюсь на стрим постов из саббредитов, посты получаются по одному
    //вместо стрима тут должен быть блок, который изменяет состояние при появлении новых постов после обновления экрана пользователем (pull to refresh)
    if (query.isNotEmpty) {
      reddit.subreddit(query).newest(limit: 20).listen((event) {
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
          setState(() {});
        }
        setState(() {});
      });
    } else {
      _noSavedPosts = true;
      setState(() {});
    }
  }

  void _initPostsList() async {
    //открываю hive и получаю все посты из него
    _posts = await _localDataSource.getAll();
    //переворачиваю список, чтобы сверху были новые посты
    _posts = _posts.reversed.toList();
    setState(() {});
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // кнопка перехода на страницу поиска сабреддитов
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade50),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectSubredditPage()));
                setState(() {
                  _getPosts();
                });
              },
              child: const Text('Выбрать сабреддиты',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal)),
            ),
            const SizedBox(height: 10),
            if (_posts.isNotEmpty) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    if (_posts.isEmpty) {
                      return const Text('Ничего не найдено',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w200,
                              fontStyle: FontStyle.normal));
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
                          subtitle: Text(_posts[index].subreddit),
                        ),
                      );
                    }
                  },
                ),
              ),
            ] else if (_noSavedPosts) ...[
              const Center(
                  child: Text('Нет сохраненных сабреддитов',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal))),
            ] else ...[
              const Center(child: CircularProgressIndicator())
            ],
          ],
        ),
      ),
    );
  }
}

class SelectSubredditPage extends StatefulWidget {
  const SelectSubredditPage({super.key});

  @override
  State<SelectSubredditPage> createState() => _SelectSubredditPageState();
}

class _SelectSubredditPageState extends State<SelectSubredditPage> {
  final List<SubredditLocalDto> _subreddits = [];
  final List<SubredditLocalDto> _savedSubreddits = [];
  final TextEditingController _searchController = TextEditingController();
  final SubredditsLocalDataSource _localDataSource =
      SubredditsLocalDataSource();
  bool loading = false;

  void _getSubreddits(String query) async {
    setState(() {
      print('1');
      loading = true;
    });
    if (query.isEmpty) return;
    _subreddits.clear();
    //deviceID уникальный ключ на устройстве. Создается при первом запуске приложения. Сохраняется в shared_preferences
    var deviceID = UserPreferences().getDeviceId();
    const userAgent = 'hypester by carrot';
    final reddit = await Reddit.createUntrustedReadOnlyInstance(
        userAgent: userAgent,
        clientId: redditApiKey,
        deviceId: deviceID);

    //reddit.subreddits.search(query, limit: 3).listen((event) {
    reddit.subreddits.search(query).listen((event) {
      var data = event as Subreddit;
      SubredditLocalDto? oldSubreddit = _savedSubreddits.firstWhereOrNull(
          (oldSubreddit) => oldSubreddit.displayName == data.displayName);
      if (oldSubreddit == null) {
        SubredditLocalDto newSubreddit = SubredditLocalDto(
          displayName: data.displayName,
          icon: data.iconImage.toString(),
          title: data.title,
        );
        setState(() {
          loading = false;
          _subreddits.add(newSubreddit);
        });
      }
    });
  }

  void _addSubreddit(SubredditLocalDto subreddit) {
    //проверяю, есть ли сабреддит в hive
    SubredditLocalDto? oldSubreddit = _savedSubreddits.firstWhereOrNull(
        (oldSubreddit) => oldSubreddit.displayName == subreddit.displayName);
    if (oldSubreddit == null) {
      SubredditLocalDto newSubreddit = SubredditLocalDto(
        displayName: subreddit.displayName,
        icon: subreddit.icon,
        title: subreddit.title,
      );
      //сохраняю выбранный сабреддит в hive, если его нет там
      _localDataSource.add(newSubreddit);
      _savedSubreddits.add(newSubreddit);

      setState(() {});
    }
  }

  void deleteSubreddit(SubredditLocalDto subreddit) {
    _localDataSource.delete(subreddit);
    _savedSubreddits.remove(subreddit);
    setState(() {});
  }

  void initSubredditsList() async {
    _savedSubreddits.addAll(await _localDataSource.getAll());
    setState(() {});
  }

  @override
  void initState() {
    initSubredditsList();
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
        title: const Text('Добавление сабреддитов',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Тема',
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade50),
                      onPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          _getSubreddits(_searchController.text);
                        }
                      },
                      child: const Text('Найти саббредиты',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic))),
                  const SizedBox(
                    height: 8,
                  ),
                  if (_savedSubreddits.isNotEmpty) ...[
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _savedSubreddits.length,
                        itemBuilder: (context, index) {
                          if (_savedSubreddits.isEmpty) {
                            return const Text('Ничего не найдено');
                          } else {
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blue[100]!,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue[100],
                                  ),
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Expanded(
                                          flex: 10,
                                          child: Text(
                                            _savedSubreddits[index].title,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                              onPressed: () {
                                                deleteSubreddit(
                                                    _savedSubreddits[index]);
                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.delete)),
                                        )
                                      ],
                                    ),
                                    subtitle: Text(
                                        _savedSubreddits[index].displayName),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                )
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            //add delimeter

            Expanded(
              flex: 5,
              child: Column(
                children: [
                  if (!loading) ...[
                    const Divider(
                      height: 20,
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _subreddits.length,
                        itemBuilder: (context, index) {
                          if (_subreddits.isEmpty) {
                            return const Text('Ничего не найдено');
                          } else {
                            return ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: Text(
                                      _subreddits[index].title,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        onPressed: () {
                                          _addSubreddit(_subreddits[index]);
                                        },
                                        icon:
                                            const Icon(Icons.add_box_rounded)),
                                  )
                                ],
                              ),
                              subtitle: Text(_subreddits[index].displayName),
                            );
                          }
                        },
                      ),
                    ),
                    // Spacer(),
                  ] else ...[
                    const Center(child: CircularProgressIndicator())
                  ],
                ],
              ),
            ),
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
  return url.contains('.jpg') ||
      url.contains('.png') ||
      url.contains('.jpeg') ||
      url.contains('.gif');
}
