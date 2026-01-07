import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/message_repository.dart';
import '../../data/models/chat_model.dart';
import '../../../../core/utils/api_client.dart';
import 'chat_detail_page.dart';

class MessagesPage extends StatefulWidget {
  final String? chatId;
  final ChatModel? initialChat;

  const MessagesPage({
    Key? key,
    this.chatId,
    this.initialChat,
  }) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late MessageRepository _repository;
  List<ChatModel> _chats = [];
  bool _isLoading = true;
  ChatModel? _selectedChat;

  @override
  void initState() {
    super.initState();
    _repository = MessageRepository(apiClient: ApiClient());

    // Initialize selected chat if provided
    _selectedChat = widget.initialChat;

    _loadChats();
  }

  @override
  void didUpdateWidget(MessagesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chatId != oldWidget.chatId) {
      _updateSelectedChat();
    }
    if (widget.initialChat != null && widget.initialChat != _selectedChat) {
      setState(() {
        _selectedChat = widget.initialChat;
      });
    }
  }

  void _updateSelectedChat() {
    if (widget.chatId != null && _chats.isNotEmpty) {
      final chat = _chats.firstWhere(
        (c) => c.id.toString() == widget.chatId,
        orElse: () => _chats.first, // Fallback logic or nullable handling could be better
      );

      // If we found the specific chat matching the ID
      if (chat.id.toString() == widget.chatId) {
        setState(() {
          _selectedChat = chat;
        });
      }
    } else if (widget.chatId == null) {
      setState(() {
        _selectedChat = null;
      });
    }
  }

  Future<void> _loadChats() async {
    final list = await _repository.getChats();
    if (mounted) {
      setState(() {
        _chats = list;
        _isLoading = false;
      });
      _updateSelectedChat();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check for wide screen (Desktop/Tablet)
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    if (isWideScreen) {
      return _buildWideLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildMobileLayout() {
    // If a chat is selected on mobile, show the chat detail
    // However, GoRouter normally handles pushing a new page.
    // If we use MessagesPage for both routes, we need to decide what to show.
    // Logic: If widget.chatId is present, we are in "Detail Mode".

    if (widget.chatId != null) {
      if (_selectedChat != null) {
        return ChatDetailPage(
          chatId: _selectedChat!.id,
          username: _selectedChat!.username,
          profilePic: _selectedChat!.userProfilePic,
        );
      } else if (_isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        // Chat not found or invalid ID, fallback to list?
        // Or show error? For now fallback to list is safer UX.
        // But to be consistent with URL, maybe show "Chat not found".
        return const Scaffold(
          body: Center(child: Text("Chat no encontrado")),
        );
      }
    }

    // Otherwise show the list
    return _buildListContent(isWide: false);
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        // Left Panel: Chat List
        SizedBox(
          width: 350,
          child: Container(
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey.shade300)),
            ),
            child: _buildListContent(isWide: true),
          ),
        ),

        // Right Panel: Chat Detail
        Expanded(
          child: _selectedChat != null
              ? ChatDetailPage(
                  chatId: _selectedChat!.id,
                  username: _selectedChat!.username,
                  profilePic: _selectedChat!.userProfilePic,
                  isEmbedded: true, // Hint to hide back button
                )
              : const Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "Selecciona un chat para comenzar",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildListContent({required bool isWide}) {
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
                          final isSelected = _selectedChat?.id == chat.id;

                          return Container(
                            color: (isWide && isSelected)
                                ? Colors.blue.withOpacity(0.1)
                                : null,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundImage: chat.userProfilePic.isNotEmpty
                                    ? NetworkImage(chat.userProfilePic)
                                    : null,
                                child: chat.userProfilePic.isEmpty ? const Icon(Icons.person) : null,
                              ),
                              title: Text(
                                chat.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: (isWide && isSelected) ? Colors.blue : Colors.black,
                                ),
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
                                if (isWide) {
                                  // Update internal state or URL for desktop
                                  // Updating URL keeps history and state sync
                                  context.go('/messages/${chat.id}', extra: chat);
                                } else {
                                  // Mobile navigation
                                  context.push('/messages/${chat.id}', extra: chat);
                                }
                              },
                            ),
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
