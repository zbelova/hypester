import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypester/bloc/progress_bar/progress_bar_event.dart';
import 'package:hypester/bloc/progress_bar/progress_bar_state.dart';
import '../../data/repository.dart';

class ProgressBarBloc extends Bloc<ProgressBarEvent, ProgressBarState> {
  final PostsRepository _postsRepository;

  ProgressBarBloc(this._postsRepository) : super(LoadingProgressBarState()) {
    on<LoadProgressBarEvent>(_onLoadEvent);
    _postsRepository.addListener(_update);
    add(LoadProgressBarEvent());
  }

  @override
  Future<void> close() {
    _postsRepository.removeListener(_update);
    return super.close();
  }

  void _update() {
    add(LoadProgressBarEvent(progress: _postsRepository.progress, oldProgress: _postsRepository.oldProgress));
  }

  Future<void> _onLoadEvent(LoadProgressBarEvent event, Emitter<ProgressBarState> emit) async {
    try {
      emit(LoadingProgressBarState(progress: event.progress, oldProgress: event.oldProgress));
    } catch (error) {
      print('Ошибка при загрузке прогресс бара: $error');
      emit(ErrorProgressBarState());
    }
  }
}
