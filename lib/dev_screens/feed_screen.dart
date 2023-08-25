import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/feed_model.dart';

class FeedScreen extends StatefulWidget {
  final Feed feed;
  FeedScreen({super.key, required this.feed});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Feed Screen'),
      ),
    );
  }
}
