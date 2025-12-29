import 'package:flutter/material.dart';
import '../../features/widgets/data/mock_widget_service.dart';
import '../../features/widgets/presentation/widgets/sports_widgets.dart';

class RightSidebar extends StatefulWidget {
  const RightSidebar({Key? key}) : super(key: key);

  @override
  State<RightSidebar> createState() => _RightSidebarState();
}

class _RightSidebarState extends State<RightSidebar> {
  final MockWidgetService _service = MockWidgetService();
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      child: AnimatedBuilder(
        animation: _service,
        builder: (context, child) {
          final visibleWidgets = _service.visibleWidgets;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Edit Header
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    icon: Icon(_isEditing ? Icons.check : Icons.edit, size: 16),
                    label: Text(_isEditing ? 'Done' : 'Edit Widgets'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_isEditing)
                // Drag and Drop List
                SizedBox(
                  height: 600, // Fixed height for reorder list
                  child: ReorderableListView(
                    onReorder: (oldIndex, newIndex) {
                       _service.reorderWidgets(oldIndex, newIndex);
                    },
                    children: visibleWidgets.map((item) {
                      return Container(
                        key: ValueKey(item.id),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: WidgetCard(
                          title: item.title,
                          child: _buildWidgetContent(item.type),
                        ),
                      );
                    }).toList(),
                  ),
                )
              else
                // Normal Display
                Column(
                  children: visibleWidgets.map((item) {
                    return WidgetCard(
                      title: item.title,
                      child: _buildWidgetContent(item.type),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 24),

              // Always show Who to Follow if desired, or make it a widget too
              _WhoToFollowWidget(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWidgetContent(String type) {
    switch (type) {
      case 'goal': return const GoalWidget();
      case 'calories': return const CaloriesWidget();
      case 'events': return const EventsWidget();
      case 'ranking': return const RankingWidget();
      default: return const SizedBox();
    }
  }
}


class _WhoToFollowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Who to Follow',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _FollowSuggestion(
          name: 'Coach Sarah',
          role: 'Triathlete',
        ),
        const SizedBox(height: 12),
        _FollowSuggestion(
          name: 'Mike Bike',
          role: 'Cyclist',
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'See more suggestions',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _FollowSuggestion extends StatelessWidget {
  final String name;
  final String role;

  const _FollowSuggestion({
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.backgroundLight,
          ),
          child: const Icon(
            Icons.person,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                role,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () {},
          color: AppColors.primary,
          iconSize: 20,
        ),
      ],
    );
  }
}
