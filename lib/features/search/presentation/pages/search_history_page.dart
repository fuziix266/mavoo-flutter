import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/search_history_model.dart';
import '../../data/repositories/search_repository.dart';

class SearchHistoryPage extends StatefulWidget {
  final SearchRepository searchRepository;

  const SearchHistoryPage({Key? key, required this.searchRepository}) : super(key: key);

  @override
  State<SearchHistoryPage> createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends State<SearchHistoryPage> {
  List<SearchHistory> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });
    // Load more items for the full history page
    final history = await widget.searchRepository.getHistory(limit: 50);
    setState(() {
      _history = history;
      _isLoading = false;
    });
  }

  Future<void> _deleteItem(int id) async {
    final success = await widget.searchRepository.deleteHistory(id);
    if (success) {
      _loadHistory();
    }
  }

  Future<void> _clearAll() async {
    final success = await widget.searchRepository.clearHistory();
    if (success) {
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Historial de búsqueda',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_history.isNotEmpty)
            TextButton(
              onPressed: _clearAll,
              child: const Text(
                'Borrar todo',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? const Center(
                  child: Text(
                    'No hay historial de búsqueda',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    return ListTile(
                      leading: Icon(
                        item.searchType == SearchType.people ? Icons.person : Icons.event,
                        color: AppColors.textSecondary,
                      ),
                      title: Text(item.searchQuery),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => _deleteItem(item.id),
                      ),
                      onTap: () {
                        Navigator.pop(context, item.searchQuery);
                      },
                    );
                  },
                ),
    );
  }
}
