import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hypester/bloc/progress_bar/progress_bar_event.dart';
import 'package:hypester/bloc/progress_bar/progress_bar_state.dart';
import '../../data/repository.dart';

class ProgressBarBloc extends Bloc<ProgressBarEvent, ProgressBarState> {
  final PostsRepository _postsRepository = PostsRepository(GetIt.I.get(), GetIt.I.get());

  ProgressBarBloc() : super(const LoadingProgressBarState()) {
    on<LoadProgressBarEvent>(_onLoadEvent);
    _postsRepository.addListener(_update);
    print('ProgressBarBloc');
    add(LoadProgressBarEvent());
  }

  @override
  Future<void> close() {
    _postsRepository.removeListener(_update);
    return super.close();
  }

  void _update() {
    print(_postsRepository.progress);
    add(LoadProgressBarEvent(progress: _postsRepository.progress));
  }

  Future<void> _onLoadEvent(LoadProgressBarEvent event, Emitter<ProgressBarState> emit) async {
    print('Загрузка прогресс бара');
    try {
      emit(LoadingProgressBarState(progress: event.progress));
    } catch (error) {
      print('Ошибка при загрузке прогресс бара: $error');
      emit(ErrorProgressBarState());
    }
  }
}
