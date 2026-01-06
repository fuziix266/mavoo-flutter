import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../bloc/chat_bloc.dart';
import '../../data/models/message_model.dart'; // Import Conversation

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatBloc>()..add(LoadConversations()),
      child: const MessagesView(),
    );
  }
}

class MessagesView extends StatelessWidget {
  const MessagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Custom App Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Mensajes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_square),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Conversations List
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatLoaded) {
                  if (state.conversations.isEmpty) {
                    return const Center(child: Text('No tienes mensajes'));
                  }
                  return ListView.builder(
                    itemCount: state.conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = state.conversations[index];
                      return _buildConversationItem(context, conversation);
                    },
                  );
                } else if (state is ChatError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Error al cargar mensajes'),
                        ElevatedButton(
                          onPressed: () => context.read<ChatBloc>().add(LoadConversations()),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationItem(BuildContext context, Conversation conversation) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: conversation.userImage.isNotEmpty
            ? NetworkImage(conversation.userImage)
            : null,
        child: conversation.userImage.isEmpty ? const Icon(Icons.person) : null,
      ),
      title: Text(
        conversation.userName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              conversation.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: conversation.unreadCount > 0 ? Colors.black : Colors.grey,
                fontWeight: conversation.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatTime(conversation.lastMessageTime),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
      trailing: conversation.unreadCount > 0
          ? Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            )
          : null,
      onTap: () {
        context.push('/messages/${conversation.id}', extra: conversation);
      },
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute}";
  }
}
