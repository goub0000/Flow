import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// API Reference page for developers
class ApiDocsPage extends ConsumerWidget {
  const ApiDocsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildStaticPage(context);
  }

  Widget _buildStaticPage(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.apiDocsPageTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.apiDocsPageSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 32),

              // Quick Start
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.1),
                      AppColors.accent.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.code, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text(
                          l10n.apiDocsPageQuickStart,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        l10n.apiDocsPageQuickStartCode,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.greenAccent,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // API Endpoints
              Text(
                l10n.apiDocsPageEndpointsTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildEndpointSection(theme, l10n.apiDocsPageUniversitiesSection, [
                _Endpoint('GET', '/v1/universities', l10n.apiDocsPageUniversitiesList),
                _Endpoint('GET', '/v1/universities/{id}', l10n.apiDocsPageUniversitiesDetails),
                _Endpoint('GET', '/v1/universities/search', l10n.apiDocsPageUniversitiesSearch),
                _Endpoint('GET', '/v1/universities/{id}/programs', l10n.apiDocsPageUniversitiesPrograms),
              ]),

              _buildEndpointSection(theme, l10n.apiDocsPageProgramsSection, [
                _Endpoint('GET', '/v1/programs', l10n.apiDocsPageProgramsList),
                _Endpoint('GET', '/v1/programs/{id}', l10n.apiDocsPageProgramsDetails),
                _Endpoint('GET', '/v1/programs/search', l10n.apiDocsPageProgramsSearch),
              ]),

              _buildEndpointSection(theme, l10n.apiDocsPageRecommendationsSection, [
                _Endpoint('POST', '/v1/recommendations/generate', l10n.apiDocsPageRecommendationsGenerate),
                _Endpoint('GET', '/v1/recommendations/{id}', l10n.apiDocsPageRecommendationsDetails),
              ]),

              _buildEndpointSection(theme, l10n.apiDocsPageStudentsSection, [
                _Endpoint('GET', '/v1/students/profile', l10n.apiDocsPageStudentsProfile),
                _Endpoint('PUT', '/v1/students/profile', l10n.apiDocsPageStudentsUpdate),
                _Endpoint('GET', '/v1/students/applications', l10n.apiDocsPageStudentsApplications),
              ]),

              const SizedBox(height: 32),

              // Authentication
              Text(
                l10n.apiDocsPageAuthTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.apiDocsPageAuthDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.key, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SelectableText(
                              l10n.apiDocsPageAuthHeader,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 13,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Rate Limits
              Text(
                l10n.apiDocsPageRateLimitsTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildRateLimitRow(theme, l10n.apiDocsPageRateLimitFree, l10n.apiDocsPageRateLimitFreeValue),
                    const Divider(),
                    _buildRateLimitRow(theme, l10n.apiDocsPageRateLimitBasic, l10n.apiDocsPageRateLimitBasicValue),
                    const Divider(),
                    _buildRateLimitRow(theme, l10n.apiDocsPageRateLimitPro, l10n.apiDocsPageRateLimitProValue),
                    const Divider(),
                    _buildRateLimitRow(theme, l10n.apiDocsPageRateLimitEnterprise, l10n.apiDocsPageRateLimitEnterpriseValue),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Contact
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.developer_mode, size: 40, color: AppColors.primary),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.apiDocsPageContactTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.apiDocsPageContactDescription,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () => context.go('/contact'),
                      child: Text(l10n.apiDocsPageContactButton),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEndpointSection(ThemeData theme, String title, List<_Endpoint> endpoints) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...endpoints.map((e) => _buildEndpointItem(theme, e)),
        ],
      ),
    );
  }

  Widget _buildEndpointItem(ThemeData theme, _Endpoint endpoint) {
    final methodColor = endpoint.method == 'GET'
        ? Colors.green
        : endpoint.method == 'POST'
            ? Colors.blue
            : endpoint.method == 'PUT'
                ? Colors.orange
                : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: methodColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              endpoint.method,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: methodColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              endpoint.path,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
              ),
            ),
          ),
          Text(
            endpoint.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateLimitRow(ThemeData theme, String tier, String limit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(tier, style: theme.textTheme.bodyMedium),
          Text(
            limit,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Endpoint {
  final String method;
  final String path;
  final String description;

  _Endpoint(this.method, this.path, this.description);
}
