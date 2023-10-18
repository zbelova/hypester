import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hypester/presentation/widgets/youtube_video.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../data/models/post_model.dart';
import '../data/report_repository.dart';

class WebViewScreen extends StatefulWidget {
  final Post post;

  const WebViewScreen({super.key, required this.post});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _showLoading = true;
  bool _isYoutube = false;
  ReportRepository _reportRepository = GetIt.I.get();
  String selectedOption = 'Content of a sexual nature';

  @override
  void initState() {
    super.initState();
    if ((widget.post.relinkUrl!.startsWith('https://www.youtube.com/') || widget.post.relinkUrl!.startsWith('https://youtu.be/'))) _isYoutube = true;
    if (!_isYoutube) {
      // #docregion platform_features
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

      if (controller.platform is AndroidWebViewController) {}

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              setState(() {
                _showLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (_isYoutube) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onUrlChange: (UrlChange change) {},
          ),
        )
        ..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        )
        ..loadRequest(Uri.parse(widget.post.relinkUrl!));

      // #docregion platform_features
      if (controller.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
      }
      // #enddocregion platform_features

      _controller = controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title != null ? widget.post.title! : ''),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              _handlePopupItemClick(value, context);
            },
            elevation: 1,
            itemBuilder: (BuildContext context) {
              return {'Share', 'Report'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Row(
                    children: [
                      Icon(
                        choice == 'Share' ? Icons.ios_share : Icons.report_outlined,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(choice),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _showLoading && !_isYoutube
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.cyan,
            ))
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (!_isYoutube) {
      return WebViewWidget(controller: _controller);
    } else {
      return YoutubeVideo(videoUrl: widget.post.relinkUrl!, post: widget.post);
    }
  }

  void _handlePopupItemClick(String value, BuildContext context) {
    switch (value) {
      case 'Report':
        showGeneralDialog(
            context: context,
            pageBuilder: (context, anim1, anim2) => Container(),
            barrierColor: Colors.black.withOpacity(0.5),
            barrierDismissible: true,
            barrierLabel: '',
            transitionDuration: const Duration(milliseconds: 200),
            transitionBuilder: (context, anim1, anim2, child) {
              return StatefulBuilder(builder: (context, setState) {
                return Transform.scale(
                  scale: anim1.value,
                  child: Opacity(
                    opacity: anim1.value,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      title: Text('Report'),
                      //content: Text('Are you sure you want to report this post?'),
                      content: SizedBox(
                        width: 300,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: ListView(
                          padding: const EdgeInsets.all(0),
                          children: [
                            Text('Choose a reason for the report:'),
                            ListTile(
                              title: Text('Content of a sexual nature'),
                              leading: Radio(
                                value: 'Content of a sexual nature',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Violent or repulsive scenes'),
                              leading: Radio(
                                value: 'Violent or repulsive scenes',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Verbal abuse or intolerance'),
                              leading: Radio(
                                value: 'Verbal abuse or intolerance',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Harassment or bullying'),
                              leading: Radio(
                                value: 'Harassment or bullying',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Harmful or dangerous actions'),
                              leading: Radio(
                                value: 'Harmful or dangerous actions',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('False information'),
                              leading: Radio(
                                value: 'False information',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Cruelty towards children'),
                              leading: Radio(
                                value: 'Cruelty towards children',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Terrorism propaganda'),
                              leading: Radio(
                                value: 'Terrorism propaganda',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Spam or false information'),
                              leading: Radio(
                                value: 'Spam or false information',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Violation of the law'),
                              leading: Radio(
                                value: 'Violation of the law',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Other'),
                              leading: Radio(
                                value: 'Other',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            _reportRepository.saveReport(widget.post.date, widget.post.sourceName, widget.post.linkToOriginal!, widget.post.id, selectedOption);
                            Navigator.of(context).pop();
                          },
                          child: Text('Report'),
                        ),
                      ],
                    ),
                  ),
                );
              });
            });
        break;
      case 'Share':
        Share.share(widget.post.linkToOriginal!);
        break;
    }
  }
}
