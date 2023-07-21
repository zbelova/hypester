import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:hypester/data/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';



class RedditPage extends StatefulWidget {
  const RedditPage({super.key});

  @override
  State<RedditPage> createState() => _RedditPageState();
}

class _RedditPageState extends State<RedditPage> {
  List<Subreddit> _subreddits = [];
  TextEditingController _searchController = TextEditingController();

  void _getSubreddits(String query) async {
    if(query.isEmpty) return;
    _subreddits.clear();
    //deviceID уникальный ключ на устройстве. Создается при первом запуске приложения. Сохраняется в shared_preferences
    var deviceID = UserPreferences().getDeviceId();
    const userAgent = 'hypester by carrot';
    final reddit = await Reddit.createUntrustedReadOnlyInstance(
        userAgent: userAgent,
        clientId: "LZAPVGNW0N1P_PLTg9argA",
        //deviceId: "hypester by carrot " + Random.secure().nextInt(999999).toString(),
        deviceId: deviceID);
    reddit.subreddits.search(query, limit: 10).listen((event) {
      var data = event as Subreddit;
      setState(() {
        _subreddits.add(data);
      });
    });
  }

  @override
  void initState() {
   // _getSubreddits('magic the gathering');
    // reddit.subreddits.search('magic the gathering').first.then((value) => print(value.toString()));
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
        SizedBox(height: 20,),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Тема',
          ),
        ),
        ElevatedButton(
            onPressed: () {
              _getSubreddits(_searchController.text);
            },
            child: Text('Найти саббредиты')),
        Expanded(
          child: ListView.builder(
            itemCount: _subreddits.length,
            itemBuilder: (context, index) {
              if (_subreddits.isEmpty)
                return Text('Ничего не найдено');

              else {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => SubredditPage(subreddit: _subreddits[index],)));
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
  SubredditPage({super.key, required this.subreddit});

  @override
  State<SubredditPage> createState() => _SubredditPageState();
}

class _SubredditPageState extends State<SubredditPage> {
  List<Submission> _posts = [];

  void _getPosts() async {
    _posts.clear();
    //deviceID уникальный ключ на устройстве. Создается при первом запуске приложения. Сохраняется в shared_preferences
    //Submission posts = await widget.subreddit.hot(limit: 10).first as Submission;
    widget.subreddit.hot(limit: 10).listen((event) {
      var data = event as Submission;
      setState(() {
        _posts.add(data);
        print(data.title);
      });
    });
  }

  @override
  initState() {
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
            SizedBox(height: 20,),

            Expanded(
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  if (_posts.isEmpty)
                    return Text('Ничего не найдено');

                  else {
                    return ListTile(
                      leading: Icon(Icons.text_snippet),
                      title:
                      Text(_posts[index].title),

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

