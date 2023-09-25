import '../../data/models/feed_model.dart';


sealed class HomePageState {
  const HomePageState();
}

class LoadingHomePageState extends HomePageState {
  const LoadingHomePageState();
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

class ErrorHomePageState extends HomePageState {}