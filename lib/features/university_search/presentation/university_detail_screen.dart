import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/university_model.dart';
import '../providers/university_search_provider.dart';

/// University Detail Screen showing comprehensive university information
class UniversityDetailScreen extends ConsumerWidget {
  final int universityId;
  final University? university;

  const UniversityDetailScreen({
    super.key,
    required this.universityId,
    this.university,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If university was passed directly, use it; otherwise fetch from API
    if (university != null) {
      return _UniversityDetailContent(university: university!);
    }

    final asyncUniversity = ref.watch(universityByIdProvider(universityId));

    return asyncUniversity.when(
      data: (uni) {
        if (uni == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('University Not Found')),
            body: const Center(
              child: Text('This university could not be found.'),
            ),
          );
        }
        return _UniversityDetailContent(university: uni);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text('Error loading university: $error'),
        ),
      ),
    );
  }
}

class _UniversityDetailContent extends StatelessWidget {
  final University university;

  const _UniversityDetailContent({required this.university});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                university.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        university.name.isNotEmpty ? university.name[0].toUpperCase() : 'U',
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              if (university.website != null)
                IconButton(
                  icon: const Icon(Icons.language),
                  tooltip: 'Visit Website',
                  onPressed: () => _launchUrl(university.website!),
                ),
            ],
          ),
          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Location Card
                _InfoCard(
                  title: 'Location',
                  icon: Icons.location_on,
                  children: [
                    _InfoRow(
                      label: 'Address',
                      value: [
                        university.city,
                        university.state,
                        university.country,
                      ].where((s) => s != null && s.isNotEmpty).join(', '),
                    ),
                    if (university.locationType != null)
                      _InfoRow(label: 'Setting', value: university.locationType!),
                  ],
                ),
                const SizedBox(height: 16),

                // Key Statistics
                _InfoCard(
                  title: 'Key Statistics',
                  icon: Icons.analytics,
                  children: [
                    if (university.totalStudents != null)
                      _InfoRow(
                        label: 'Total Students',
                        value: _formatNumber(university.totalStudents!),
                      ),
                    if (university.acceptanceRate != null)
                      _InfoRow(
                        label: 'Acceptance Rate',
                        value: '${(university.acceptanceRate! * 100).toStringAsFixed(1)}%',
                      ),
                    if (university.graduationRate4year != null)
                      _InfoRow(
                        label: '4-Year Graduation Rate',
                        value: '${(university.graduationRate4year! * 100).toStringAsFixed(1)}%',
                      ),
                    if (university.gpaAverage != null)
                      _InfoRow(
                        label: 'Average GPA',
                        value: university.gpaAverage!.toStringAsFixed(2),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tuition & Costs
                _InfoCard(
                  title: 'Tuition & Costs',
                  icon: Icons.payments,
                  children: [
                    if (university.tuitionOutState != null)
                      _InfoRow(
                        label: 'Tuition (Out-of-State)',
                        value: _formatCurrency(university.tuitionOutState!),
                      ),
                    if (university.totalCost != null)
                      _InfoRow(
                        label: 'Total Cost',
                        value: _formatCurrency(university.totalCost!),
                        highlight: true,
                      ),
                    if (university.medianEarnings10year != null)
                      _InfoRow(
                        label: 'Median Earnings (10 yr)',
                        value: _formatCurrency(university.medianEarnings10year!),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Admissions - Test Scores
                if (university.satMath25th != null || university.satEbrw25th != null || university.actComposite25th != null)
                  _InfoCard(
                    title: 'Test Scores (25th-75th Percentile)',
                    icon: Icons.school,
                    children: [
                      if (university.satMath25th != null && university.satMath75th != null)
                        _InfoRow(
                          label: 'SAT Math',
                          value: '${university.satMath25th} - ${university.satMath75th}',
                        ),
                      if (university.satEbrw25th != null && university.satEbrw75th != null)
                        _InfoRow(
                          label: 'SAT EBRW',
                          value: '${university.satEbrw25th} - ${university.satEbrw75th}',
                        ),
                      if (university.actComposite25th != null && university.actComposite75th != null)
                        _InfoRow(
                          label: 'ACT Composite',
                          value: '${university.actComposite25th} - ${university.actComposite75th}',
                        ),
                    ],
                  ),
                if (university.satMath25th != null || university.satEbrw25th != null || university.actComposite25th != null)
                  const SizedBox(height: 16),

                // Rankings
                if (university.globalRank != null || university.nationalRank != null)
                  _InfoCard(
                    title: 'Rankings',
                    icon: Icons.emoji_events,
                    children: [
                      if (university.globalRank != null)
                        _InfoRow(
                          label: 'Global Rank',
                          value: '#${university.globalRank}',
                        ),
                      if (university.nationalRank != null)
                        _InfoRow(
                          label: 'National Rank',
                          value: '#${university.nationalRank}',
                        ),
                    ],
                  ),
                if (university.globalRank != null || university.nationalRank != null)
                  const SizedBox(height: 16),

                // About
                _InfoCard(
                  title: 'About',
                  icon: Icons.info,
                  children: [
                    if (university.universityType != null)
                      _InfoRow(label: 'Type', value: university.universityType!),
                    if (university.website != null)
                      _InfoRow(
                        label: 'Website',
                        value: university.website!,
                        isLink: true,
                        onTap: () => _launchUrl(university.website!),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                if (university.description != null && university.description!.isNotEmpty)
                  _InfoCard(
                    title: 'Description',
                    icon: Icons.description,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          university.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  String _formatCurrency(double amount) {
    return '\$${amount.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        )}';
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Info card container
class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (children.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

/// Info row widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final bool isLink;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.isLink = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (value.isEmpty) return const SizedBox.shrink();

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
                color: isLink
                    ? theme.colorScheme.primary
                    : highlight
                        ? theme.colorScheme.primary
                        : null,
                decoration: isLink ? TextDecoration.underline : null,
              ),
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}
