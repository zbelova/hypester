import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hypester/bloc/homepage/homepage_bloc.dart';
import 'package:hypester/data/repository.dart';
import 'package:hypester/data/user_preferences.dart';
import 'package:hypester/dev_screens/reddit_dev.dart';
import 'package:hypester/dev_screens/telegram_dev.dart';
import 'package:hypester/dev_screens/twitter_dev.dart';
import '../bloc/homepage/homepage_state.dart';
import '../models/feed_model.dart';
import 'feed_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //final List<String> keywords = UserPreferences().getKeywords();
  //List<Tab> _tabList = [];
  //List<Feed> _feeds = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // for (var keyword in keywords) {
    //   _tabList.add(Tab(
    //     child: Text(
    //       keyword,
    //       style: const TextStyle(
    //         fontSize: 17,
    //         fontWeight: FontWeight.w400,
    //         fontStyle: FontStyle.normal,
    //       ),
    //     ),
    //   ));
    // }
    //_tabController = ≈;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = HomePageBloc(PostsRepository(GetIt.I.get()));
    return BlocProvider(
      create: (_) => _bloc,
      child: BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
        return switch (state) {
          LoadingHomePageState() => const Center(
              child: CircularProgressIndicator(),
            ),
          LoadedHomePageState() => _buildHomePage(context, state),
          ErrorHomePageState() => const Center(
              child: Text('Ошибка загрузки данных'),
            ),
        };
      }),
    );
  }

  Widget _buildHomePage(context, state) {
    _tabController = TabController(vsync: this, length: state.feeds.length);
    return Scaffold(
      extendBody: true,
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
            tabs: [
              for (var feed in state.feeds)
                Tab(
                  child: Text(
                    feed.keyword,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          for(var feed in state.feeds)
            Padding(
              padding: const EdgeInsets.all(16),
              child: FeedScreen(feed: feed),
            ),
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: FeedScreen(feed: Feed(id: 1, title: "All posts")),
          // ),
          // Padding(
          //   padding: EdgeInsets.all(16),
          //   child: FeedScreen(feed: Feed(id: 2, title: "All posts")),
          //   //child: RedditPage(),
          // ),
        ],
      ),
    );
  }
}
