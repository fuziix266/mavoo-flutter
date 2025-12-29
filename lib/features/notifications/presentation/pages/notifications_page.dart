import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.separated(
        itemCount: 15,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final isNew = index < 3;
          return Container(
            color: isNew ? Colors.blue.withOpacity(0.05) : Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage('https://randomuser.me/api/portraits/thumb/women/${index + 10}.jpg'),
              ),
              title: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Usuario ${index + 10} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: index % 2 == 0
                          ? 'comenzó a seguirte.'
                          : 'le gustó tu publicación.',
                    ),
                  ],
                ),
              ),
              subtitle: Text(
                '${index + 1} h',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              trailing: index % 2 == 0
                  ? ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(80, 32),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text('Seguir'),
                    )
                  : Image.network(
                      'https://picsum.photos/50/50?random=$index',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
