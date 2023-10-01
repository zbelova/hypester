sealed class ProgressBarState {
  const ProgressBarState();
}

class LoadingProgressBarState extends ProgressBarState {
  final double progress;
  final bool redditReady;
  final bool vkReady;
  final bool telegramReady;
  final bool youtubeReady;
  final bool instagramReady;


  const LoadingProgressBarState({
    this.progress = 0.0,
    this.redditReady = false,
    this.vkReady = false,
    this.telegramReady = false,
    this.youtubeReady = false,
    this.instagramReady = false,
  });

}

class ErrorProgressBarState extends ProgressBarState {}