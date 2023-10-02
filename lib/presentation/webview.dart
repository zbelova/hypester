import 'package:flutter/material.dart';
import 'package:hypester/presentation/widgets/youtube_video.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    if (widget.post.relinkUrl!.startsWith('https://www.youtube.com/')) _isYoutube = true;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            setState(() {
            });
          },
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
        ),
      )
      ..loadRequest(Uri.parse(widget.post.relinkUrl!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.post.title != null ? widget.post.title! : '')),
      body: _showLoading &&!_isYoutube
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
      return YoutubeVideo(videoUrl: 'https://www.youtube.com/watch?v=XU0o5Ev__yc&amp;ab_channel=RCRevolutionGame',);
    }
  }
}
