import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hypester/bloc/homepage/homepage_bloc.dart';
import 'package:hypester/data/repository.dart';
import '../bloc/homepage/homepage_state.dart';
import 'feed_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = HomePageBloc(PostsRepository(GetIt.I.get()));
    return BlocProvider(
      create: (_) => bloc,
      child: BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
        return switch (state) {
          LoadingHomePageState() => _buildLoadingPage(const Center(child: CircularProgressIndicator(
            color: Colors.grey,
          ))),
          LoadedHomePageState() => _buildHomePage(context, state),
          ErrorHomePageState() => _buildLoadingPage(const Center(child: Text('Something went wrong'))),
        };
      }),
    );
  }

  Widget _buildLoadingPage(Widget body) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 60,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu, color: Colors.black)),
        backgroundColor: const Color(0xFFFFCD8D),
        title: const Text('Hypester', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, fontFamily: 'Caveat-Variable')),
      ),
      body: body,
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
            tabAlignment: TabAlignment.start,
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
          for (var feed in state.feeds)
            Padding(
              padding: const EdgeInsets.all(16),
              child: FeedScreen(feed: feed),
            ),
        ],
      ),
    );
  }
}
