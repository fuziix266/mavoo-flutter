import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_posts_usecase.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetPostsUseCase getPostsUseCase;

  FeedBloc({required this.getPostsUseCase}) : super(FeedInitial()) {
    on<FeedLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(FeedLoadRequested event, Emitter<FeedState> emit) async {
    print('[FeedBloc] Loading posts...');
    emit(FeedLoading());
    final result = await getPostsUseCase();
    result.fold(
      (failure) {
        print('[FeedBloc] Load failed: ${failure.message}');
        emit(FeedError(failure.message));
      },
      (posts) {
        print('[FeedBloc] Loaded ${posts.length} posts');
        emit(FeedLoaded(posts));
      },
    );
  }
}
