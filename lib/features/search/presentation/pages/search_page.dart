import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/search_history_model.dart';
import '../../data/models/search_results_model.dart';
import '../../data/repositories/search_repository.dart';
import 'search_history_page.dart';
import '../../../events/data/models/event_model.dart';
import '../../../auth/data/models/user_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SearchRepository _searchRepository;
  late TextEditingController _searchController;
  
  List<SearchHistory> _recentSearches = [];
  SearchResults? _searchResults;
  bool _isLoading = false;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController = TextEditingController();
    _searchRepository = SearchRepository(baseUrl: 'http://localhost:8000');
    _loadRecentSearches();
    
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _showResults = false;
        _searchResults = null;
      });
    } else {
      _performSearch();
    }
  }

  Future<void> _loadRecentSearches() async {
    final history = await _searchRepository.getHistory(limit: 10);
    setState(() {
      _recentSearches = history;
    });
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final type = _tabController.index == 0
        ? SearchType.all
        : _tabController.index == 1
            ? SearchType.people
            : SearchType.events;

    final results = await _searchRepository.search(query, type);
    
    // Add to history
    await _searchRepository.addToHistory(
      query,
      type,
      resultsCount: results.people.length + results.events.length,
    );

    setState(() {
      _searchResults = results;
      _isLoading = false;
      _showResults = true;
    });
  }

  Future<void> _deleteSearch(int id) async {
    await _searchRepository.deleteHistory(id);
    _loadRecentSearches();
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
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Buscar personas, eventos...',
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 20),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          onTap: (_) {
            if (_searchController.text.isNotEmpty) {
              _performSearch();
            }
          },
          tabs: const [
            Tab(text: 'Todo'),
            Tab(text: 'Personas'),
            Tab(text: 'Eventos'),
          ],
        ),
      ),
      body: _showResults
          ? _buildSearchResults()
          : _buildRecentSearches(),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults == null || _searchResults!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
            const SizedBox(height: 16),
            const Text(
              'No se encontraron resultados',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildAllResults(),
        _buildPeopleResults(),
        _buildEventsResults(),
      ],
    );
  }

  Widget _buildAllResults() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_searchResults!.people.isNotEmpty) ...[
          const Text(
            'Personas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._searchResults!.people.map((person) => _buildPersonItem(person)),
          const SizedBox(height: 24),
        ],
        if (_searchResults!.events.isNotEmpty) ...[
          const Text(
            'Eventos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._searchResults!.events.map((event) => _buildEventItem(event)),
        ],
      ],
    );
  }

  Widget _buildPeopleResults() {
    if (_searchResults!.people.isEmpty) {
      return const Center(child: Text('No se encontraron personas'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults!.people.length,
      itemBuilder: (context, index) => _buildPersonItem(_searchResults!.people[index]),
    );
  }

  Widget _buildEventsResults() {
    if (_searchResults!.events.isEmpty) {
      return const Center(child: Text('No se encontraron eventos'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults!.events.length,
      itemBuilder: (context, index) => _buildEventItem(_searchResults!.events[index]),
    );
  }

  Widget _buildPersonItem(UserModel person) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: person.profileImage != null
            ? NetworkImage(person.profileImage!)
            : null,
        child: person.profileImage == null
            ? const Icon(Icons.person)
            : null,
      ),
      title: Text(person.fullName ?? ''),
      subtitle: Text('@${person.username}'),
      onTap: () {
        // TODO: Navigate to profile
      },
    );
  }

  Widget _buildEventItem(Event event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: event.imageUrl != null
            ? Image.network(event.imageUrl!, width: 60, height: 60, fit: BoxFit.cover)
            : const Icon(Icons.event, size: 40),
        title: Text(event.name),
        subtitle: Text(event.location ?? ''),
        onTap: () {
          // TODO: Navigate to event details
        },
      ),
    );
  }

  Widget _buildRecentSearches() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recientes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_recentSearches.isNotEmpty)
              TextButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchHistoryPage(
                        searchRepository: _searchRepository,
                      ),
                    ),
                  );

                  if (result != null && result is String) {
                    _searchController.text = result;
                    _performSearch();
                  } else {
                    _loadRecentSearches();
                  }
                },
                child: const Text('Editar'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_recentSearches.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No hay búsquedas recientes',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ..._recentSearches.map((search) => ListTile(
                leading: Icon(
                  search.searchType == SearchType.people
                      ? Icons.person
                      : Icons.event,
                  color: AppColors.textSecondary,
                ),
                title: Text(search.searchQuery),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => _deleteSearch(search.id),
                ),
                onTap: () {
                  _searchController.text = search.searchQuery;
                  _performSearch();
                },
              )),
      ],
    );
  }
}
