import 'package:flutter/material.dart';

class TelegramNews extends StatefulWidget {
  const TelegramNews({Key? key}) : super(key: key);

  @override
  State<TelegramNews> createState() => _TelegramNewsState();
}

class _TelegramNewsState extends State<TelegramNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Telegram',
              style: TextStyle(color: Colors.blue),
            ),
            Text(
              'News',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),


      body: Container (
        height: 70,
        child: Column(
          children: [
            ListView.builder(itemBuilder: itemBuilder)
          ],
        ),
      ),
    );
  }
}
