import 'package:flutter/material.dart';

class SourceNameWidget extends StatelessWidget {
  SourceNameWidget({
    super.key,
    required this.title,
  });

  final Map<String, Color> _colors = {
    'Reddit': const Color(0xFFFFCBB0),
    'Youtube': const Color(0xFFFFA4A4),
    'Telegram': const Color(0xFF84DAFF),
  };

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: _colors[title],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12,),
      ),
    );
  }
}