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
              _handleClick(value, context);
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

  void _handleClick(String value, BuildContext context) {
    switch (value) {
      case 'Report':
        showGeneralDialog(context: context,
            pageBuilder: (context, anim1, anim2) => Container(),
            barrierColor: Colors.black.withOpacity(0.5),
            barrierDismissible: true,
            barrierLabel: '',
            transitionDuration: const Duration(milliseconds: 200),
            transitionBuilder: (context, anim1, anim2, child) {
              return Transform.scale(
                scale: anim1.value,
                child: Opacity(
                  opacity: anim1.value,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    title: Text('Report'),
                    content: Text('Are you sure you want to report this post?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _reportRepository.saveReport(widget.post.date, widget.post.sourceName, widget.post.linkToOriginal!, widget.post.id);
                          Navigator.of(context).pop();
                        },
                        child: Text('Report'),
                      ),
                    ],
                  ),
                ),
              );
            });
        break;
      case 'Share':
        Share.share(widget.post.linkToOriginal!);
        break;
    }
  }
}
