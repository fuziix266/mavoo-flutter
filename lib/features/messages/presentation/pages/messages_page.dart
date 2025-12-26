import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(icon: const Icon(Icons.edit_square), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Stack(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=33'),
                ),
                if (index < 5)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            title: const Text('User Name', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              index == 0 ? 'Sent you a message • 2m' : 'Active 5h ago',
              style: TextStyle(
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
                color: index == 0 ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(Icons.camera_alt_outlined, color: Colors.grey),
          );
        },
      ),
    );
  }
}
