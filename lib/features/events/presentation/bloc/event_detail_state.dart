import 'package:equatable/equatable.dart';
import '../../data/models/event_model.dart';

abstract class EventDetailState extends Equatable {
  const EventDetailState();

  @override
  List<Object?> get props => [];
}

class EventDetailInitial extends EventDetailState {}

class EventDetailLoading extends EventDetailState {}

class EventDetailLoaded extends EventDetailState {
  final Event event;
  final bool isRegistered;

  const EventDetailLoaded({required this.event, this.isRegistered = false});

  @override
  List<Object?> get props => [event, isRegistered];
}

class EventDetailError extends EventDetailState {
  final String message;

  const EventDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class EventEnrollmentSuccess extends EventDetailState {
  final String message;

  const EventEnrollmentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EventEnrollmentError extends EventDetailState {
  final String message;

  const EventEnrollmentError(this.message);

  @override
  List<Object?> get props => [message];
}
