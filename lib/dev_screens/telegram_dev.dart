import 'package:flutter/material.dart';

import 'package:hypester/telegram_only/telegram_news.dart';


class TelegramPage extends StatefulWidget {
  const TelegramPage({super.key});

  @override
  State<TelegramPage> createState() => _TelegramPageState();
}

class _TelegramPageState extends State<TelegramPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Telegram'),
      ),
      body: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelegramNews()),
              );
            },
            child: const Text('Telegram'),
          ),
    );
  }
}
