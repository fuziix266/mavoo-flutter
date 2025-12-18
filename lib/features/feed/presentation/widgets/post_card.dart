import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFEFEFE),
            Color(0xFFF0F9FF),
            Color(0xFFFEFEFE),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF0046FC).withOpacity(0.1),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0046FC).withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0046FC).withOpacity(0.2),
                      width: 2,
                    ),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0046FC), Color(0xFF00B2F6)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      (post.username ?? 'U').substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Username and time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.username ?? 'User ${post.userId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF3A3333),
                        ),
                      ),
                      Text(
                        post.createdAt,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // More button
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.more_horiz,
                    size: 20,
                    color: Color(0xFF969696),
                  ),
                ),
              ],
            ),
          ),

          // Content Text
          if (post.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                post.text,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF3A3333),
                  height: 1.5,
                ),
              ),
            ),

          // Image (if exists)
          if (post.imageUrl != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF0046FC).withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  post.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.favorite_border,
                  count: post.likesCount,
                  onTap: onLike,
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  count: post.commentsCount,
                  onTap: onComment,
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  icon: Icons.send_outlined,
                  count: 0,
                  onTap: onShare,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bookmark_border,
                    size: 22,
                    color: Color(0xFF3A3333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFF3A3333)),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3A3333),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
