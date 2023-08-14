import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'data/user_preferences.dart';
import 'dev_screens/home_page.dart';
import 'hive/post_local_dto.dart';
import 'hive/subreddit_local_dto.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserPreferences().init();
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

