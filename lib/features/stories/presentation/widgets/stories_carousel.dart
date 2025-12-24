import 'package:flutter/material.dart';
import '../../data/models/story_model.dart';

class StoriesCarousel extends StatelessWidget {
  final List<UserStories> userStories;

  const StoriesCarousel({Key? key, required this.userStories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userStories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: userStories.length,
        itemBuilder: (context, index) {
          final userStory = userStories[index];
          final hasUnviewed = userStory.hasUnviewed;
          
          return GestureDetector(
            onTap: () {
              // TODO: Abrir visor de stories
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: hasUnviewed
                          ? const LinearGradient(
                              colors: [Color(0xFF0046fc), Color(0xFF00b2f6)],
                            )
                          : null,
                      border: !hasUnviewed
                          ? Border.all(color: Colors.grey.shade300, width: 2)
                          : null,
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: userStory.stories.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(userStory.stories.first.url),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'User ${userStory.userId}',
                    style: const TextStyle(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
