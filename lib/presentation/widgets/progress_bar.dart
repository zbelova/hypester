import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../bloc/progress_bar/progress_bar_bloc.dart';
import '../../bloc/progress_bar/progress_bar_state.dart';
import '../../data/repository.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Длительность анимации
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgressBarBloc(GetIt.I.get()),
      child: BlocBuilder<ProgressBarBloc, ProgressBarState>(builder: (context, state) {
        return switch (state) {
          LoadingProgressBarState() => _buildProgressBar(state),
          ErrorProgressBarState() =>
          const Center(
            child: Text('Error loading progress'),
          ),
        };
      }),
    );
  }

  Widget _buildProgressBar(state) {
    _controller.animateTo(state.progress, duration: const Duration(milliseconds: 1000));
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedProgressBar(
              animation: _controller,
              widget: FAProgressBar(
                currentValue: state.progress * 100,
                maxValue: 100,
                displayText: '%',
                borderRadius: BorderRadius.circular(10),
                progressColor: Colors.orangeAccent,
                backgroundColor: Colors.grey[200]!,
              ),
            ),
            SizedBox(height: 20),
            Text('Loading content from ${state.activeSources.join(', ')}...'),
          ],
        ),
      ),
    );
  }
}
