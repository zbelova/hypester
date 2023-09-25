import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hypester/presentation/widgets/gallery_preview_widget.dart';
import 'package:hypester/presentation/widgets/source_name_widgets.dart';
import 'package:intl/intl.dart';

import '../data/models/feed_model.dart';

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
                Text(widget.feed.posts[index].title!, style: TextStyle(fontSize: 18)),
                Text(
                  DateFormat('HH:mm dd.MM.yyyy').format(widget.feed.posts[index].date),
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(height: 8),
                if (widget.feed.posts[index].imageUrl != '' && widget.feed.posts[index].imageUrl != null) Image.network(widget.feed.posts[index].imageUrl!),
                if (widget.feed.posts[index].isGallery) GalleryPreview(imageUrls: widget.feed.posts[index].galleryUrls!),
                if (widget.feed.posts[index].body != null)
                  Text(
                    widget.feed.posts[index].body!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    //softWrap: false,
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SourceNameWidget(title: widget.feed.posts[index].sourceName),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                Divider(
                  color: Colors.grey[300],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

