import 'package:flutter/material.dart';
import 'package:hypester/bloc/homepage/homepage_state.dart';


class LoadingProgressBar extends StatelessWidget {
  final state;

  const LoadingProgressBar({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: state.progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
            ),
            Text('Loading posts...'),
          ],
        ),
      ),
    );
  }
}


