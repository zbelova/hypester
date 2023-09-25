import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hypester/data/repository.dart';
import 'package:hypester/presentation/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'data/datasource/reddit_datasource.dart';
import 'data/hive/post_local_dto.dart';
import 'data/hive/subreddit_local_dto.dart';
import 'data/user_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserPreferences().init();
  GetIt.I.registerSingleton(RedditDataSource());
  GetIt.I.registerSingleton(PostsRepository(GetIt.I.get()));

  // код для инициализации Hive
  final directory = await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapter(RedditPostLocalDtoAdapter())
    ..registerAdapter(SubredditLocalDtoAdapter());

  runApp(const Hypester());
}

class Hypester extends StatelessWidget {
  const Hypester({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hypester',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

