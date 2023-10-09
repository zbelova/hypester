import 'package:flutter/material.dart';
import 'package:hypester/presentation/widgets/youtube_video.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../data/models/post_model.dart';

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

  @override
  void initState() {
    super.initState();
    if ( (widget.post.relinkUrl!.startsWith('https://www.youtube.com/') || widget.post.relinkUrl!.startsWith('https://youtu.be/'))) _isYoutube = true;
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
      appBar: AppBar(title: Text(widget.post.title != null ? widget.post.title! : '')),
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
}
