import 'package:flutter/foundation.dart';

class SportsWidgetModel {
  final String id;
  final String title;
  final String type; // 'goal', 'calories', 'events', 'ranking'
  bool isVisible;

  SportsWidgetModel({
    required this.id,
    required this.title,
    required this.type,
    this.isVisible = true,
  });
}

class MockWidgetService extends ChangeNotifier {
  static final MockWidgetService _instance = MockWidgetService._internal();

  factory MockWidgetService() {
    return _instance;
  }

  MockWidgetService._internal();

  List<SportsWidgetModel> _widgets = [
    SportsWidgetModel(id: '1', title: 'Weekly Goal', type: 'goal', isVisible: true),
    SportsWidgetModel(id: '2', title: 'Calories Burned', type: 'calories', isVisible: true),
    SportsWidgetModel(id: '3', title: 'Upcoming Events', type: 'events', isVisible: true),
    SportsWidgetModel(id: '4', title: 'Friend Ranking', type: 'ranking', isVisible: false),
  ];

  List<SportsWidgetModel> get widgets => _widgets;

  List<SportsWidgetModel> get visibleWidgets => _widgets.where((w) => w.isVisible).toList();

  void toggleVisibility(String id) {
    final index = _widgets.indexWhere((w) => w.id == id);
    if (index != -1) {
      _widgets[index].isVisible = !_widgets[index].isVisible;
      notifyListeners();
    }
  }

  void reorderWidgets(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = _widgets.removeAt(oldIndex);
    _widgets.insert(newIndex, item);
    notifyListeners();
  }
}
