import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/story_model.dart';
import '../../data/models/story_user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoryViewerPage extends StatefulWidget {
  final int initialUserId;
  final List<StoryUser> allUsers;
  final int viewerId;

  const StoryViewerPage({
    Key? key,
    required this.initialUserId,
    required this.allUsers,
    required this.viewerId,
  }) : super(key: key);

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage> {
  late PageController _userPageController;
  late PageController _storyPageController;
  int currentUserIndex = 0;
  int currentStoryIndex = 0;
  
  Map<int, List<Story>> userStoriesMap = {};
  Map<int, Map<String, dynamic>> userInfoMap = {};
  bool isLoading = true;
  
  Timer? _autoAdvanceTimer;
  final Duration _storyDuration = const Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    currentUserIndex = widget.allUsers.indexWhere((u) => u.userId == widget.initialUserId);
    if (currentUserIndex == -1) currentUserIndex = 0;
    
    _userPageController = PageController(initialPage: currentUserIndex);
    _storyPageController = PageController();
    
    _loadCurrentUserStories();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _userPageController.dispose();
    _storyPageController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUserStories() async {
    final userId = widget.allUsers[currentUserIndex].userId;
    
    if (userStoriesMap.containsKey(userId)) {
      setState(() => isLoading = false);
      _startAutoAdvance();
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/content/story/user/$userId?viewer_id=${widget.viewerId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final stories = (data['data']['stories'] as List)
              .map((s) => Story.fromJson(s))
              .toList();
          
          setState(() {
            userStoriesMap[userId] = stories;
            userInfoMap[userId] = data['data']['user'];
            isLoading = false;
          });
          
          _startAutoAdvance();
        }
      }
    } catch (e) {
      print('Error loading stories: $e');
      setState(() => isLoading = false);
    }
  }

  void _startAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer(_storyDuration, () {
      _nextStory();
    });
  }

  void _nextStory() {
    final userId = widget.allUsers[currentUserIndex].userId;
    final stories = userStoriesMap[userId] ?? [];
    
    if (currentStoryIndex < stories.length - 1) {
      setState(() => currentStoryIndex++);
      _storyPageController.animateToPage(
        currentStoryIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startAutoAdvance();
    } else {
      _nextUser();
    }
  }

  void _previousStory() {
    if (currentStoryIndex > 0) {
      setState(() => currentStoryIndex--);
      _storyPageController.animateToPage(
        currentStoryIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startAutoAdvance();
    } else {
      _previousUser();
    }
  }

  void _nextUser() {
    if (currentUserIndex < widget.allUsers.length - 1) {
      _autoAdvanceTimer?.cancel();
      setState(() {
        currentUserIndex++;
        currentStoryIndex = 0;
      });
      
      // Reset story page controller
      _storyPageController.dispose();
      _storyPageController = PageController();
      
      _loadCurrentUserStories();
    } else {
      _autoAdvanceTimer?.cancel();
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _previousUser() {
    if (currentUserIndex > 0) {
      _autoAdvanceTimer?.cancel();
      setState(() {
        currentUserIndex--;
        currentStoryIndex = 0;
      });
      
      // Reset story page controller
      _storyPageController.dispose();
      _storyPageController = PageController();
      
      _loadCurrentUserStories();
    }
  }

  void _markAsViewed(int storyId) async {
    try {
      await http.post(
        Uri.parse('http://localhost:8000/content/story/$storyId/view'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': widget.viewerId}),
      );
    } catch (e) {
      print('Error marking story as viewed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final userId = widget.allUsers[currentUserIndex].userId;
    final stories = userStoriesMap[userId] ?? [];
    final userInfo = userInfoMap[userId];

    if (stories.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No hay historias disponibles',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _autoAdvanceTimer?.cancel();
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Cerrar'),
              ),
            ],
          ),
        ),
      );
    }

    // Mark current story as viewed
    if (currentStoryIndex < stories.length) {
      _markAsViewed(stories[currentStoryIndex].storyId);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 3) {
            _previousStory();
          } else {
            _nextStory();
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _autoAdvanceTimer?.cancel();
            if (mounted) {
              Navigator.of(context).pop();
            }
          }
        },
        child: Stack(
          children: [
            // Story Content
            PageView.builder(
              controller: _storyPageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stories.length,
              onPageChanged: (index) {
                setState(() => currentStoryIndex = index);
                _startAutoAdvance();
              },
              itemBuilder: (context, index) {
                final story = stories[index];
                return _buildStoryContent(story);
              },
            ),

            // Progress Indicators
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: List.generate(
                        stories.length,
                        (index) => Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: index <= currentStoryIndex
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // User Header
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: userInfo?['profile_pic'] != null && userInfo!['profile_pic'].isNotEmpty
                              ? NetworkImage(userInfo['profile_pic'])
                              : null,
                          child: userInfo?['profile_pic'] == null || userInfo!['profile_pic'].isEmpty
                              ? const Icon(Icons.person, size: 20)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userInfo?['username'] ?? 'Usuario',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                _getTimeAgo(stories[currentStoryIndex].createdAt),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            _autoAdvanceTimer?.cancel();
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Story Text Overlay
            if (stories[currentStoryIndex].text != null && stories[currentStoryIndex].text!.isNotEmpty)
              Positioned(
                bottom: 100,
                left: 20,
                right: 20,
                child: Text(
                  stories[currentStoryIndex].text!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryContent(Story story) {
    if (story.type == 'image') {
      return Image.network(
        story.url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.error, color: Colors.white, size: 64),
          );
        },
      );
    } else {
      // For video, show thumbnail or placeholder
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_outline, color: Colors.white, size: 64),
            const SizedBox(height: 16),
            Text(
              'Video story',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ],
        ),
      );
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else {
      return 'Hace ${difference.inDays}d';
    }
  }
}
