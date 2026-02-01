import 'package:flutter/material.dart';
import '../../data/testimonials_data.dart';

/// Accent colors assigned to each partner for visual variety.
const _partnerColors = <Color>[
  Color(0xFF1565C0), // blue
  Color(0xFF2E7D32), // green
  Color(0xFFC62828), // red
  Color(0xFF6A1B9A), // purple
  Color(0xFFEF6C00), // orange
  Color(0xFF00838F), // teal
  Color(0xFF4527A0), // deep purple
  Color(0xFFAD1457), // pink
];

/// A "Trusted By" logos section with horizontal scrolling.
///
/// Each institution is rendered as a stylised monogram badge with
/// an icon, initial letter, name, and country — giving visual weight
/// comparable to actual logos without needing trademarked assets.
class UniversityLogosSection extends StatelessWidget {
  final List<UniversityPartner>? partners;
  final String title;

  const UniversityLogosSection({
    super.key,
    this.partners,
    this.title = 'Trusted by Leading Institutions',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final partnerList = partners ?? PartnerUniversities.all;

    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: partnerList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 24),
            itemBuilder: (context, index) {
              return _UniversityLogoItem(
                partner: partnerList[index],
                color: _partnerColors[index % _partnerColors.length],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _UniversityLogoItem extends StatefulWidget {
  final UniversityPartner partner;
  final Color color;

  const _UniversityLogoItem({required this.partner, required this.color});

  @override
  State<_UniversityLogoItem> createState() => _UniversityLogoItemState();
}

class _UniversityLogoItemState extends State<_UniversityLogoItem> {
  bool _isHovered = false;

  String get _initial =>
      widget.partner.name.isNotEmpty ? widget.partner.name[0] : 'U';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = widget.color;

    // If a real logo URL exists, show it with grayscale → colour on hover.
    if (widget.partner.logoUrl != null) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: _isHovered
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? theme.colorScheme.primary.withValues(alpha: 0.3)
                  : theme.colorScheme.outlineVariant,
            ),
          ),
          child: Center(
            child: ColorFiltered(
              colorFilter: _isHovered
                  ? const ColorFilter.mode(
                      Colors.transparent, BlendMode.multiply)
                  : const ColorFilter.matrix([
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0, 0, 0, 1, 0,
                    ]),
              child: Image.network(
                widget.partner.logoUrl!,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
    }

    // Stylised monogram badge — no real logo available.
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: _isHovered
              ? accent.withValues(alpha: 0.08)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? accent.withValues(alpha: 0.4)
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Monogram circle with institution icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: _isHovered ? 0.15 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Large initial letter
                  Text(
                    _initial,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: accent,
                      height: 1,
                    ),
                  ),
                  // Small institution icon at bottom-right
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        size: 9,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Name + country
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.partner.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _isHovered
                        ? accent
                        : theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.partner.country,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// An auto-scrolling marquee style logo strip
class LogoMarquee extends StatefulWidget {
  final List<UniversityPartner>? partners;
  final Duration scrollDuration;
  final double itemWidth;

  const LogoMarquee({
    super.key,
    this.partners,
    this.scrollDuration = const Duration(seconds: 30),
    this.itemWidth = 200,
  });

  @override
  State<LogoMarquee> createState() => _LogoMarqueeState();
}

class _LogoMarqueeState extends State<LogoMarquee>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.scrollDuration,
    )..repeat();

    _animationController.addListener(_scroll);
  }

  void _scroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = maxScroll * _animationController.value;
      _scrollController.jumpTo(currentScroll);
    }
  }

  @override
  void dispose() {
    _animationController.removeListener(_scroll);
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final partnerList = widget.partners ?? PartnerUniversities.all;
    // Double the list for seamless looping
    final doubledList = [...partnerList, ...partnerList];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: doubledList.length,
        itemBuilder: (context, index) {
          final partner = doubledList[index % partnerList.length];
          return Container(
            width: widget.itemWidth,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Text(
              partner.name,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }
}

/// A static grid of university partner logos
class UniversityLogosGrid extends StatelessWidget {
  final List<UniversityPartner>? partners;

  const UniversityLogosGrid({
    super.key,
    this.partners,
  });

  @override
  Widget build(BuildContext context) {
    final partnerList = partners ?? PartnerUniversities.all;

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: partnerList.asMap().entries.map((entry) {
        return _UniversityLogoItem(
          partner: entry.value,
          color: _partnerColors[entry.key % _partnerColors.length],
        );
      }).toList(),
    );
  }
}
