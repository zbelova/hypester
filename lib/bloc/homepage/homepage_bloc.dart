import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypester/bloc/homepage/homepage_event.dart';
import 'package:hypester/bloc/homepage/homepage_state.dart';
import 'package:hypester/data/user_preferences.dart';

import '../../data/repository.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final PostsRepository _postsRepository;

  HomePageBloc(this._postsRepository) : super(LoadingHomePageState(feedNames: UserPreferences().getKeywords()..insert(0, 'All'))) {
    on<LoadHomePageEvent>(_onLoadEvent);
    add(LoadHomePageEvent());
  }

  Future<void> _onLoadEvent(LoadHomePageEvent event, Emitter<HomePageState> emit) async {
    emit( LoadingHomePageState(feedNames: UserPreferences().getKeywords()..insert(0, 'All')));
    try {
      final feeds= await _postsRepository.getAllFeeds();
      emit(LoadedHomePageState(feeds: feeds));
    } catch (error, stackTrace) {
      emit(ErrorHomePageState(feedNames: UserPreferences().getKeywords()..insert(0, 'All')));
    }
  }
}