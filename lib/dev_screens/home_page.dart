import 'package:flutter/material.dart';
import 'package:hypester/dev_screens/feed_screen.dart';
import 'package:hypester/dev_screens/reddit_dev.dart';
import 'package:hypester/dev_screens/telegram_dev.dart';
import 'package:hypester/dev_screens/twitter_dev.dart';
import '../models/feed_model_dev.dart';
import 'instagram_dev.dart';
import 'newsfeed.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final List<Tab> _tabList = [
    const Tab(
      child: Text(
        "All posts",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          //color: Colors.black,

        ),
      ),
    ),
    const Tab(
      child: Text(
        "Cats",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          //color: Colors.black,
        ),
      ),
    ),
    const Tab(
      child: Text(
        "Bitcoin",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          //color: Colors.black,
        ),
      ),
    ),
    const Tab(
      child: Text(
        "Юрий Дудь",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          //color: Colors.black,
        ),
      ),
    ),
    const Tab(
      child: Text(
        "Beer",
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      ),
    ),
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabList.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu, color: Colors.black)),
        backgroundColor: const Color(0xFFFFCD8D),
        title: const Text('Hypester', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, fontFamily: 'Caveat-Variable')),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            isScrollable: true,
            controller: _tabController,
            tabs: _tabList,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: FeedScreen(feed: Feed(id: 1, title: "All posts")),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: FeedScreen(feed: Feed(id: 2, title: "All posts")),
            //child: RedditPage(),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: FeedScreen(feed: Feed(id: 2, title: "All posts")),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: FeedScreen(feed: Feed(id: 3, title: "All posts")),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: FeedScreen(feed: Feed(id: 4, title: "All posts")),
          ),
        ],
      ),
    );
  }
}
