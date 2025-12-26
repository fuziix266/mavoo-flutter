import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../injection_container.dart';
import '../bloc/notification_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationBloc>()..add(NotificationLoadRequested()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Notifications', style: TextStyle(color: AppColors.textPrimary)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              if (state.items.isEmpty) {
                return const Center(child: Text("No notifications"));
              }
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return Container(
                    color: !item.isRead ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        backgroundImage: item.fromUserPic != null ? NetworkImage(item.fromUserPic!) : null,
                        child: item.fromUserPic == null ? const Icon(Icons.person, color: Colors.grey) : null,
                      ),
                      title: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: AppColors.textPrimary),
                          children: [
                            TextSpan(
                              text: '${item.fromUser ?? "Someone"} ',
                              style: const TextStyle(fontWeight: FontWeight.bold)
                            ),
                            TextSpan(text: '${item.text}. '),
                            TextSpan(
                              text: _timeAgo(item.createdAt),
                              style: const TextStyle(color: Colors.grey, fontSize: 12)
                            ),
                          ],
                        ),
                      ),
                      trailing: item.type == 'like' || item.type == 'comment'
                          ? Container(width: 40, height: 40, color: Colors.grey[300])
                          : null,
                    ),
                  );
                },
              );
            } else if (state is NotificationError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
