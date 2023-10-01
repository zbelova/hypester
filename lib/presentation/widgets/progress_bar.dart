import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/progress_bar/progress_bar_bloc.dart';
import '../../bloc/progress_bar/progress_bar_state.dart';

class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({
    Key? key,
    this.progress = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgressBarBloc(),
      child: BlocBuilder<ProgressBarBloc, ProgressBarState>(builder: (context, state) {
        return switch (state) {
          LoadingProgressBarState() => _buildProgressBar(),
          ErrorProgressBarState() => const Center(
              child: Text('Error loading progress'),
            ),
        };
      }),
    );
  }

  Widget _buildProgressBar() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
          ),
          Text('Loading posts...'),
        ],
      ),
    );
  }
}
