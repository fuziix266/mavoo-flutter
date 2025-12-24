import 'package:flutter/material.dart';
import '../../../../features/events/data/repositories/event_repository.dart';
import '../../../../features/stories/presentation/widgets/stories_carousel.dart';
import '../../../../features/stories/presentation/widgets/stories_bar.dart';
import '../../../../features/stories/data/repositories/story_repository.dart';
import '../../../../features/stories/data/models/story_model.dart';
import '../../../../features/posts/data/models/post_model.dart';
import '../../../../features/posts/data/repositories/post_repository.dart';
import '../../../../features/posts/presentation/widgets/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late EventRepository eventRepository;
  late PostRepository postRepository;
  late StoryRepository storyRepository;
  List<UserStories> userStories = [];
  List<Post> posts = [];
  bool isLoadingPosts = true;

  @override
  void initState() {
    super.initState();
    final baseUrl = 'http://localhost:8000';
    eventRepository = EventRepository(baseUrl: baseUrl);
    postRepository = PostRepository(baseUrl: baseUrl);
    storyRepository = StoryRepository(baseUrl: baseUrl);
    _loadData();
  }

  Future<void> _loadData() async {
    _loadStories();
    _loadPosts();
  }

  Future<void> _loadStories() async {
    // TODO: Implement story loading from API when fixed
    setState(() {
      userStories = [];
    });
  }

  Future<void> _loadPosts() async {
    try {
      final loadedPosts = await postRepository.getFeed();
      setState(() {
        posts = loadedPosts;
        isLoadingPosts = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
      setState(() => isLoadingPosts = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stories Bar (Instagram-style)
          StoriesBar(
            repository: storyRepository,
            currentUserId: 1, // TODO: Get from auth
          ),
          
          // Posts Feed
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Feed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),

          if (isLoadingPosts)
            const Center(child: Padding(
               padding: EdgeInsets.all(20),
               child: CircularProgressIndicator(),
            ))
          else if (posts.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text('No hay publicaciones aún', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: posts[index]);
              },
            ),
          
          const SizedBox(height: 80), // Bottom padding
        ],
      ),
    );
  }
}
