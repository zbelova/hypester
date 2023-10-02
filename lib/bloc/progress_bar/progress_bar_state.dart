sealed class ProgressBarState {
  const ProgressBarState();
}

class LoadingProgressBarState extends ProgressBarState {
  final double progress;
  final double oldProgress;
  final List<String> activeSources;

  const LoadingProgressBarState({
    this.progress = 0.0,
    this.oldProgress = 0.0,
    this.activeSources = const [],
  });

  @override
  bool operator ==(Object other) => identical(this, other) || other is LoadingProgressBarState && runtimeType == other.runtimeType && progress == other.progress;

  @override
  int get hashCode => progress.hashCode;
}

class ErrorProgressBarState extends ProgressBarState {}
