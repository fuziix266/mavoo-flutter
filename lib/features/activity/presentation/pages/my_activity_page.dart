import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MyActivityPage extends StatelessWidget {
  const MyActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('My Activity', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
               backgroundColor: AppColors.primary,
               child: Icon(Icons.sports_soccer, color: Colors.white),
            ),
            title: Text('Activity ${index + 1}'),
            subtitle: Text('Details about activity ${index + 1}'),
            trailing: const Text('2h ago'),
          );
        },
      ),
    );
  }
}
