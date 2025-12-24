import 'package:flutter/material.dart';
import '../../data/models/story_user_model.dart';
import '../../data/repositories/story_repository.dart';
import '../pages/story_viewer_page.dart';

class StoriesBar extends StatefulWidget {
  final StoryRepository repository;
  final int currentUserId;

  const StoriesBar({
    Key? key,
    required this.repository,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<StoriesBar> createState() => _StoriesBarState();
}

class _StoriesBarState extends State<StoriesBar> {
  List<StoryUser> storyUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    setState(() => isLoading = true);
    final users = await widget.repository.getStoriesBar(widget.currentUserId);
    setState(() {
      storyUsers = users;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (storyUsers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: storyUsers.length,
        itemBuilder: (context, index) {
          return _StoryAvatar(
            storyUser: storyUsers[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryViewerPage(
                    initialUserId: storyUsers[index].userId,
                    allUsers: storyUsers,
                    viewerId: widget.currentUserId,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  final StoryUser storyUser;
  final VoidCallback onTap;

  const _StoryAvatar({
    required this.storyUser,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            // Avatar con borde gradiente
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: storyUser.hasUnviewed
                    ? const LinearGradient(
                        colors: [Color(0xFF0046fc), Color(0xFF00b2f6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: storyUser.hasUnviewed ? null : Colors.grey.shade300,
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: storyUser.profilePic != null &&
                          storyUser.profilePic!.isNotEmpty
                      ? NetworkImage(storyUser.profilePic!)
                      : null,
                  child: storyUser.profilePic == null ||
                          storyUser.profilePic!.isEmpty
                      ? Icon(Icons.person, color: Colors.grey.shade400, size: 30)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Nombre
            Text(
              storyUser.displayName.split(' ')[0], // Solo primer nombre
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
