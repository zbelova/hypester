//отдельная лента, то есть отдельная вкладка

import 'package:hypester/data/models/post_model.dart';

class Feed {
  final String keyword; //в случае если это главная страница, то keyword = 'all'
  final List<Post> posts;

  Feed({
    required this.keyword,
    required this.posts,
  });
}

