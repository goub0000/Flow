import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  final List<_SearchSuggestion> _suggestions = const [
    _SearchSuggestion(
      name: 'University of Ghana',
      location: 'Accra, Ghana',
      type: 'Public University',
    ),
    _SearchSuggestion(
      name: 'University of Cape Town',
      location: 'Cape Town, South Africa',
      type: 'Public University',
    ),
    _SearchSuggestion(
      name: 'Ashesi University',
      location: 'Berekuso, Ghana',
      type: 'Private University',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                    hintText: 'Search universities by name, country, or program...',
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
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _suggestions[index];
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
                          'Search 18,000+ Universities',
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
                  'Search universities...',
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
                  '18K+',
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

  @override
  Widget build(BuildContext context) {
    final filters = [
      'Engineering',
      'Business',
      'Medicine',
      'Arts',
      'Science',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: filters.map((filter) {
        return ActionChip(
          label: Text(filter),
          onPressed: () {
            onFilterTap?.call(filter);
            context.go('/universities?q=$filter');
          },
          avatar: Icon(
            _getFilterIcon(filter),
            size: 16,
          ),
        );
      }).toList(),
    );
  }

  IconData _getFilterIcon(String filter) {
    switch (filter.toLowerCase()) {
      case 'engineering':
        return Icons.engineering_outlined;
      case 'business':
        return Icons.business_center_outlined;
      case 'medicine':
        return Icons.local_hospital_outlined;
      case 'arts':
        return Icons.palette_outlined;
      case 'science':
        return Icons.science_outlined;
      default:
        return Icons.school_outlined;
    }
  }
}
