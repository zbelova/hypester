import 'package:intl/intl.dart';

import '../data/models/post_model.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  final Post post;

  const PostScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(post.title!= null) Text(post.title!, style: Theme.of(context).textTheme.titleMedium),
              Text(
                post.date.toString(),
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              const SizedBox(height: 8),
              if (post.imageUrl != '' && post.imageUrl != null)
                Image.network(post.imageUrl!),
              if (post.body != null)
                Text(
                  post.body!,
                  //softWrap: false,
                ),
              Text(
                DateFormat('HH:mm dd.MM.yyyy').format(post.date),
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      post.sourceName,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                 if(post.channel != null) Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      post.channel!,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Spacer(),
                  if (post.views!=null) ...[
                    const Icon(Icons.remove_red_eye_outlined, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      post.views.toString(),
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
                    post.likes.toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ]
        )
      ),
    );
  }
}
