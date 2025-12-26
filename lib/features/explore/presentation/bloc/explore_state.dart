part of 'explore_bloc.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final List<Post> posts;

  const ExploreLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class ExploreError extends ExploreState {
  final String message;

  const ExploreError({required this.message});

  @override
  List<Object> get props => [message];
}
