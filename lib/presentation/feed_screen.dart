import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hypester/presentation/post_screen.dart';
import 'package:hypester/presentation/webview.dart';
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
            return InkWell(
              onTap: () {
                if (widget.feed.posts[index].relinkUrl != null && widget.feed.posts[index].relinkUrl != '') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(post: widget.feed.posts[index])));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(post: widget.feed.posts[index], keyword: widget.feed.keyword)));
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.feed.posts[index].title != '' && widget.feed.posts[index].title != null)
                        Container(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
                          child: Text(
                            widget.feed.posts[index].title!,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    DateFormat('HH:mm dd.MM.yyyy').format(widget.feed.posts[index].date),
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 8),
                  if (widget.feed.posts[index].imageUrl != '' && widget.feed.posts[index].imageUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.feed.posts[index].imageUrl!,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.grey[500],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  if (widget.feed.posts[index].isGallery) GalleryPreview(imageUrls: widget.feed.posts[index].galleryUrls!),

                  Row(
                    children: [
                      if (widget.feed.posts[index].isVideo && widget.feed.posts[index].relinkUrl != null && widget.feed.posts[index].relinkUrl != '' && widget.feed.posts[index].sourceName == 'VK') ...[
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Image.asset(
                            'assets/images/vkvideo.png',
                            width: 40,
                          ),
                        ),
                      ],
                      if (!widget.feed.posts[index].isVideo &&
                          widget.feed.posts[index].relinkUrl != null &&
                          widget.feed.posts[index].relinkUrl != '' &&
                          widget.feed.posts[index].sourceName == 'VK') ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/multimedia.png',
                            width: 40,
                          ),
                        ),
                      ],
                      if (widget.feed.posts[index].body != null)
                        Expanded(
                          child: Text(
                            widget.feed.posts[index].body!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            //softWrap: false,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      SourceNameWidget(title: widget.feed.posts[index].sourceName),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        margin: const EdgeInsets.only(right: 5),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          widget.feed.posts[index].channel!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      if (widget.feed.posts[index].relinkUrl != '' && widget.feed.posts[index].relinkUrl != null) ...[
                        const SizedBox(width: 5),
                        const Icon(Icons.link, size: 25),
                      ],
                      Spacer(),
                      if (widget.feed.posts[index].views! > 0) ...[
                        const Icon(Icons.remove_red_eye_outlined, size: 13),
                        const SizedBox(width: 3),
                        Text(
                          widget.feed.posts[index].views.toString(),
                          style: TextStyle(fontSize: 13),
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
                      const SizedBox(width: 5),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    color: Colors.grey[300],
                    height: 20,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
