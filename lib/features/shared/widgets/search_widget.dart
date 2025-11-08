import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/theme/app_colors.dart';

/// Global Search Widget with Autocomplete
///
/// Provides a comprehensive search experience with:
/// - Real-time search suggestions
/// - Search history
/// - Popular searches
/// - Debounced search input
/// - Category-specific search
///
/// Backend Integration TODO:
/// ```dart
/// // Option 1: Elasticsearch/Algolia for advanced search
/// import 'package:algolia/algolia.dart';
///
/// class SearchService {
///   final Algolia algolia = Algolia.init(
///     applicationId: 'YOUR_APP_ID',
///     apiKey: 'YOUR_API_KEY',
///   );
///
///   Future<List<SearchResult>> search(String query, {String? category}) async {
///     AlgoliaQuery algoliaQuery = algolia.instance.index('courses').query(query);
///
///     if (category != null) {
///       algoliaQuery = algoliaQuery.filters('category:$category');
///     }
///
///     final snapshot = await algoliaQuery.getObjects();
///     return snapshot.hits.map((hit) => SearchResult.fromJson(hit.data)).toList();
///   }
///
///   Future<List<String>> getSuggestions(String query) async {
///     final algoliaQuery = algolia.instance
///         .index('courses')
///         .query(query)
///         .setHitsPerPage(5);
///
///     final snapshot = await algoliaQuery.getObjects();
///     return snapshot.hits.map((hit) => hit.data['title'] as String).toList();
///   }
/// }
///
/// // Option 2: Custom API with search endpoint
/// import 'package:dio/dio.dart';
///
/// class SearchService {
///   final Dio _dio;
///
///   Future<List<SearchResult>> search(String query, {
///     String? category,
///     int page = 1,
///     int limit = 20,
///   }) async {
///     final response = await _dio.get('/api/search', queryParameters: {
///       'q': query,
///       'category': category,
///       'page': page,
///       'limit': limit,
///     });
///
///     return (response.data['results'] as List)
///         .map((json) => SearchResult.fromJson(json))
///         .toList();
///   }
///
///   Future<List<String>> getSuggestions(String query) async {
///     final response = await _dio.get('/api/search/suggestions',
///       queryParameters: {'q': query}
///     );
///     return List<String>.from(response.data['suggestions']);
///   }
/// }
///
/// // Save search history using SharedPreferences
/// import 'package:shared_preferences/shared_preferences.dart';
///
/// class SearchHistoryService {
///   static const _key = 'search_history';
///   static const _maxHistory = 10;
///
///   Future<List<String>> getHistory() async {
///     final prefs = await SharedPreferences.getInstance();
///     return prefs.getStringList(_key) ?? [];
///   }
///
///   Future<void> addToHistory(String query) async {
///     final prefs = await SharedPreferences.getInstance();
///     final history = await getHistory();
///
///     history.remove(query); // Remove if exists
///     history.insert(0, query); // Add to top
///
///     if (history.length > _maxHistory) {
///       history.removeRange(_maxHistory, history.length);
///     }
///
///     await prefs.setStringList(_key, history);
///   }
///
///   Future<void> clearHistory() async {
///     final prefs = await SharedPreferences.getInstance();
///     await prefs.remove(_key);
///   }
/// }
/// ```

/// Search Widget with autocomplete
class SearchWidget extends StatefulWidget {
  final String hint;
  final Function(String) onSearch;
  final Function(String)? onSuggestionSelected;
  final List<String>? categories;
  final String? selectedCategory;
  final Function(String?)? onCategoryChanged;
  final bool showCategoryFilter;

