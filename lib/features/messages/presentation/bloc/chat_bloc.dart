import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/message_repository.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

// Events
abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

class LoadConversations extends ChatEvent {}

class LoadMessages extends ChatEvent {
  final int conversationId;
  const LoadMessages(this.conversationId);
}

class SendMessage extends ChatEvent {
  final int receiverId;
  final String content;
  const SendMessage(this.receiverId, this.content);
}

// States
abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatLoaded extends ChatState {
  final List<Conversation> conversations;
  const ChatLoaded(this.conversations);
}
class MessagesLoaded extends ChatState {
  final List<Message> messages;
  final int conversationId;
  const MessagesLoaded(this.messages, this.conversationId);
}
class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
}

// Bloc
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageRepository repository;
  final AuthRepository authRepository;

  ChatBloc({required this.repository, required this.authRepository}) : super(ChatInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
  }

  Future<int> _getCurrentUserId() async {
    final result = await authRepository.getCurrentUser();
    return result.fold(
      (failure) => 0,
      (user) => int.tryParse(user.id) ?? 0,
    );
  }

  Future<void> _onLoadConversations(LoadConversations event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await repository.getConversations();
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (conversations) => emit(ChatLoaded(conversations)),
    );
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final currentUserId = await _getCurrentUserId();
    final result = await repository.getMessages(event.conversationId, currentUserId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(MessagesLoaded(messages, event.conversationId)),
    );
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    final currentUserId = await _getCurrentUserId();
    final result = await repository.sendMessage(event.receiverId, event.content, currentUserId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (message) {
        // Optimistic update or reload. For now, reload via message result logic if needed
        // Assuming we are in a conversation view
        if (state is MessagesLoaded) {
           add(LoadMessages((state as MessagesLoaded).conversationId));
        }
      },
    );
  }
}
