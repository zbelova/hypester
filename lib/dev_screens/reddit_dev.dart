import 'package:draw/draw.dart';
import 'package:flutter/material.dart';

class RedditPage extends StatefulWidget {
  const RedditPage({super.key});

  @override
  State<RedditPage> createState() => _RedditPageState();
}




class _RedditPageState extends State<RedditPage> {

List<Subreddit> _subreddits = [];

  void initReddit() async {
    final userAgent = 'hypester by carrot';
    final reddit = await Reddit.createUntrustedReadOnlyInstance(
        userAgent: userAgent,
        clientId: "LZAPVGNW0N1P_PLTg9argA",
        //deviceId: "hypester by carrot " + Random.secure().nextInt(999999).toString(),
        deviceId: "hypester by carrot 1"
    );
    reddit.subreddits.search('magic the gathering', limit:10).listen((event) {
      var data = event as Subreddit;
      setState(() {
        _subreddits.add(data);
      });
    });
  }

  @override
  void initState(){
    initReddit();
   // reddit.subreddits.search('magic the gathering').first.then((value) => print(value.toString()));
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Reddit'),
      ),
      body: Center(
          child:
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _subreddits.length,
                  itemBuilder: (context, index) {
                    if(_subreddits.isEmpty)
                      return Text('empty');
                    else {
                      return ListTile(
                      title: Text(_subreddits[index].title),
                      subtitle: Text(_subreddits[index].displayName),
                    );
                    }
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}
