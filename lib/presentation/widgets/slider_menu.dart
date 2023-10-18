import 'package:flutter/material.dart';
import 'package:flutter_login_vk/flutter_login_vk.dart';
import 'package:hypester/presentation/general_settings_screen.dart';

import '../../data/user_preferences.dart';
import '../feed_settings_list_screen.dart';

class SliderMenu extends StatefulWidget {
  SliderMenu({super.key, required this.plugin, required this.reload});
  Function reload;
  final VKLogin plugin;

  @override
  State<SliderMenu> createState() => _SliderMenuState();
}

class _SliderMenuState extends State<SliderMenu> {
  bool _redditActive = UserPreferences().getRedditActive();
  bool _vkActive = UserPreferences().getVKActive();
  bool _youtubeActive = UserPreferences().getYoutubeActive();
  bool _telegramActive = UserPreferences().getTelegramActive();
  bool _instagramActive = UserPreferences().getInstagramActive();
  VKAccessToken? _token;

  bool _sdkInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVKSdk();
  }

  Future<void> _initVKSdk() async {
    await widget.plugin.initSdk();
    _sdkInitialized = true;
    await _getVKLoginInfo();
  }

  Future<void> _updateVKLoginInfo() async {
    if (!_sdkInitialized) return;

    final token = await widget.plugin.accessToken;
    token != null ? UserPreferences().setVKToken(token.token) : UserPreferences().setVKToken('');
    token != null ? UserPreferences().setVKActive(true) : UserPreferences().setVKActive(false);
    setState(() {
      _token = token;
      _vkActive = token != null;
    });
  }

  Future<void> _getVKLoginInfo() async {
    if (!_sdkInitialized) return;

    final token = await widget.plugin.accessToken;
    token != null ? UserPreferences().setVKToken(token.token) : UserPreferences().setVKToken('');
    setState(() {
      _token = token;
      // _vkActive = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  onChanged: (value) async {
                    setState(() {
                      _redditActive = value;
                      if (_redditActive) widget.reload();
                    });
                    await UserPreferences().setRedditActive(_redditActive);
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
                  onChanged: (value) async{
                    setState(() {
                      _youtubeActive = value;
                      if(_youtubeActive) widget.reload();
                    });
                    await UserPreferences().setYoutubeActive(_youtubeActive);
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
                  onChanged: (value) async {
                    setState(() {
                      _telegramActive = value;
                      if(_telegramActive) widget.reload();
                    });
                    await UserPreferences().setTelegramActive(_telegramActive);
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
                SizedBox(
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
                      ? (value) async {
                          setState(() {
                            _vkActive = value;
                            if(_vkActive) widget.reload();
                          });
                          await UserPreferences().setVKActive(_vkActive);
                        }
                      : null,
                ),
              ],
            ),
            _token != null
                ? InkWell(
                    onTap: _onPressedVKLogOutButton,
                    child: Text(
                      'Sign out',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      _onPressedVKLogInButton(context);
                    },
                    child: Text('Sign in', style: TextStyle(color: Colors.grey[700])),
                  ),
            const SizedBox(
              height: 10,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Container(
            //       width: 110,
            //       child: Text('Instagram',
            //           style: TextStyle(
            //             fontSize: 20,
            //             color: Colors.grey[800],
            //           )),
            //     ),
            //     Switch(
            //       activeColor: Colors.white,
            //       value: _instagramActive,
            //       onChanged: null,
            //       //     (value) {
            //       //   setState(() {
            //       //     _instagramActive = value;
            //       //     if(_instagramActive) widget.reload();
            //       //   });
            //       //   UserPreferences().setInstagramActive(_instagramActive);
            //       // },
            //     ),
            //   ],
            // ),
            // Text('Sign in', style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 60),
            InkWell(
              child: Row(
                children: [
                  Icon(Icons.list_alt, color: Colors.grey[800], size: 25),
                  SizedBox(width: 10),
                  Text(
                    'Edit feeds',
                    style: TextStyle(color: Colors.grey[800], fontSize: 18),
                  ),
                ],
              ),
              onTap: () async{
              var res = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FeedSettingsList(),
                  ),
                );
              if (res) widget.reload();
              },
            ),
            SizedBox(height: 20),
            InkWell(
              child: Row(
                children: [
                  Icon(Icons.settings, color: Colors.grey[800], size: 25),
                  SizedBox(width: 10),
                  Text(
                    'General settings',
                    style: TextStyle(color: Colors.grey[800], fontSize: 18),
                  ),
                ],
              ),
              onTap: () {Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GeneralSettingsScreen(),
                ),
              );
                },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Future<void> _onPressedVKLogInButton(BuildContext context) async {
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

      if (!loginResult.isCanceled) await _updateVKLoginInfo();
      widget.reload();
      //Navigator.of(context).pop();
    }
  }

  Future<void> _onPressedVKLogOutButton() async {
    widget.plugin.logOut();
    await _updateVKLoginInfo();
  }
}


