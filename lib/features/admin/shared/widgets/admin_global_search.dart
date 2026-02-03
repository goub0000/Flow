import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Global Search Widget for Admin Dashboard
/// Provides quick search across users, content, transactions, etc.
class AdminGlobalSearch extends StatefulWidget {
  const AdminGlobalSearch({super.key});

  @override
  State<AdminGlobalSearch> createState() => _AdminGlobalSearchState();
}

class _AdminGlobalSearchState extends State<AdminGlobalSearch> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    // Remove overlay without calling setState during dispose
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _onFocusChange() {
    if (_searchFocusNode.hasFocus) {
      _showSearchResults();
    } else {
      // Delay to allow clicking on results
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!_searchFocusNode.hasFocus) {
          _removeOverlay();
        }
      });
    }
  }

  void _showSearchResults() {
    _removeOverlay();
    if (mounted) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      setState(() => _isSearching = true);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _isSearching = false);
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: 500,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 8),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 500),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: _buildSearchResults(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        // Ctrl/Cmd + K to focus search
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.keyK &&
            (HardwareKeyboard.instance.isMetaPressed ||
                HardwareKeyboard.instance.isControlPressed)) {
          _searchFocusNode.requestFocus();
        }
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Container(
          width: 400,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isSearching ? AppColors.primary : AppColors.border,
              width: _isSearching ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search (demo data) - Press ⌘K or Ctrl+K',
              hintStyle: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20,
                color: _isSearching ? AppColors.primary : AppColors.textSecondary,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      padding: EdgeInsets.zero,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            onChanged: (value) {
              setState(() {});
              // Note: Search displays demo data. Backend integration needed for real search.
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) {
      return _buildRecentSearches();
    }

    // Note: Displaying demo data for demonstration purposes
    return _buildDemoResults();
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.history, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: AppColors.border),
        _buildSearchSuggestions(),
        Divider(height: 1, color: AppColors.border),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tip: Use ⌘K or Ctrl+K to quickly access search',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSuggestions() {
    final suggestions = [
      SearchSuggestion(
        icon: Icons.people,
        category: 'Users',
        text: 'Active students',
        color: AppColors.primary,
      ),
      SearchSuggestion(
        icon: Icons.description,
        category: 'Applications',
        text: 'Pending applications',
        color: AppColors.warning,
      ),
      SearchSuggestion(
        icon: Icons.attach_money,
        category: 'Transactions',
        text: 'Failed payments',
        color: AppColors.error,
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return InkWell(
          onTap: () {
            _searchController.text = suggestion.text;
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: suggestion.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    suggestion.icon,
                    size: 16,
                    color: suggestion.color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion.text,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        suggestion.category,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward,
                    size: 16, color: AppColors.textSecondary),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDemoResults() {
    // Displaying sample/demo data for UI demonstration
    final categories = [
      _buildCategoryResults(
        'Users',
        Icons.people,
        AppColors.primary,
        [
          SearchResult(
            title: 'John Doe',
            subtitle: 'john.doe@example.com • Student',
            icon: Icons.person,
          ),
          SearchResult(
            title: 'Jane Smith',
            subtitle: 'jane.smith@example.com • Teacher',
            icon: Icons.person,
          ),
        ],
      ),
      _buildCategoryResults(
        'Content',
        Icons.library_books,
        AppColors.success,
        [
          SearchResult(
            title: 'Mathematics Grade 10',
            subtitle: 'Course • Published',
            icon: Icons.school,
          ),
        ],
      ),
      _buildCategoryResults(
        'Transactions',
        Icons.attach_money,
        AppColors.warning,
        [
          SearchResult(
            title: 'TXN-12345',
            subtitle: 'KES 5,000 • Completed',
            icon: Icons.receipt,
          ),
        ],
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Search results for "${_searchController.text}"',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.border),
          ...categories,
        ],
      ),
    );
  }

  Widget _buildCategoryResults(
    String category,
    IconData icon,
    Color color,
    List<SearchResult> results,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                category,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        ...results.map((result) => InkWell(
              onTap: () {
                _searchFocusNode.unfocus();
                // Note: Navigation to search results requires implementation of detail pages
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(result.icon, size: 16, color: color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            result.subtitle,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward,
                        size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

/// Search Suggestion Model
class SearchSuggestion {
  final IconData icon;
  final String category;
  final String text;
  final Color color;

  SearchSuggestion({
    required this.icon,
    required this.category,
    required this.text,
    required this.color,
  });
}

/// Search Result Model
class SearchResult {
  final String title;
  final String subtitle;
  final IconData icon;

  SearchResult({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
