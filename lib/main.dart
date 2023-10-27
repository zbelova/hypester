import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_vk/flutter_login_vk.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hypester/data/datasource/report_firabase_datasource.dart';
import 'package:hypester/data/datasource/telegram_datasource.dart';
import 'package:hypester/data/datasource/youtube_datasource.dart';
import 'package:hypester/data/hive/feed_filters.dart';
import 'package:hypester/data/hive/feed_filters_local_data_source.dart';
import 'package:hypester/data/posts_repository.dart';
import 'package:hypester/data/report_repository.dart';
import 'package:hypester/presentation/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'data/datasource/reddit_datasource.dart';
import 'data/datasource/vk_datasource.dart';
import 'data/hive/post_local_dto.dart';
import 'data/hive/subreddit_local_dto.dart';
import 'data/user_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserPreferences().init();

  final dio = Dio();
  dio.transformer = BackgroundTransformer()..jsonDecodeCallback = parseJson;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // код для инициализации Hive
  final directory = await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapter(RedditPostLocalDtoAdapter())
    ..registerAdapter(SubredditLocalDtoAdapter())
    ..registerAdapter(FeedFiltersAdapter());


  GetIt.I.registerSingleton(dio);
  GetIt.I.registerSingleton(RedditDataSource());
  GetIt.I.registerSingleton(VKDataSource(dio));
  GetIt.I.registerSingleton(FeedFiltersLocalDataSource());
  GetIt.I.registerSingleton(TelegramDataSource());
  GetIt.I.registerSingleton(YoutubeDataSource(dio));
  GetIt.I.registerSingleton(PostsRepository(GetIt.I.get(), GetIt.I.get(), GetIt.I.get(), GetIt.I.get(), GetIt.I.get()));
  GetIt.I.registerSingleton(ReportFirebaseDatasource());
  GetIt.I.registerSingleton(ReportRepository(GetIt.I.get()));



  final plugin = VKLogin();
  await plugin.initSdk();

  runApp(Hypester(plugin: plugin));
}

class Hypester extends StatelessWidget {
  final VKLogin plugin;

  const Hypester({super.key, required this.plugin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hypester',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(plugin: plugin),
    );
  }
}

Map<String, dynamic> _parseAndDecode(String response) {
  final decoded = jsonDecode(response);

  return decoded as Map<String, dynamic>;
}

Future<Map<String, dynamic>> parseJson(String text) {
  return compute(_parseAndDecode, text);
}
