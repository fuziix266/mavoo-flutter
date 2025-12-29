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
    // Mocking stories for now
    setState(() {
      userStories = [
        UserStories(
          userId: 2,
          hasUnviewed: true,
          stories: [
            Story(
              storyId: 1,
              userId: 2,
              url: 'https://picsum.photos/300/500',
              type: 'image',
              createdAt: DateTime.now(),
            )
          ],
        ),
        UserStories(
          userId: 3,
          hasUnviewed: false,
          stories: [
            Story(
              storyId: 2,
              userId: 3,
              url: 'https://picsum.photos/301/501',
              type: 'image',
              createdAt: DateTime.now().subtract(const Duration(hours: 1)),
            )
          ],
        ),
      ];
    });
  }

  Future<void> _loadPosts() async {
    try {
      final loadedPosts = await postRepository.getFeed();
      setState(() {
        posts = loadedPosts.isNotEmpty ? loadedPosts : _getMockPosts();
        isLoadingPosts = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
      setState(() {
        posts = _getMockPosts();
        isLoadingPosts = false;
      });
    }
  }

  List<Post> _getMockPosts() {
    return [
      Post(
        id: 1,
        userId: 2,
        username: 'juanperez',
        userFirstName: 'Juan',
        userLastName: 'Perez',
        userProfilePic: 'https://randomuser.me/api/portraits/men/1.jpg',
        text: 'Gran entrenamiento de hoy! 10km en 45 minutos. #running #mavoo',
        location: 'Parque Central',
        postType: 'image',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        isLiked: true,
        likeCount: 24,
        commentCount: 5,
        images: ['https://picsum.photos/seed/post1/600/400'],
      ),
      Post(
        id: 2,
        userId: 3,
        username: 'mariagarcia',
        userFirstName: 'Maria',
        userLastName: 'Garcia',
        userProfilePic: 'https://randomuser.me/api/portraits/women/2.jpg',
        text: 'Preparándome para la maratón del próximo mes. ¿Alguien más va?',
        location: 'Estadio Olímpico',
        postType: 'text',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isLiked: false,
        likeCount: 15,
        commentCount: 2,
      ),
      Post(
        id: 3,
        userId: 4,
        username: 'carlosrodriguez',
        userFirstName: 'Carlos',
        userLastName: 'Rodriguez',
        userProfilePic: 'https://randomuser.me/api/portraits/men/3.jpg',
        text: 'Increíble vista desde la cima de la montaña. Valió la pena el esfuerzo.',
        location: 'Montaña Alta',
        postType: 'image',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        isLiked: true,
        likeCount: 156,
        commentCount: 12,
        images: ['https://picsum.photos/seed/post3/600/600'],
      ),
    ];
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
