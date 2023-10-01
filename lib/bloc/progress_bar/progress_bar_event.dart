class ProgressBarEvent {
}

class LoadProgressBarEvent extends ProgressBarEvent {
  final double progress;


  LoadProgressBarEvent({
    this.progress = 0.0,

  });
}