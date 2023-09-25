import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypester/bloc/homepage/homepage_event.dart';
import 'package:hypester/bloc/homepage/homepage_state.dart';

import '../../data/repository.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final PostsRepository _postsRepository;

  HomePageBloc(this._postsRepository) : super(const LoadingHomePageState()) {
    on<LoadHomePageEvent>(_onLoadEvent);
    add(LoadHomePageEvent());
  }

  Future<void> _onLoadEvent(LoadHomePageEvent event, Emitter<HomePageState> emit) async {
    emit(const LoadingHomePageState());
    try {
      final feeds= await _postsRepository.getAllFeeds();
      emit(LoadedHomePageState(feeds: feeds));
    } catch (error, stackTrace) {
      emit(ErrorHomePageState());
    }
  }
}