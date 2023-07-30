import 'package:flutter/material.dart';
import 'data/user_preferences.dart';
import 'dev_screens/layout_dev.dart';
import 'dev_screens/model_arch_dev.dart';
import 'dev_screens/reddit_dev.dart';
import 'dev_screens/telegram_dev.dart';
import 'dev_screens/twitter_dev.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  UserPreferences().init();
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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Hypester Home Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LayoutPage()),
                  );
                },
                child: const Text('Верстка'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TwitterPage()),
                  );
                },
                child: const Text('Twitter'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RedditPage()),
                  );
                },
                child: const Text('Reddit'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TelegramPage()),
                  );
                },
                child: const Text('Telegram'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ModelArchPage()),
                  );
                },
                child: const Text('Model Arch'),
              ),
            ],
          ),
        ),
      )
    );
  }
}

