import 'package:flutter/material.dart';
import '../../data/testimonials_data.dart';

/// A "Trusted By" logos section with horizontal scrolling.
///
/// Features:
/// - Horizontal scrolling logos
/// - Grayscale to color on hover
/// - Placeholder styled boxes if no images
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
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: partnerList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 32),
            itemBuilder: (context, index) {
              return _UniversityLogoItem(partner: partnerList[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _UniversityLogoItem extends StatefulWidget {
  final UniversityPartner partner;

  const _UniversityLogoItem({required this.partner});

  @override
  State<_UniversityLogoItem> createState() => _UniversityLogoItemState();
}

class _UniversityLogoItemState extends State<_UniversityLogoItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: _isHovered
              ? theme.colorScheme.primaryContainer.withOpacity(0.3)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? theme.colorScheme.primary.withOpacity(0.3)
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Center(
          child: widget.partner.logoUrl != null
              ? ColorFiltered(
                  colorFilter: _isHovered
                      ? const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        )
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
                )
              : Text(
                  widget.partner.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: _isHovered
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
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
      spacing: 32,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: partnerList.map((partner) {
        return _UniversityLogoItem(partner: partner);
      }).toList(),
    );
  }
}
