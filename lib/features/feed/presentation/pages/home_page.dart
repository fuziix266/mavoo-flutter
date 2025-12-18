import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/feed_bloc.dart';
import '../widgets/post_card.dart';
import '../../../../injection_container.dart' as di;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<FeedBloc>()..add(FeedLoadRequested()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9FB),
        body: Row(
          children: [
            // Main Content (Feed)
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  // Top Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A3333),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            // TODO: Add post
                          },
                          color: const Color(0xFF0046FC),
                        ),
                      ],
                    ),
                  ),

                  // Feed Content
                  Expanded(
                    child: BlocBuilder<FeedBloc, FeedState>(
                      builder: (context, state) {
                        if (state is FeedLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0046FC),
                            ),
                          );
                        }
                        
                        if (state is FeedError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF00B2F6).withOpacity(0.2),
                                        const Color(0xFF0046FC).withOpacity(0.1),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.error_outline,
                                    size: 60,
                                    color: Color(0xFF0046FC),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  state.message,
                                  style: const TextStyle(
                                    color: Color(0xFF3A3333),
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => context.read<FeedBloc>().add(FeedLoadRequested()),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0046FC),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        if (state is FeedLoaded) {
                          if (state.posts.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF00B2F6).withOpacity(0.2),
                                          const Color(0xFF0046FC).withOpacity(0.1),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.post_add,
                                      size: 60,
                                      color: Color(0xFF0046FC),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No posts yet',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3A3333),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Be the first to post!',
                                    style: TextStyle(
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          
                          return RefreshIndicator(
                            onRefresh: () async {
                              context.read<FeedBloc>().add(FeedLoadRequested());
                            },
                            color: const Color(0xFF0046FC),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: state.posts.length,
                              itemBuilder: (context, index) {
                                final post = state.posts[index];
                                return PostCard(
                                  post: post,
                                  onLike: () {
                                    // TODO: Implement like
                                  },
                                  onComment: () {
                                    // TODO: Implement comment
                                  },
                                  onShare: () {
                                    // TODO: Implement share
                                  },
                                  onBookmark: () {
                                    // TODO: Implement bookmark
                                  },
                                );
                              },
                            ),
                          );
                        }
                        
                        return const Center(
                          child: Text('Welcome to Mavoo!'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Right Panel (Discover/Trends)
            Container(
              width: 350,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Discover',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3333),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDiscoverCard(
                    title: 'Trending Now',
                    subtitle: 'See what\'s popular',
                    icon: Icons.trending_up,
                  ),
                  const SizedBox(height: 12),
                  _buildDiscoverCard(
                    title: 'Suggested Users',
                    subtitle: 'People you may know',
                    icon: Icons.people,
                  ),
                  const SizedBox(height: 12),
                  _buildDiscoverCard(
                    title: 'Popular Hashtags',
                    subtitle: 'Join the conversation',
                    icon: Icons.tag,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00B2F6).withOpacity(0.1),
            const Color(0xFF0046FC).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0046FC).withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0046FC), Color(0xFF00B2F6)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF3A3333),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