  const SearchWidget({
    super.key,
    this.hint = 'Search...',
    required this.onSearch,
    this.onSuggestionSelected,
    this.categories,
    this.selectedCategory,
    this.onCategoryChanged,
    this.showCategoryFilter = false,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  List<String> _suggestions = [];
  List<String> _recentSearches = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    // TODO: Load from SearchHistoryService
    // final history = await SearchHistoryService().getHistory();

    // Mock recent searches
    setState(() {
      _recentSearches = [
        'Computer Science',
        'Business Administration',
        'Engineering',
      ];
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _fetchSuggestions(query);
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    try {
      // TODO: Fetch suggestions from backend
      // final suggestions = await SearchService().getSuggestions(query);

      // Mock suggestions based on query
      await Future.delayed(const Duration(milliseconds: 200));
      final mockSuggestions = [
        'Computer Science Fundamentals',
        'Computer Programming',
        'Computer Networks',
        'Computer Architecture',
        'Computer Graphics',
      ].where((s) => s.toLowerCase().contains(query.toLowerCase())).toList();

      if (mounted) {
        setState(() {
          _suggestions = mockSuggestions.take(5).toList();
        });
      }
    } catch (e) {
      // Handle error silently
      setState(() {
        _suggestions = [];
      });
    }
  }

  void _handleSearch(String query) {
    if (query.isEmpty) return;

    _focusNode.unfocus();
    _addToRecentSearches(query);
    widget.onSearch(query);

    setState(() {
      _showSuggestions = false;
    });
  }

  Future<void> _addToRecentSearches(String query) async {
    // TODO: Save to SearchHistoryService
    // await SearchHistoryService().addToHistory(query);

    setState(() {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 5) {
        _recentSearches = _recentSearches.take(5).toList();
      }
    });
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    _handleSearch(suggestion);
    widget.onSuggestionSelected?.call(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _focusNode.hasFocus ? AppColors.primary : AppColors.border,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
            boxShadow: _focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Category Filter
              if (widget.showCategoryFilter && widget.categories != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: DropdownButton<String?>(
                    value: widget.selectedCategory,
                    hint: const Text('All'),
                    underline: const SizedBox.shrink(),
                    icon: const Icon(Icons.arrow_drop_down, size: 20),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All'),
                      ),
                      ...widget.categories!.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }),
                    ],
                    onChanged: widget.onCategoryChanged,
                  ),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: AppColors.border,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ],

              // Search Icon
              const Padding(
                padding: EdgeInsets.only(left: 12, right: 8),
                child: Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
              ),

              // Text Field
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  onChanged: _onSearchChanged,
                  onSubmitted: _handleSearch,
                  textInputAction: TextInputAction.search,
                ),
              ),

              // Clear Button
              if (_controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.clear,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _suggestions = [];
                    });
                  },
                ),
            ],
          ),
        ),

        // Suggestions Overlay
        if (_showSuggestions && (_suggestions.isNotEmpty || _recentSearches.isNotEmpty))
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Recent Searches
                if (_controller.text.isEmpty && _recentSearches.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Searches',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _recentSearches.clear();
                            });
                            // TODO: Clear history
                            // SearchHistoryService().clearHistory();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Clear',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ..._recentSearches.map((search) {
                    return InkWell(
                      onTap: () => _selectSuggestion(search),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.history,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                search,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const Icon(
                              Icons.north_west,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],

                // Suggestions
                if (_suggestions.isNotEmpty) ...[
                  if (_controller.text.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Suggestions',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ..._suggestions.map((suggestion) {
                    return InkWell(
                      onTap: () => _selectSuggestion(suggestion),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                suggestion,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const Icon(
                              Icons.north_west,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// Compact Search Bar (for app bars)
class CompactSearchBar extends StatelessWidget {
  final String hint;
  final VoidCallback onTap;

  const CompactSearchBar({
    super.key,
    this.hint = 'Search...',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: 20,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hint,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Search Results Model
class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final String type; // 'course', 'program', 'institution', etc.
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.imageUrl,
    this.metadata,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'] ?? '',
      type: json['type'],
      imageUrl: json['imageUrl'],
      metadata: json['metadata'],
    );
  }
}
