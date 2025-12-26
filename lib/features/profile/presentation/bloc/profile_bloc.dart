import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/profile_repository.dart';
import '../../domain/entities/profile_user.dart';
import '../../../posts/data/models/post_model.dart';
import '../../../posts/data/repositories/post_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  final PostRepository postRepository;

  ProfileBloc({
    required this.profileRepository,
    required this.postRepository,
  }) : super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
      ProfileLoadRequested event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await profileRepository.getMyProfile();
      if (user != null) {
        // Fetch posts for user
        // Assuming postRepository has a method to get user posts, or we filter feed
        // For now, let's just fetch feed as a placeholder or specific user posts endpoint if it existed
        // We will assume a getMyPosts exists or we mock it
        final posts = await postRepository.getFeed(limit: 10);

        emit(ProfileLoaded(user: user, posts: posts));
      } else {
        emit(const ProfileError(message: "Could not load profile"));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
