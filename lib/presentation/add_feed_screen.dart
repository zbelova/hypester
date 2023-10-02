import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AddFeedScreen extends StatefulWidget {
  const AddFeedScreen({super.key});

  @override
  State<AddFeedScreen> createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends State<AddFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add feed'),
      ),
      body: Placeholder(),
      // BlocProvider(
      //   create: (context) => AddFeedBloc(GetIt.I.get()),
      //   child: BlocBuilder<AddFeedBloc,AddFeedState>(
      //     builder: (context, state) {
      //       return Center(
      //         child: Column(
      //           children: [
      //
      //             //Text('Add feed'),
      //           ],
      //         ),
      //       );
      //     }
      //   ),
      // ),
    );
  }
}
