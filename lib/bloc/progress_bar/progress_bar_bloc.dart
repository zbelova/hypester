import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hypester/bloc/progress_bar/progress_bar_event.dart';
import 'package:hypester/bloc/progress_bar/progress_bar_state.dart';

import '../../data/datasource/reddit_datasource.dart';
import '../../data/datasource/vk_datasource.dart';

class ProgressBarBloc extends Bloc<ProgressBarEvent, ProgressBarState> {
  final RedditDataSource _redditDataSource = RedditDataSource();
  final VKDataSource _vkDataSource = VKDataSource(GetIt.I.get());

  ProgressBarBloc() : super(const LoadingProgressBarState()) {
    on<LoadProgressBarEvent>(_onLoadEvent);
    _redditDataSource.addListener(_updateReddit);
    _vkDataSource.addListener(_updateVK);
    add(LoadProgressBarEvent());
  }

  @override
  Future<void> close() {
    _redditDataSource.removeListener(_updateReddit);
    _vkDataSource.removeListener(_updateVK);
    return super.close();
  }

  void _updateReddit() {
    add(LoadProgressBarEvent(redditReady: true));
  }

  void _updateVK() {
    add(LoadProgressBarEvent(vkReady: true));
  }

  Future<void> _onLoadEvent(LoadProgressBarEvent event, Emitter<ProgressBarState> emit) async {
    try {
      double progress = 0.0;
      if (event.redditReady) {
        progress += 0.5;
      }
      if (event.vkReady) {
        progress += 0.5;
      }
      emit(LoadingProgressBarState(progress: progress, redditReady: event.redditReady, vkReady: event.vkReady));
    } catch (error) {
      print('Ошибка при загрузке прогресс бара: $error');
      emit(ErrorProgressBarState());
    }
  }
}