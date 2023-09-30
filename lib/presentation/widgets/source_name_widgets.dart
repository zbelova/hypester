import 'package:flutter/material.dart';

class SourceNameWidget extends StatelessWidget {
  SourceNameWidget({
    super.key,
    required this.title,
  });

  final Map<String, Color> _colors = {
    'Reddit': const Color(0xFFFF5E10),
    'Youtube': const Color(0xFFFF2424),
    'Telegram': const Color(0xFF33C6FF),
    'VK': const Color(0xFF3091FF),
    'Instagram': const Color(0xFFE1306C),
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
        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}