import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hypester/data/hive/feed_filters_local_data_source.dart';
import 'package:hypester/presentation/feed_edit_settings_screen.dart';

import '../data/hive/feed_filters.dart';

class FeedSettingsList extends StatefulWidget {
  const FeedSettingsList({super.key});

  @override
  State<FeedSettingsList> createState() => _FeedSettingsListState();
}

class _FeedSettingsListState extends State<FeedSettingsList> {
  final FeedFiltersLocalDataSource _feedFiltersLocalDataSource = GetIt.I.get();
  List<FeedFilters> feeds = [];
  bool _updateFeeds = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadFeedsList() async {
    feeds = await _feedFiltersLocalDataSource.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed settings'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(_updateFeeds);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder(
        future: _loadFeedsList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 8.0,
              ),
              child: ListView.builder(
                itemCount: feeds.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditFeedScreen(keyword: feeds[index].keyword)));
                      },
                      child: Text(
                        feeds[index].keyword,
                        maxLines: 3,
                      ),
                    ),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditFeedScreen(keyword: feeds[index].keyword)));
                          },
                          icon: const Icon(Icons.settings),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await _feedFiltersLocalDataSource.delete(feeds[index].keyword);
                            _updateFeeds = true;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
