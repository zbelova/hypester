import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hypester/presentation/widgets/loading_progress_bar.dart';
import 'package:hypester/presentation/widgets/progress_bar.dart';

import '../bloc/test_bloc/test_bloc.dart';
import '../bloc/test_bloc/test_state.dart';
import '../data/repository.dart';

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
      body: BlocProvider(
        create: (context) => TestBloc(GetIt.I.get()),
        child: BlocBuilder<TestBloc,TestState>(
          builder: (context, state) {
            return Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      PostsRepository(GetIt.I.get(), GetIt.I.get()).getAllFeeds();
                    },
                    child: Text('Reload'),
                  ),
                  LoadingProgressBar(state: state),
                  //Text('Add feed'),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
