import 'package:hypester/presentation/widgets/source_name_widgets.dart';
import 'package:intl/intl.dart';

import '../data/models/post_model.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  final Post post;
  final String keyword;

  const PostScreen({super.key, required this.post, required this.keyword});

  @override
  Widget build(BuildContext context) {
    var titleLength = post.title != null ? post.title!.length : 0;
    var maxLines = 3;
    var toolBarHeight = 60.0;
    if (titleLength > 50) {
      maxLines = 4;
      toolBarHeight = 100.0;
    }
    if (titleLength > 100) {
      maxLines = 5;
      toolBarHeight = 120.0;
    }
    if (titleLength > 150) {
      maxLines = 6;
      toolBarHeight = 140.0;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: toolBarHeight,
        title: (post.title != null)
            ? Text(
                post.title!,
                style: const TextStyle(fontSize: 18),
                maxLines: maxLines,
              )
            : null,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: ListView(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //const SizedBox(height: 8),
                if (post.imageUrl != '' && post.imageUrl != null)
                  Image.network(
                    post.imageUrl!,
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
                if (post.body != null)
                  Text(
                    post.body!,
                    style: const TextStyle(fontSize: 15),
                    //softWrap: false,
                  ),
                if (post.isGallery) _buildGallery(post.galleryUrls!),
                Text(
                  DateFormat('HH:mm dd.MM.yyyy').format(post.date),
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SourceNameWidget(title: post.sourceName),
                    if (post.channel != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          post.channel!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    const Spacer(),
                    if (post.views != null) ...[
                      const Icon(Icons.remove_red_eye_outlined, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        post.views.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 5),
                    ],
                    const Icon(
                      Icons.favorite_outline,
                      size: 12,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      post.likes.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ]),
            ],
          )),
    );
  }

  Widget _buildGallery(List<String> imageUrls) {
    return Column(
      children: [
        const SizedBox(height: 15),
        for (var imageUrl in imageUrls)
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }
}
