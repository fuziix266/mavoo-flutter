import 'package:flutter/material.dart';

class WidgetCard extends StatelessWidget {
  final Widget child;
  final String title;
  final VoidCallback? onEdit;

  const WidgetCard({
    Key? key,
    required this.child,
    required this.title,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              if (onEdit != null)
                TextButton(
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Edit', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class GoalWidget extends StatelessWidget {
  const GoalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            children: [
              const CircularProgressIndicator(
                value: 0.7,
                strokeWidth: 6,
                backgroundColor: Color(0xFFF0F0F0),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const Center(
                child: Text('70%', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  text: '35 ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '/ 50 km',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text('15km para tu meta!', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}

class CaloriesWidget extends StatelessWidget {
  const CaloriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.local_fire_department, color: Colors.orange),
            SizedBox(width: 8),
            Text('1,250 kcal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: 0.8,
          backgroundColor: Colors.orange.withOpacity(0.2),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        const Text('Hoy', style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class EventsWidget extends StatelessWidget {
  const EventsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildEventItem('Maratón Santiago', '12 Oct'),
        const Divider(height: 16),
        _buildEventItem('Entrenamiento Grupal', '15 Oct'),
      ],
    );
  }

  Widget _buildEventItem(String title, String date) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.event, color: Colors.blue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

class RankingWidget extends StatelessWidget {
  const RankingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRankItem(1, 'Ana', 120),
        const SizedBox(height: 8),
        _buildRankItem(2, 'Carlos', 95),
        const SizedBox(height: 8),
        _buildRankItem(3, 'Tu', 80, isMe: true),
      ],
    );
  }

  Widget _buildRankItem(int rank, String name, int points, {bool isMe = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rank == 1 ? Colors.amber : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Text('$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Text(name, style: TextStyle(fontWeight: isMe ? FontWeight.bold : FontWeight.normal)),
          const Spacer(),
          Text('$points pts', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        ],
      ),
    );
  }
}
