import 'package:flutter/material.dart';

class TelegramPage extends StatefulWidget {
  const TelegramPage({super.key});

  @override
  State<TelegramPage> createState() => _TelegramPageState();
}

class _TelegramPageState extends State<TelegramPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade50),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectChannelPage()));
                      setState(() {});
                    },
                    child: const Text('Выбрать канал',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal)),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            )));
  }
}

class SelectChannelPage extends StatefulWidget {
  const SelectChannelPage({super.key});

  @override
  State<SelectChannelPage> createState() => _SelectChannelPageState();
}

class _SelectChannelPageState extends State<SelectChannelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление канала',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Тема',
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade50),
                      onPressed: () {},
                      child: const Text('Найти канал',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
