import 'package:flutter/material.dart';
import '../../data/mock_widget_service.dart';

class WidgetsSelectionPage extends StatefulWidget {
  const WidgetsSelectionPage({Key? key}) : super(key: key);

  @override
  State<WidgetsSelectionPage> createState() => _WidgetsSelectionPageState();
}

class _WidgetsSelectionPageState extends State<WidgetsSelectionPage> {
  final MockWidgetService _service = MockWidgetService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header
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
                  'Widgets',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Expanded(
            child: AnimatedBuilder(
              animation: _service,
              builder: (context, child) {
                final widgets = _service.widgets;
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: widgets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final widgetItem = widgets[index];
                    return SwitchListTile(
                      title: Text(widgetItem.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Show ${widgetItem.title.toLowerCase()} on sidebar'),
                      value: widgetItem.isVisible,
                      onChanged: (bool value) {
                        _service.toggleVisibility(widgetItem.id);
                      },
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getIconForType(widgetItem.type),
                          color: Colors.blue,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'goal': return Icons.flag;
      case 'calories': return Icons.local_fire_department;
      case 'events': return Icons.event;
      case 'ranking': return Icons.leaderboard;
      default: return Icons.widgets;
    }
  }
}
