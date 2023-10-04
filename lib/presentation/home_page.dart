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
  String? _sdkVersion;
  VKAccessToken? _token;
  VKUserProfile? _profile;
  String? _email;
  bool _sdkInitialized = false;

  @override
  void initState() {
    super.initState();

    _getSdkVersion();
    _initSdk();
  }

  Future<void> _initSdk() async {
    await widget.plugin.initSdk();
    _sdkInitialized = true;
    await _updateLoginInfo();
  }

  Future<void> _getSdkVersion() async {
    final sdkVersion = await widget.plugin.sdkVersion;
    setState(() {
      _sdkVersion = sdkVersion;
    });
  }

  Future<void> _updateLoginInfo() async {
    if (!_sdkInitialized) return;

    final token = await widget.plugin.accessToken;
    final profileRes = token != null ? await widget.plugin.getUserProfile() : null;
    final email = token != null ? await widget.plugin.getUserEmail() : null;
    token != null ? UserPreferences().setVKToken(token.token) : UserPreferences().setVKToken('');
    token != null ? UserPreferences().setVKActive(true) : UserPreferences().setVKActive(false);
    setState(() {
      _token = token;
      _profile = profileRes?.asValue?.value;
      _email = email;
    });
  }

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
          LoadingHomePageState() => _buildLoadingPage(state, const ProgressBar()),
          LoadedHomePageState() => _buildHomePage(context, state),
          ErrorHomePageState() => _buildLoadingPage(state, const Center(child: Text('Something went wrong'))),
        };
      }),
    );
  }

  Widget _buildLoadingPage(state, Widget body) {
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
        slider: _buildSliderMenu(context),
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
            Spacer(),
            Center(child: body),
            Spacer()
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage(BuildContext context, state) {
    _tabController = TabController(vsync: this, length: state.feeds.length);
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          context.read<HomePageBloc>().add(LoadHomePageEvent());
        },
        child: const Icon(Icons.refresh),
      ),
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
        slider: _buildSliderMenu(context),
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
            Expanded(
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
            ),

            // SizedBox(height: 5),
            // ElevatedButton(
            //     onPressed: () {
            //       FeedFiltersLocalDataSource.clear();
            //       UserPreferences().setKeywords([]);
            //     },
            //     child: Text('Clear Feeds')),
            // SizedBox(height: 20),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WebViewScreen()));
            //     },
            //     child: Text('Webview')),
            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderMenu(BuildContext context) {
    bool _redditActive = UserPreferences().getRedditActive();
    bool _vkActive = UserPreferences().getVKActive();
    bool _youtubeActive = UserPreferences().getYoutubeActive();
    bool _telegramActive = UserPreferences().getTelegramActive();
    bool _instagramActive = UserPreferences().getInstagramActive();
    return Container(
      color: Colors.orangeAccent,
      child: Padding(
        padding: const EdgeInsets.only(top: 100, left: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  child: Text('Reddit',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[800],
                      )),
                ),
                Switch(
                  activeColor: Colors.white,
                  value: _redditActive,
                  onChanged: (value) {
                    setState(() {
                      _redditActive = value;
                    });
                    UserPreferences().setRedditActive(_redditActive);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  child: Text('Youtube',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[800],
                      )),
                ),
                Switch(
                  activeColor: Colors.white,
                  value: _youtubeActive,
                  onChanged: (value) {
                    setState(() {
                      _youtubeActive = value;
                    });
                    UserPreferences().setYoutubeActive(_youtubeActive);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  child: Text('Telegram',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[800],
                      )),
                ),
                Switch(
                  activeColor: Colors.white,
                  value: _telegramActive,
                  onChanged: (value) {
                    setState(() {
                      _telegramActive = value;
                    });
                    UserPreferences().setTelegramActive(_telegramActive);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  child: Text('VK',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[800],
                      )),
                ),
                Switch(
                  activeColor: Colors.white,
                  value: _vkActive,
                  onChanged: _token != null
                      ? (value) {
                          setState(() {
                            _vkActive = value;
                          });
                          UserPreferences().setVKActive(_vkActive);
                        }
                      : null,
                ),
              ],
            ),
            _token != null
                ? InkWell(
                    onTap: _onPressedLogOutButton,
                    child: Text(
                      'Sign out',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      _onPressedLogInButton(context);
                    },
                    child: Text('Sign in', style: TextStyle(color: Colors.grey[700])),
                  ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  child: Text('Instagram',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[800],
                      )),
                ),
                Switch(
                  activeColor: Colors.white,
                  value: _instagramActive,
                  onChanged: null,
                  //     (value) {
                  //   setState(() {
                  //     _instagramActive = value;
                  //   });
                  //   UserPreferences().setInstagramActive(_instagramActive);
                  // },
                ),
              ],
            ),
            Text('Sign in', style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 60),
            InkWell(
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[800], size: 25),
                  SizedBox(width: 10),
                  Text(
                    'Feed filters',
                    style: TextStyle(color: Colors.grey[800], fontSize: 20),

                  ),
                ],
              ),
              onTap: (){},
            ),
            SizedBox(height: 20),
            InkWell(
              child: Row(
                children: [
                  Icon(Icons.settings, color: Colors.grey[800], size: 25),
                  SizedBox(width: 10),
                  Text(
                    'Settings',
                    style: TextStyle(color: Colors.grey[800], fontSize: 20),

                  ),
                ],
              ),
              onTap: (){},
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Future<void> _onPressedLogInButton(BuildContext context) async {
    final res = await widget.plugin.logIn(scope: [
      VKScope.email,
    ]);
    if (res.isError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Log In failed: ${res.asError!.error}'),
        ),
      );
    } else {
      final loginResult = res.asValue!.value;

      if (!loginResult.isCanceled) await _updateLoginInfo();
      //Navigator.of(context).pop();
    }
  }

  Future<void> _onPressedLogOutButton() async {
    widget.plugin.logOut();
    await _updateLoginInfo();
  }
}
