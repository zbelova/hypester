import '../../data/models/feed_model.dart';


sealed class HomePageState {
  const HomePageState();
}

class LoadingHomePageState extends HomePageState {
  final List<String> feedNames;
  final progress;

  const LoadingHomePageState({required this.feedNames, this.progress = 0.0});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingHomePageState &&
          runtimeType == other.runtimeType &&
          feedNames == other.feedNames &&
          progress == other.progress;

  @override
  int get hashCode => feedNames.hashCode ^ progress.hashCode;

}

class LoadedHomePageState extends HomePageState {
  final List<Feed> feeds;

  const LoadedHomePageState({required this.feeds});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadedHomePageState &&
          runtimeType == other.runtimeType &&
          feeds == other.feeds;

  @override
  int get hashCode => feeds.hashCode;
}

class ErrorHomePageState extends HomePageState {
  final List<String> feedNames;

  const ErrorHomePageState({this.feedNames = const []});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorHomePageState &&
          runtimeType == other.runtimeType &&
          feedNames == other.feedNames;

  @override
  int get hashCode => feedNames.hashCode;

}