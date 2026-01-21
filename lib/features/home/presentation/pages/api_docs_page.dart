import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

/// API Reference page for developers
class ApiDocsPage extends StatelessWidget {
  const ApiDocsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('API Reference'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'API Reference',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Integrate Flow into your applications',
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
                        AppColors.primary.withOpacity(0.1),
                        AppColors.accent.withOpacity(0.1),
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
                            'Quick Start',
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
                          '''curl -X GET "https://api.flowedtech.com/v1/universities" \\
  -H "Authorization: Bearer YOUR_API_KEY" \\
  -H "Content-Type: application/json"''',
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
                  'API Endpoints',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildEndpointSection(theme, 'Universities', [
                  _Endpoint('GET', '/v1/universities', 'List all universities'),
                  _Endpoint('GET', '/v1/universities/{id}', 'Get university details'),
                  _Endpoint('GET', '/v1/universities/search', 'Search universities'),
                  _Endpoint('GET', '/v1/universities/{id}/programs', 'List programs'),
                ]),

                _buildEndpointSection(theme, 'Programs', [
                  _Endpoint('GET', '/v1/programs', 'List all programs'),
                  _Endpoint('GET', '/v1/programs/{id}', 'Get program details'),
                  _Endpoint('GET', '/v1/programs/search', 'Search programs'),
                ]),

                _buildEndpointSection(theme, 'Recommendations', [
                  _Endpoint('POST', '/v1/recommendations/generate', 'Generate recommendations'),
                  _Endpoint('GET', '/v1/recommendations/{id}', 'Get recommendation details'),
                ]),

                _buildEndpointSection(theme, 'Students', [
                  _Endpoint('GET', '/v1/students/profile', 'Get student profile'),
                  _Endpoint('PUT', '/v1/students/profile', 'Update student profile'),
                  _Endpoint('GET', '/v1/students/applications', 'List applications'),
                ]),

                const SizedBox(height: 32),

                // Authentication
                Text(
                  'Authentication',
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
                        'All API requests require authentication using an API key.',
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
                                'Authorization: Bearer YOUR_API_KEY',
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
                  'Rate Limits',
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
                      _buildRateLimitRow(theme, 'Free Tier', '100 requests/hour'),
                      const Divider(),
                      _buildRateLimitRow(theme, 'Basic', '1,000 requests/hour'),
                      const Divider(),
                      _buildRateLimitRow(theme, 'Pro', '10,000 requests/hour'),
                      const Divider(),
                      _buildRateLimitRow(theme, 'Enterprise', 'Unlimited'),
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
                              'Need API Access?',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Contact us to get your API credentials',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: () => context.go('/contact'),
                        child: const Text('Contact Us'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
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
              color: methodColor.withOpacity(0.1),
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
