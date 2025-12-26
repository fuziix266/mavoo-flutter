import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../injection_container.dart';
import '../../data/repositories/post_repository.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _textController = TextEditingController();
  bool _isPosting = false;

  Future<void> _handlePost() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() => _isPosting = true);

    final success = await sl<PostRepository>().createPost(_textController.text);

    if (mounted) {
      setState(() => _isPosting = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Posted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create post')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Post', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          TextButton(
            onPressed: _isPosting ? null : _handlePost,
            child: _isPosting
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Post', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                CircleAvatar(backgroundColor: Colors.grey),
                SizedBox(width: 12),
                Text('User', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'What\'s on your mind?',
                border: InputBorder.none,
              ),
              maxLines: 5,
            ),
            const Spacer(),
            Divider(color: Colors.grey[200]),
            ListTile(
              leading: const Icon(Icons.image, color: AppColors.primary),
              title: const Text('Photo/Video'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.red),
              title: const Text('Location'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
