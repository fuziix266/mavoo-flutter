import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/chat_bloc.dart';
import '../../data/models/message_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ChatDetailPage extends StatefulWidget {
  final int conversationId;
  final int partnerId; // Explicit partner ID for sending messages
  final String userName;
  final String? userImage;

  const ChatDetailPage({
    Key? key,
    required this.conversationId,
    required this.partnerId,
    required this.userName,
    this.userImage,
  }) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    // Use partnerId as receiverId
    context.read<ChatBloc>().add(SendMessage(widget.partnerId, content));
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatBloc>()..add(LoadMessages(widget.conversationId)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: widget.userImage != null
                    ? NetworkImage(widget.userImage!)
                    : null,
                child: widget.userImage == null ? const Icon(Icons.person) : null,
                radius: 16,
              ),
              const SizedBox(width: 8),
              Text(widget.userName),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MessagesLoaded) {
                    final messages = state.messages;

                    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                    if (messages.isEmpty) {
                      return const Center(child: Text('No hay mensajes aún.'));
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return _buildMessageBubble(message);
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox();
                },
              ),
            ),
            _buildInputArea(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMine ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: message.isMine ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${message.createdAt.hour}:${message.createdAt.minute}",
              style: TextStyle(
                fontSize: 10,
                color: message.isMine ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Escribe un mensaje...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          Builder(
            builder: (innerContext) {
              return IconButton(
                icon: const Icon(Icons.send, color: AppColors.primary),
                onPressed: () {
                   final content = _messageController.text.trim();
                   if (content.isNotEmpty) {
                     // We must use the Bloc from the current context context (via Builder or child)
                     innerContext.read<ChatBloc>().add(SendMessage(widget.partnerId, content));
                     _messageController.clear();
                   }
                },
              );
            }
          ),
        ],
      ),
    );
  }
}
