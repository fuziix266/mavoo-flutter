import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  final int postId;

  const PostDetailPage({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicación')),
      body: Center(
        child: Text('Detalle del Post $postId'),
      ),
    );
  }
}
