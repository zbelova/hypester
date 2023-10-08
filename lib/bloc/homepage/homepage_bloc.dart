import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hypester/bloc/homepage/homepage_event.dart';
import 'package:hypester/bloc/homepage/homepage_state.dart';
import 'package:hypester/data/user_preferences.dart';
import '../../data/hive/feed_filters_local_data_source.dart';
import '../../data/repository.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final PostsRepository _postsRepository;
  final FeedFiltersLocalDataSource _feedFiltersLocalDataSource = GetIt.I.get();

  HomePageBloc(this._postsRepository) : super(LoadingHomePageState(feedNames: UserPreferences().getKeywords()..insert(0, 'All'))) {
    on<LoadHomePageEvent>(_onLoadEvent);
    add(LoadHomePageEvent());
  }

  Future<void> _onLoadEvent(LoadHomePageEvent event, Emitter<HomePageState> emit) async {
    var feedNames = await _feedFiltersLocalDataSource.getAll().then((value) => value.map((e) => e.keyword).toList()..insert(0, 'All'));
    emit(LoadingHomePageState(feedNames: feedNames));
    try {
      final feeds = await _postsRepository.getAllFeeds();
      emit(LoadedHomePageState(feeds: feeds, feedNames: feedNames));
    } catch (error, stackTrace) {
      emit(ErrorHomePageState(feedNames: feedNames));
    }
  }
}
