import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/explore_repository.dart';
import '../../../posts/data/models/post_model.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final ExploreRepository exploreRepository;

  ExploreBloc({required this.exploreRepository}) : super(ExploreInitial()) {
    on<ExploreLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
      ExploreLoadRequested event, Emitter<ExploreState> emit) async {
    emit(ExploreLoading());
    try {
      final posts = await exploreRepository.getExploreContent();
      emit(ExploreLoaded(posts: posts));
    } catch (e) {
      emit(ExploreError(message: e.toString()));
    }
  }
}
