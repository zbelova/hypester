import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../data/models/post_model.dart';

class YoutubeVideo extends StatefulWidget {
  final String videoUrl;
  final Post post;

  const YoutubeVideo({super.key, required this.videoUrl, required this.post});

  @override
  State<YoutubeVideo> createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
  late YoutubePlayerController _controller;

  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);

    _videoMetaData = const YoutubeMetaData();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,

        // bottomActions: [
        //   PlayPauseButton(),
        // ],
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {},
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {},
      ),
      builder: (context, player) => Scaffold(
        body: ListView(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _space,
                    Text( widget.post.title?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        )),
                    _space,
                    Text(widget.post.channel ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0,
                        )),
                    _space,
                    Wrap(
                      children: [
                        Icon(Icons.remove_red_eye_outlined, size: 20, color: Colors.grey,),
                        SizedBox(width: 5,),
                        Text(
                          widget.post.views.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0,
                          ),
                        ),
                      ]
                    ),
                    _space,
                    Text(
                      widget.post.body ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget get _space => const SizedBox(height: 10);
}
