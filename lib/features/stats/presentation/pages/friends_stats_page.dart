import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/utils/api_client.dart';
import '../../data/repositories/friends_stats_repository.dart';
import '../../data/models/friend_stats_model.dart';

class FriendsStatsPage extends StatefulWidget {
  const FriendsStatsPage({Key? key}) : super(key: key);

  @override
  State<FriendsStatsPage> createState() => _FriendsStatsPageState();
}

class _FriendsStatsPageState extends State<FriendsStatsPage> {
  late FriendsStatsRepository _repository;
  List<FriendStats> _friends = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _repository = FriendsStatsRepository(apiClient: ApiClient());
    _loadFriendsStats();
  }

  Future<void> _loadFriendsStats() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final friends = await _repository.getFriendsStats(authState.user.id);
        if (mounted) {
          setState(() {
            _friends = friends;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Error al cargar estadísticas de amigos'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFriendsStats,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estadísticas de Amigos',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (_friends.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No tienes amigos todavía.\nComienza a seguir a otros usuarios para ver sus estadísticas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _friends.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final friend = _friends[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: friend.profilePic != null
                              ? NetworkImage(friend.profilePic!)
                              : null,
                          child: friend.profilePic == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friend.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '@${friend.username}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${friend.stats.totalDistanceWeek.toStringAsFixed(1)} km esta semana',
                                style: const TextStyle(fontSize: 14),
                              ),
                              if (friend.stats.lastActivityType != null)
                                Text(
                                  'Última actividad: ${friend.stats.lastActivityType}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Icon(
                          friend.stats.totalActivitiesWeek > 0
                              ? Icons.trending_up
                              : Icons.trending_flat,
                          color: friend.stats.totalActivitiesWeek > 0
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
