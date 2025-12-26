import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/models/notification_item.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc({required this.repository}) : super(NotificationInitial()) {
    on<NotificationLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
      NotificationLoadRequested event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final items = await repository.getNotifications();
      emit(NotificationLoaded(items: items));
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }
}
