
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_vk/flutter_login_vk.dart';
import 'package:get_it/get_it.dart';
import 'package:hypester/bloc/homepage/homepage_bloc.dart';
import 'package:hypester/data/repository.dart';
import 'package:hypester/data/user_preferences.dart';
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
  final _bloc = HomePageBloc(PostsRepository(GetIt.I.get(), GetIt.I.get()));


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
      create: (_) => _bloc,
      child: BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
        return switch (state) {
          LoadingHomePageState() => _buildLoadingPage(const Center(
                child: CircularProgressIndicator(
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
              ? ElevatedButton(onPressed: loginVK, child: Text('Login to VK'))
              : Container(
                  // child: Text('You are logged in to VK'),
                ),
          SizedBox(height: 20)
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
              children: <Widget>[
                if (_sdkVersion != null) Text('SDK v$_sdkVersion'),
                if (token != null && profile != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildUserInfo(context, profile, token, _email),
                  ),
                Row(
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
