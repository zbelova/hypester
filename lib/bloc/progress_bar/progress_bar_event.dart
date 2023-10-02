class ProgressBarEvent {}

class LoadProgressBarEvent extends ProgressBarEvent {
  final double progress;
  final double oldProgress;

  LoadProgressBarEvent({
    this.progress = 0.0,
    this.oldProgress = 0.0,
  });
}
