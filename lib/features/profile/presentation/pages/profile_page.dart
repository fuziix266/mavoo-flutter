import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../injection_container.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(ProfileLoadRequested()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Profile', style: TextStyle(color: AppColors.textPrimary)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.go('/settings'),
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else if (state is ProfileLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Header
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: user.profilePic != null ? NetworkImage(user.profilePic!) : null,
                      child: user.profilePic == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.fullName ?? user.username,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text('@${user.username}', style: const TextStyle(color: Colors.grey)),
                    if (user.bio != null) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          user.bio!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(label: 'Posts', value: '${user.postCount}'),
                        _StatItem(label: 'Followers', value: '${user.followersCount}'),
                        _StatItem(label: 'Following', value: '${user.followingCount}'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Grid
                    if (state.posts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text("No posts yet"),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemCount: state.posts.length,
                        itemBuilder: (context, index) {
                          final post = state.posts[index];
                          if (post.images.isNotEmpty) {
                             return Image.network(
                               post.images.first,
                               fit: BoxFit.cover,
                               errorBuilder: (_,__,___) => Container(color: Colors.grey[300]),
                             );
                          }
                          return Container(
                            color: Colors.grey[300],
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                post.text,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
