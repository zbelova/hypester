import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../bloc/progress_bar/progress_bar_bloc.dart';
import '../../bloc/progress_bar/progress_bar_state.dart';
import '../../data/repository.dart';

class ProgressBar extends StatelessWidget {

  const ProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgressBarBloc(GetIt.I.get()),
      child: BlocBuilder<ProgressBarBloc, ProgressBarState>(builder: (context, state) {
        return switch (state) {
          LoadingProgressBarState() => _buildProgressBar(state),
          ErrorProgressBarState() => const Center(
              child: Text('Error loading progress'),
            ),
        };
      }),
    );
  }

  Widget _buildProgressBar(state) {
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
