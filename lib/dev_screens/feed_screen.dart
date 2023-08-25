import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/feed_model_dev.dart';
import '../models/post_model_dev.dart';

class FeedScreen extends StatefulWidget {
  final Feed feed;

  const FeedScreen({super.key, required this.feed});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<Post> posts = [
    Post(
      id: "1",
      title: 'Does this card warrant hate? I use it as an anti-boardwipe in a giant tribal deck.',
      date: DateTime.now(),
      imageUrl: 'https://preview.redd.it/1hvba217b0kb1.jpg?width=640&crop=smart&auto=webp&s=a1b3d36787ff630e6a00a0e2249f845452ea00c4',
      //body: 'Текст поста 1',
      source: 'Reddit',
      views: 100,
      linkUrl: 'https://www.reddit.com/r/mtg/comments/15zu7jj/does_this_card_warrant_hate_i_use_it_as_an/',
      likes: '100',
      channel: 'mtg',
    ),
    Post(
      id: "1",
      title: 'Took a nap at a “Rastplatz” and someone wanted to know if I was there for a date?',
      date: DateTime.now(),
      //imageUrl: 'https://preview.redd.it/1hvba217b0kb1.jpg?width=640&crop=smart&auto=webp&s=a1b3d36787ff630e6a00a0e2249f845452ea00c4',
      body:
          "The weirdest thing happened last night. My flight was cancelled so I hired a car which was a massive SUV (last car) and drove the 8 hours to my destination. I am a young woman and wearing a business suit at this stage. At 1:30am I was so tired and just took a 15 min nap at a Rastplatz. A DHL truck pulls up next to me, looks at me and a young man gets out, knocks on my window. At first I’m like?? What is happening here. I start the car to open the window because I’m not opening my door, and the man asks me if I am here for “a date”. What?? What does he mean a date? Who has a date at this type of place. I tell him no, I’m taking a quick nap because I have a long way to drive. He says sorry and looks bewildered that I am not there for a “date”. Then he tells me it’s strange that I’m there if it isn’t for a date. I told the man good luck with his endeavours and drove away. I have no idea what happened. I’m not even sure what the conversation was about.Edit: Well this has most certainly taken an interesting turn.",
      source: 'Reddit',
      views: 100,
      linkUrl: 'https://www.reddit.com/r/germany/comments/160u864/took_a_nap_at_a_rastplatz_and_someone_wanted_to/',
      likes: '100',
      channel: 'germany',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(posts[index].title, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  DateFormat('HH:m dd.MM.yyyy').format(posts[index].date),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                if (posts[index].imageUrl != null)
                  ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.transparent],
                      ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(posts[index].imageUrl!),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                if (posts[index].body != null)
                  Text(
                    posts[index].body!,
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
                        posts[index].source,
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
                        posts[index].channel,
                      ),
                    ),
                    Spacer(),
                    const Icon(Icons.remove_red_eye_outlined, size: 15),
                    const SizedBox(width: 3),
                    Text(posts[index].views.toString()),
                    SizedBox(width: 5),
                    const Icon(
                      Icons.favorite,
                      size: 15,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 3),
                    Text(posts[index].likes),
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
