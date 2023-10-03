import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hypester/youtube/api_keys.dart';
import 'package:hypester/youtube/video_player_screen.dart';

class YoutubeSearchScreen extends StatefulWidget {
  const YoutubeSearchScreen({super.key});
  @override
  State<YoutubeSearchScreen> createState() => _YoutubeSearchScreenState();
}

class _YoutubeSearchScreenState extends State<YoutubeSearchScreen> {
  List<dynamic> videos = [];

  Future<void> searchVideos(String query) async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=20&q=$query&key=$youTubeApiKey'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        videos = data['items'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent[700],
        title: const Text('YouTube Search'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (value) async {
                await searchVideos(value);
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    openVideo(videos[index]['id']['videoId']);
                  },
                  child: ListTile(
                    leading: Image.network(videos[index]['snippet']
                        ['thumbnails']['default']['url']),
                    title: Text(videos[index]['snippet']['title']),
                    subtitle: Row(children: [
                      Text(videos[index]['snippet']['channelTitle']),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

//просмотр видео на новой странице
  openVideo(String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => VideoPlayerScreen(
          videoId: videoId,
        ),
      ),
    );
  }
}
