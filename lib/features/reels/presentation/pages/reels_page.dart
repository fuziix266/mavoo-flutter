import 'package:flutter/material.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({Key? key}) : super(key: key);

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: 10,
        itemBuilder: (context, index) {
          return _ReelItem(index: index);
        },
      ),
    );
  }
}

class _ReelItem extends StatelessWidget {
  final int index;

  const _ReelItem({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video Placeholder
        Container(
          color: Colors.grey.shade900,
          child: Center(
            child: Image.network(
              'https://picsum.photos/seed/${index + 500}/600/1000',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
            ),
          ),
        ),

        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.2, 0.8, 1.0],
              ),
            ),
          ),
        ),

        // Content
        Positioned(
          left: 16,
          bottom: 32,
          right: 80, // Space for right actions
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage('https://randomuser.me/api/portraits/thumb/men/${index + 10}.jpg'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '@user_${index + 10}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Seguir',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Entrenamiento increíble el de hoy! 🏃‍♂️🔥 #fitness #mavoo #running',
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.music_note, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text('Audio original - user_123', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ),

        // Right Actions
        Positioned(
          right: 16,
          bottom: 32,
          child: Column(
            children: [
              _ActionButton(icon: Icons.favorite, label: '${(index + 1) * 120}'),
              const SizedBox(height: 16),
              _ActionButton(icon: Icons.comment, label: '${(index + 1) * 5}'),
              const SizedBox(height: 16),
              const _ActionButton(icon: Icons.share, label: 'Share'),
              const SizedBox(height: 16),
              const _ActionButton(icon: Icons.more_vert, label: ''),
              const SizedBox(height: 16),
              Container(
                 width: 30,
                 height: 30,
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.white, width: 2),
                   borderRadius: BorderRadius.circular(5),
                   image: const DecorationImage(
                     image: NetworkImage('https://randomuser.me/api/portraits/thumb/women/1.jpg'),
                   ),
                 ),
              )
            ],
          ),
        ),

        // Back Button (for desktop/when not top level)
        Positioned(
          top: 40,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
               // Navigation handle
            },
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
