import 'package:flutter/material.dart';
import '../../data/repositories/message_repository.dart';
import '../../data/models/chat_model.dart';
import '../../../../core/utils/api_client.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late MessageRepository _repository;
  List<ChatModel> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = MessageRepository(apiClient: ApiClient());
    _loadChats();
  }

  Future<void> _loadChats() async {
    final list = await _repository.getChats();
    if (mounted) {
      setState(() {
        _chats = list;
        _isLoading = false;
      });
    }
  }

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
                  onPressed: () {
                    // TODO: New Message
                  },
                  icon: const Icon(Icons.edit_square),
                ),
              ],
            ),
          ),

          // Search bar (Visual only for now)
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

          // Active users (Placeholder / Todo: Active status endpoint)
          // Removed Mock Active Users loop to adhere to "Zero Mockups" unless I fetch them.
          // If no endpoint, better to hide or fetch friends.
          // I will hide it to be safe or leave empty until implemented.
          // const Divider(height: 1),

          // Conversations
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _chats.isEmpty
                    ? const Center(child: Text("No tienes mensajes."))
                    : ListView.builder(
                        itemCount: _chats.length,
                        itemBuilder: (context, index) {
                          final chat = _chats[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundImage: chat.userProfilePic.isNotEmpty
                                  ? NetworkImage(chat.userProfilePic)
                                  : null,
                              child: chat.userProfilePic.isEmpty ? const Icon(Icons.person) : null,
                            ),
                            title: Text(
                              chat.username,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    chat.lastMessage,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: chat.unreadCount > 0 ? Colors.black : Colors.grey,
                                      fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _getTimeAgo(chat.lastMessageTime),
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: chat.unreadCount > 0
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
                                // Navigate to chat details
                                // context.push('/messages/${chat.id}');
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays} d';
    if (diff.inHours > 0) return '${diff.inHours} h';
    if (diff.inMinutes > 0) return '${diff.inMinutes} m';
    return 'Ahora';
  }
}
