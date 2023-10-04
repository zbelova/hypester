import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_vk/flutter_login_vk.dart';
import 'package:get_it/get_it.dart';
import 'package:hypester/bloc/homepage/homepage_bloc.dart';
import 'package:hypester/data/hive/feed_filters_local_data_source.dart';
import 'package:hypester/data/repository.dart';
import 'package:hypester/data/user_preferences.dart';
import 'package:hypester/presentation/add_feed_screen.dart';
import 'package:hypester/presentation/webview.dart';
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
      appBar: AppBar(
        toolbarHeight: 60,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu, color: Colors.black)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline, color: Colors.black)),
        ],
        //backgroundColor: const Color(0xFFFFCD8D),
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
              for (var feed in state.feedNames)
                Tab(
                  child: Text(
                    feed,
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
      body: body,
    );
  }

  Widget _buildHomePage(BuildContext context, state) {
    _tabController = TabController(vsync: this, length: state.feeds.length);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,

        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu, color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddFeedScreen()));
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.black,
              size: 25,
            ),
          ),
        ],
        //backgroundColor: const Color(0xFFFFCD8D),
        title: const Text('Hypester', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, fontFamily: 'Caveat-Variable')),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25),
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
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                for (var feed in state.feeds)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FeedScreen(feed: feed),
                  ),
              ],
            ),
          ),
          _token == null
              ? Container(
                  color: Colors.grey[100],
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loginVK,
                    child: Text('Login to VK'),
                  ),
                )
              : Container(
                  color: Colors.grey[200],
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('You are logged in to VK'),
                      ElevatedButton(
                        onPressed: loginVK,
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                ),
          ElevatedButton(
              onPressed: () {
                context.read<HomePageBloc>().add(LoadHomePageEvent());
              },
              child: Text('Refresh')),
          SizedBox(height: 5),
          ElevatedButton(
              onPressed: () {
                FeedFiltersLocalDataSource.clear();
                UserPreferences().setKeywords([]);
              },
              child: Text('Clear Feeds')),
          SizedBox(height: 20),
          // ElevatedButton(
          //     onPressed: () {
          //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WebViewScreen()));
          //     },
          //     child: Text('Webview')),
          // SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> loginVK() async {
    final token = _token;
    final profile = _profile;
    final isLogin = token != null;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login to VK'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (_sdkVersion != null) Text('SDK v$_sdkVersion'),
                if (token != null && profile != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildUserInfo(context, profile, token, _email),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _onPressedLogInButton(context);
                      },
                      child: Text('Login'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _onPressedLogOutButton();
                      },
                      child: Text('Logout'),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _buildUserInfo(BuildContext context, VKUserProfile profile, VKAccessToken accessToken, String? email) {
    final photoUrl = profile.photo200;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('User: '),
        Text(
          '${profile.firstName} ${profile.lastName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          'Online: ${profile.online}, Online mobile: ${profile.onlineMobile}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (photoUrl != null) Image.network(photoUrl),
        const Text('AccessToken: '),
        Text(
          accessToken.token,
          softWrap: true,
        ),
        Text('Created: ${accessToken.created}'),
        if (email != null) Text('Email: $email'),
      ],
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
      Navigator.of(context).pop();
    }
  }

  Future<void> _onPressedLogOutButton() async {
    widget.plugin.logOut();
    await _updateLoginInfo();
    Navigator.of(context).pop();
  }
}
