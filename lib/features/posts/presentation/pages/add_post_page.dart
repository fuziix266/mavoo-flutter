import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AddPostPage extends StatelessWidget {
  const AddPostPage({Key? key}) : super(key: key);

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
            onPressed: () {
               // Post logic
               Navigator.pop(context);
            },
            child: const Text('Post', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                Text('User Name', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
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
