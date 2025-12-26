import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          return Container(
            color: index < 3 ? AppColors.primary.withOpacity(0.05) : Colors.transparent, // New notifications
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
              ),
              title: RichText(
                text: TextSpan(
                  style: const TextStyle(color: AppColors.textPrimary),
                  children: [
                    const TextSpan(text: 'User Name ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'liked your post. '),
                    TextSpan(text: '${index + 1}h', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              trailing: index % 2 == 0
                  ? Container(width: 40, height: 40, color: Colors.grey[300])
                  : null,
            ),
          );
        },
      ),
    );
  }
}
