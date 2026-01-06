import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../bloc/notification_bloc.dart';
import '../../data/models/notification_model.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationBloc>()..add(LoadNotifications()),
      child: const NotificationsView(),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Notificaciones',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotificationLoaded) {
                  if (state.notifications.isEmpty) {
                    return const Center(child: Text('No tienes notificaciones'));
                  }
                  return ListView.separated(
                    itemCount: state.notifications.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return _buildNotificationItem(context, state.notifications[index]);
                    },
                  );
                } else if (state is NotificationError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Error al cargar notificaciones'),
                        ElevatedButton(
                          onPressed: () => context.read<NotificationBloc>().add(LoadNotifications()),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, NotificationModel notification) {
    return Container(
      color: !notification.isRead ? Colors.blue.withOpacity(0.05) : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: notification.userImage != null
              ? NetworkImage(notification.userImage!)
              : null,
          child: notification.userImage == null ? const Icon(Icons.notifications) : null,
        ),
        title: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.body),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification.createdAt),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        onTap: () {
          context.read<NotificationBloc>().add(MarkNotificationAsRead(notification.id));
          _handleNavigation(context, notification);
        },
      ),
    );
  }

  void _handleNavigation(BuildContext context, NotificationModel notification) {
    if (notification.type == 'post_like' || notification.type == 'comment') {
      if (notification.relatedId != null) {
        // Explicitly navigate to the specific post ID
        context.push('/posts/${notification.relatedId}');
      }
    } else if (notification.type == 'follow') {
      context.push('/profile'); // Simplified for demo, ideally /profile/:id
    }
  }

  String _formatTime(DateTime time) {
    return "${time.day}/${time.month} ${time.hour}:${time.minute}";
  }
}
