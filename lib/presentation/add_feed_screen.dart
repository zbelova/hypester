import 'package:flutter/material.dart';

class AddFeedScreen extends StatefulWidget {
  const AddFeedScreen({super.key});

  @override
  State<AddFeedScreen> createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends State<AddFeedScreen> {
  final TextEditingController _keywordController = TextEditingController();
  final TextEditingController _redditUpsController = TextEditingController();
  final TextEditingController _vkLikesController = TextEditingController();
  final TextEditingController _vkViewsController = TextEditingController();
  final TextEditingController _youtubeLikesController = TextEditingController();
  final TextEditingController _youtubeViewsController = TextEditingController();
  final TextEditingController _telegramViewsController = TextEditingController();
  final TextEditingController _instagramLikesController = TextEditingController();
  bool _redditSearchInSubreddits = false;
  bool _youtubeSearchInChannels = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _keywordController.dispose();
    _redditUpsController.dispose();
    _vkLikesController.dispose();
    _vkViewsController.dispose();
    _youtubeLikesController.dispose();
    _youtubeViewsController.dispose();
    _telegramViewsController.dispose();
    _instagramLikesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Add feed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _keywordController,
                decoration: const InputDecoration(
                  labelText: 'Keyword',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 5),
              const Text('Choose a keyword that will be used to search for content for the new feed.'),
              const SizedBox(height: 15),
              const Text(
                'Settings for each source when enabled:',
                style: TextStyle(fontSize: 18),
              ),
              _buildRedditSettings(),
              _buildYoutubeSettings(),
              _buildVkSettings(),
              _buildTelegramSettings(),
              _buildInstagramSettings(),
              const SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, _keywordController.text);
                    },
                    child: const Text('Add'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRedditSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Reddit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        RadioListTile<bool>(
          title: const Text('Search in posts everywhere'),
          value: false,
          groupValue: _redditSearchInSubreddits,
          onChanged: (bool? value) {
            setState(() {
              _redditSearchInSubreddits = value!;
            });
          },
        ),
        RadioListTile<bool>(
          title: const Text('Search in subreddit names and show posts from them'),
          value: true,
          groupValue: _redditSearchInSubreddits,
          onChanged: (bool? value) {
            setState(() {
              _redditSearchInSubreddits = value!;
            });
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(
              width: 130,
              child: Text(
                'Ups threshold',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 70,
              height: 40,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _redditUpsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVkSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'VK',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const Text(
          'Only search in group names available. You will see new posts from the groups found.',
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            const SizedBox(
              width: 130,
              child: Text(
                'Likes threshold',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 70,
              height: 40,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _vkLikesController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const SizedBox(
              width: 130,
              child: Text(
                'Views threshold',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 70,
              height: 40,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _vkViewsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTelegramSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Telegram',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const Text(
          'Only search in channel names available. You will see new posts from the channels found.',
        ),
        const SizedBox(height: 15),
        const SizedBox(height: 5),
        Row(
          children: [
            const SizedBox(
              width: 130,
              child: Text(
                'Views threshold',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 70,
              height: 40,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _telegramViewsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildYoutubeSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Youtube',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        RadioListTile<bool>(
          title: const Text('Search in titles everywhere'),
          value: false,
          groupValue: _youtubeSearchInChannels,
          onChanged: (bool? value) {
            setState(() {
              _youtubeSearchInChannels = value!;
            });
          },
        ),
        RadioListTile<bool>(
          title: const Text('Search in channel names and show videos from them'),
          value: true,
          groupValue: _youtubeSearchInChannels,
          onChanged: (bool? value) {
            setState(() {
              _youtubeSearchInChannels = value!;
            });
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(
              width: 130,
              child: Text(
                'Likes threshold',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 70,
              height: 40,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _youtubeLikesController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const SizedBox(
              width: 130,
              child: Text(
                'Views threshold',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 70,
              height: 40,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _youtubeViewsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInstagramSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Instagram',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Only search in description text available.',
          ),
        ),
        const SizedBox(height: 15),
        const SizedBox(height: 5),
        Row(
          children: [
            const SizedBox(
              width: 130,
              child: Text(
                'Likes threshold',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 70,
              height: 40,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _instagramLikesController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
