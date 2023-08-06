import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'data/user_preferences.dart';
import 'dev_screens/details_screen.dart';
import 'dev_screens/instagram_dev.dart';
import 'dev_screens/reddit_dev.dart';
import 'dev_screens/telegram_dev.dart';
import 'dev_screens/twitter_dev.dart';
import 'hive/post_local_dto.dart';
import 'hive/subreddit_local_dto.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserPreferences().init();
  // код для инициализации Hive
  final directory = await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapter(RedditPostLocalDtoAdapter())
    ..registerAdapter(SubredditLocalDtoAdapter());

  runApp(const Hypester());
}

class Hypester extends StatelessWidget {
  const Hypester({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hypester',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<Tab> _tabList = [
    const Tab(
      child: Text("Newsline",
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal)),
    ),
    const Tab(
      child: Text("Reddit",
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal)),
    ),
    const Tab(
      child: Text("Twitter",
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal)),
    ),
    const Tab(
      child: Text("Telegram",
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal)),
    ),
    const Tab(
      child: Text("Instagram",
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal)),
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
        toolbarHeight: 110,
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.black)),
        backgroundColor: const Color(0xFFFAFAFA),
        title: const Text('Hypester',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                fontFamily: 'Caveat-Variable')),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: TabBar(
            indicatorColor: Colors.black,
            isScrollable: true,
            controller: _tabController,
            tabs: _tabList,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DetailsScreen(),
          Padding(
            padding: EdgeInsets.all(16),
            child: RedditPage(),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: TwitterPage(),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: TelegramPage(),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: InstagramPage(),
          ),
        ],
      ),
    );
  }
}
