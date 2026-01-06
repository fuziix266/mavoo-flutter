import 'package:flutter/material.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Crear publicación'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
               // TODO: Post logic - for now just close and show feedback
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Publicando...')),
               );
               Navigator.pop(context);
            },
            child: const Text(
              'Publicar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: '¿Qué estás pensando?',
                      border: InputBorder.none,
                    ),
                    maxLines: 5,
                    autofocus: true,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Divider(height: 1),
          // Actions
          ListTile(
            leading: const Icon(Icons.image, color: Colors.green),
            title: const Text('Foto/Video'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person_add, color: Colors.blue),
            title: const Text('Etiquetar personas'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.red),
            title: const Text('Ubicación'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.emoji_emotions, color: Colors.amber),
            title: const Text('Sentimiento/Actividad'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
