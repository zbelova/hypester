import 'package:flutter/material.dart';

class InstagramPage extends StatefulWidget {
  const InstagramPage({super.key});

  @override
  State<InstagramPage> createState() => _InstagramPageState();
}

class _InstagramPageState extends State<InstagramPage> {
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
                              builder: (context) => const SelectTwitPage()));
                      setState(() {});
                    },
                    child: const Text('Выбрать хештег',
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

class SelectTwitPage extends StatefulWidget {
  const SelectTwitPage({super.key});

  @override
  State<SelectTwitPage> createState() => _SelectTwitPageState();
}

class _SelectTwitPageState extends State<SelectTwitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление хештегов',
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
                      child: const Text('Найти хештег',
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
