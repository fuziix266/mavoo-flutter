import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class MarkNotificationAsRead extends NotificationEvent {
  final int id;
  const MarkNotificationAsRead(this.id);
}

// States
abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}
class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  const NotificationLoaded(this.notifications);
}
class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
}

// Bloc
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc({required this.repository}) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkAsRead);
  }

  Future<void> _onLoadNotifications(LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    final result = await repository.getNotifications();
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) => emit(NotificationLoaded(notifications)),
    );
  }

  Future<void> _onMarkAsRead(MarkNotificationAsRead event, Emitter<NotificationState> emit) async {
    // Optimistic update
    if (state is NotificationLoaded) {
      final currentList = (state as NotificationLoaded).notifications;
      // We could update the local list to show as read, but for now we just call API
      // Ideally we update the state to reflect read status immediately
    }
    await repository.markAsRead(event.id);
    add(LoadNotifications()); // Reload to be safe
  }
}
