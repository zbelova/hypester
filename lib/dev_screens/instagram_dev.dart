import 'package:flutter/material.dart';
// import 'package:hypester/facebook_auth.dart';

class InstagramPage extends StatefulWidget {
  const InstagramPage({super.key});

  @override
  State<InstagramPage> createState() => _InstagramPageState();
}

class _InstagramPageState extends State<InstagramPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Instagram'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Для поиска в Instagram необходима авторизация'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => MyFacebookLogin(
              //             plugin: plugin,
              //           )),
              // );
            },
            child: const Text('войти в Instagram через Facebook'),
          ),
        ],
      )),
    );
  }
}
