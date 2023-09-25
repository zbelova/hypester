import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/feed_model.dart';
import '../models/post_model.dart';

class FeedScreen extends StatefulWidget {
  final Feed feed;

  const FeedScreen({super.key, required this.feed});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: widget.feed.posts.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.feed.posts[index].title!, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  DateFormat('HH:m dd.MM.yyyy').format(widget.feed.posts[index].date),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                if (widget.feed.posts[index].imageUrl != null) Image.network(widget.feed.posts[index].imageUrl!),
                if (widget.feed.posts[index].body != null)
                  Text(
                    widget.feed.posts[index].body!,
                    overflow: TextOverflow.fade,
                    maxLines: 4,
                    //softWrap: false,
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        widget.feed.posts[index].sourceName,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        widget.feed.posts[index].channel!,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Spacer(),
                    if (widget.feed.posts[index].views! > 0) ...[
                      const Icon(Icons.remove_red_eye_outlined, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        widget.feed.posts[index].views.toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 5),
                    ],
                    const Icon(
                      Icons.favorite_outline,
                      size: 12,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      widget.feed.posts[index].likes.toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
