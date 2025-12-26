import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ReelsPage extends StatelessWidget {
  const ReelsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Video Placeholder
              Container(
                color: Colors.grey[900],
                child: Center(
                  child: Icon(Icons.play_arrow_rounded, size: 80, color: Colors.white.withOpacity(0.5)),
                ),
              ),
              // Overlay Controls
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(radius: 16, backgroundColor: Colors.white),
                              SizedBox(width: 8),
                              Text('username', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Icon(Icons.verified, size: 16, color: Colors.blue),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'This is a sample reel caption with hashtags #flutter #dev',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const Icon(Icons.favorite_border, color: Colors.white, size: 30),
                        const SizedBox(height: 4),
                        const Text('123K', style: TextStyle(color: Colors.white, fontSize: 12)),
                        const SizedBox(height: 20),
                        const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 30),
                        const SizedBox(height: 4),
                        const Text('1.2K', style: TextStyle(color: Colors.white, fontSize: 12)),
                        const SizedBox(height: 20),
                        const Icon(Icons.send, color: Colors.white, size: 30),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
