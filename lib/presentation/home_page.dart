import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_vk/flutter_login_vk.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get_it/get_it.dart';
import 'package:hypester/bloc/homepage/homepage_bloc.dart';
import 'package:hypester/data/hive/feed_filters_local_data_source.dart';
import 'package:hypester/data/user_preferences.dart';
import 'package:hypester/presentation/add_feed_screen.dart';
import 'package:hypester/presentation/widgets/progress_bar.dart';
import 'package:hypester/presentation/widgets/slider_menu.dart';
import '../bloc/homepage/homepage_event.dart';
import '../bloc/homepage/homepage_state.dart';
import 'feed_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.plugin}) : super(key: key);

  final VKLogin plugin;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomePageBloc(GetIt.I.get()),
      child: BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
        return switch (state) {
          LoadingHomePageState() => _buildScaffold(
              context,
              state,
              const Column(
                children: [
                  Spacer(),
                  Center(child: ProgressBar()),
                  Spacer(),
                ],
              )),
          LoadedHomePageState() => _buildScaffold(context, state, Container(), true),
          ErrorHomePageState() => _buildScaffold(
              context,
              state,
              const Center(child: Text('Something went wrong')),
            ),
        };
      }),
    );
  }

  Widget _buildScaffold(BuildContext context, state, Widget content, [bool isLoaded = false]) {
    _tabController = TabController(vsync: this, length: state.feedNames.length);
    return Scaffold(
      extendBody: true,
      body: SliderDrawer(
        appBar: SliderAppBar(
          appBarHeight: 100,
          trailing: IconButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddFeedScreen()));
              context.read<HomePageBloc>().add(LoadHomePageEvent());
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.black,
              size: 25,
            ),
          ),
          title: const Text('Hypester', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, fontFamily: 'Caveat-Variable')),
        ),
        key: const ValueKey('drawer'),
        slider: SliderMenu(
          plugin: widget.plugin,
          reload: () {
            context.read<HomePageBloc>().add(LoadHomePageEvent());
          },
        ),
        child: Column(
          children: [
            SizedBox(
              height: 35,
              child: TabBar(
                tabAlignment: TabAlignment.center,
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                isScrollable: true,
                controller: _tabController,
                tabs: [
                  for (var feedName in state.feedNames)
                    Tab(
                      child: Text(
                        feedName,
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
            (isLoaded)
                ? Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        for (var feed in state.feeds)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                            child: FeedScreen(feed: feed),
                          ),
                      ],
                    ),
                  )
                : Expanded(child: content),
            SizedBox(height: 5),
            ElevatedButton(
                onPressed: () {
                  FeedFiltersLocalDataSource.clear();
                  UserPreferences().setKeywords([]);
                },
                child: Text('Clear Feeds')),
          ],
        ),
      ),
    );
  }
}
