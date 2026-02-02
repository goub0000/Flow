import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n_extension.dart';

/// A university search preview widget for the home page.
///
/// Features a styled search input with fake autocomplete dropdown
/// and "Search 18,000+ Universities" CTA.
class SearchPreview extends StatefulWidget {
  final VoidCallback? onSearchTap;

  const SearchPreview({
    super.key,
    this.onSearchTap,
  });

  @override
  State<SearchPreview> createState() => _SearchPreviewState();
}

class _SearchPreviewState extends State<SearchPreview> {
  bool _isFocused = false;
  final TextEditingController _controller = TextEditingController();

  List<_SearchSuggestion> _buildSuggestions(BuildContext context) {
    return [
      _SearchSuggestion(
        name: context.l10n.searchSuggestionGhana,
        location: context.l10n.searchSuggestionGhanaLocation,
        type: context.l10n.searchSuggestionPublicUniversity,
      ),
      _SearchSuggestion(
        name: context.l10n.searchSuggestionCapeTown,
        location: context.l10n.searchSuggestionCapeTownLocation,
        type: context.l10n.searchSuggestionPublicUniversity,
      ),
      _SearchSuggestion(
        name: context.l10n.searchSuggestionAshesi,
        location: context.l10n.searchSuggestionAshesiLocation,
        type: context.l10n.searchSuggestionPrivateUniversity,
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestions = _buildSuggestions(context);

    return Column(
      children: [
        // Search Input
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isFocused
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
              width: _isFocused ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isFocused
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isFocused ? 20 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Input Field
              Focus(
                onFocusChange: (focused) {
                  setState(() => _isFocused = focused);
                },
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: context.l10n.searchHint,
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: _isFocused
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _controller.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  onTap: () {
                    setState(() => _isFocused = true);
                  },
                  onSubmitted: (_) {
                    widget.onSearchTap?.call();
                    context.go('/universities');
                  },
                ),
              ),

              // Fake Autocomplete Dropdown
              if (_isFocused) ...[
                Divider(
                  height: 1,
                  color: theme.colorScheme.outlineVariant,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    return InkWell(
                      onTap: () {
                        widget.onSearchTap?.call();
                        context.go('/universities');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.school_outlined,
                                color: theme.colorScheme.onPrimaryContainer,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    suggestion.name,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${suggestion.location} • ${suggestion.type}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.north_west,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // View All Link
                InkWell(
                  onTap: () => context.go('/universities'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.l10n.searchUniversitiesCount,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchSuggestion {
  final String name;
  final String location;
  final String type;

  const _SearchSuggestion({
    required this.name,
    required this.location,
    required this.type,
  });
}

/// A compact search bar button that navigates to universities page
class SearchBarButton extends StatefulWidget {
  const SearchBarButton({super.key});

  @override
  State<SearchBarButton> createState() => _SearchBarButtonState();
}

class _SearchBarButtonState extends State<SearchBarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/universities'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _isHovered
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.04),
                blurRadius: _isHovered ? 16 : 8,
                offset: Offset(0, _isHovered ? 4 : 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: _isHovered
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.searchPlaceholder,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  context.l10n.searchBadge,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quick filter chips for the search
class SearchFilterChips extends StatelessWidget {
  final Function(String)? onFilterTap;

  const SearchFilterChips({
    super.key,
    this.onFilterTap,
  });

  static const _filterIcons = <String, IconData>{
    'engineering': Icons.engineering_outlined,
    'business': Icons.business_center_outlined,
    'medicine': Icons.local_hospital_outlined,
    'arts': Icons.palette_outlined,
    'science': Icons.science_outlined,
  };

  List<_FilterEntry> _buildFilters(BuildContext context) {
    return [
      _FilterEntry(key: 'engineering', label: context.l10n.filterEngineering),
      _FilterEntry(key: 'business', label: context.l10n.filterBusiness),
      _FilterEntry(key: 'medicine', label: context.l10n.filterMedicine),
      _FilterEntry(key: 'arts', label: context.l10n.filterArts),
      _FilterEntry(key: 'science', label: context.l10n.filterScience),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final filters = _buildFilters(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: filters.map((filter) {
        return ActionChip(
          label: Text(filter.label),
          onPressed: () {
            onFilterTap?.call(filter.key);
            context.go('/universities?q=${filter.key}');
          },
          avatar: Icon(
            _filterIcons[filter.key] ?? Icons.school_outlined,
            size: 16,
          ),
        );
      }).toList(),
    );
  }
}

class _FilterEntry {
  final String key;
  final String label;

  const _FilterEntry({required this.key, required this.label});
}
