import 'package:flutter/material.dart';

class NotificationsOverlay extends StatelessWidget {
  const NotificationsOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Container(
        width: 360,
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notificaciones',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Marcar todo como leído'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage('https://randomuser.me/api/portraits/thumb/men/${index + 20}.jpg'),
                    ),
                    title: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(text: 'Usuario ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: index % 2 == 0 ? 'le gustó tu foto.' : 'comentó en tu publicación.'),
                        ],
                      ),
                    ),
                    subtitle: Text('${index + 2} min'),
                    onTap: () {},
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to full notifications page
                  // Close overlay?
                },
                child: const Text('Ver todas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
