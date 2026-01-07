import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/entities/user.dart';

class ProfilePage extends StatelessWidget {
  final User? user;
  final String? userId;

  const ProfilePage({
    Key? key,
    this.user,
    this.userId,
  }) : super(key: key);

  bool get isMyProfile => user == null && userId == null;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        User? currentUser;
        if (state is AuthAuthenticated) {
          currentUser = state.user;
        }

        // Logic to determine which user to display
        // 1. If 'user' param is passed, use it.
        // 2. If 'userId' is passed, we *should* fetch it (not implemented here yet, showing loading or basic).
        // 3. If nothing passed (isMyProfile), use currentUser from AuthBloc.

        final User? userToDisplay = user ?? (isMyProfile ? currentUser : null);

        // If we need to display a profile but have no data yet (e.g. fetching by ID)
        if (userToDisplay == null && !isMyProfile) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        // If it's my profile but I'm not logged in (shouldn't happen in this route usually)
        if (isMyProfile && currentUser == null) {
          return const Scaffold(
              body: Center(child: Text('Please log in to view your profile')));
        }

        final displayUser = userToDisplay!;
        final displayName =
            (displayUser.fullName != null && displayUser.fullName!.isNotEmpty)
                ? displayUser.fullName!
                : (displayUser.username ?? 'Usuario');
        final displayUsername = displayUser.username ?? 'usuario';
        final displayImage = displayUser.profileImage;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(displayUsername),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 150,
                      color: Colors.deepPurple.shade200,
                      width: double.infinity,
                      child: Image.network(
                        'https://picsum.photos/seed/cover/800/300',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 46,
                          backgroundImage:
                              displayImage != null && displayImage.isNotEmpty
                                  ? NetworkImage(displayImage)
                                  : null,
                          child: (displayImage == null || displayImage.isEmpty)
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),

                // User Info
                Center(
                  child: Column(
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@$displayUsername',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: const Text(
                          'Corredor aficionado. Amante de la montaña y el aire libre. 🏃‍♂️🏔️', // This could also be dynamic later
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Stats
                // Validar si es perfil propio para mostrar estadisticas reales o placeholders
                // Por ahora dejamos placeholders pero el nombre/foto ya son reales.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat('Publicaciones', '42'),
                    _buildStat('Seguidores', '1.2k'),
                    _buildStat('Siguiendo', '350'),
                  ],
                ),

                const SizedBox(height: 24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isMyProfile)
                      ElevatedButton(
                        onPressed: () {
                          context.push('/edit-profile');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                        ),
                        child: const Text('Editar Perfil'),
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          // Follow logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                        ),
                        child: const Text('Seguir'),
                      ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Compartir'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Tabs
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      const TabBar(
                        labelColor: Colors.deepPurple,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.deepPurple,
                        tabs: [
                          Tab(icon: Icon(Icons.grid_on)),
                          Tab(icon: Icon(Icons.favorite_border)),
                          Tab(icon: Icon(Icons.bookmark_border)),
                        ],
                      ),
                      SizedBox(
                        height: 400, // Fixed height for grid
                        child: TabBarView(
                          children: [
                            _buildGrid(),
                            const Center(child: Text('Me gusta')),
                            const Center(child: Text('Guardados')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Image.network(
          'https://picsum.photos/seed/${index + 100}/300/300',
          fit: BoxFit.cover,
        );
      },
    );
  }
}
