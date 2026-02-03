import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import '../../authentication/providers/auth_provider.dart';
import '../../shared/widgets/custom_card.dart';
import '../../shared/widgets/loading_indicator.dart';

/// Debug screen for institution to diagnose application issues
class InstitutionDebugScreen extends ConsumerStatefulWidget {
  const InstitutionDebugScreen({super.key});

  @override
  ConsumerState<InstitutionDebugScreen> createState() => _InstitutionDebugScreenState();
}

class _InstitutionDebugScreenState extends ConsumerState<InstitutionDebugScreen> {
  Map<String, dynamic>? _debugData;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _runDebugCheck();
  }

  Future<void> _runDebugCheck() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authState = ref.read(authProvider);
      final token = authState.accessToken;

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Railway production URL
      const baseUrl = 'https://web-production-51e34.up.railway.app/api/v1';

      final response = await http.get(
        Uri.parse('$baseUrl/institutions/debug/applications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _debugData = json.decode(response.body);
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception('Failed to load debug data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildDebugSection(String title, dynamic data, {Color? color}) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 12),
          if (data is Map)
            ...data.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${e.key}: ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: Text(
                          '${e.value}',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ))
          else if (data is List)
            ...data.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('• $item'),
                ))
          else
            Text('$data'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.instDebugTitle),
        backgroundColor: AppColors.primary,
      ),
      body: _isLoading
          ? LoadingIndicator(message: context.l10n.instDebugRunningDiagnostics)
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                             size: 64,
                             color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.instDebugError,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _runDebugCheck,
                        child: Text(context.l10n.instDebugRetry),
                      ),
                    ],
                  ),
                )
              : _debugData != null
                  ? RefreshIndicator(
                      onRefresh: _runDebugCheck,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // User Info Section
                          _buildDebugSection(
                            context.l10n.instDebugAuthInfo,
                            _debugData!['debug_info']?['user_info'],
                            color: AppColors.info,
                          ),
                          const SizedBox(height: 16),

                          // Institution User Check
                          if (_debugData!['debug_info']?['institution_user'] != null)
                            _buildDebugSection(
                              context.l10n.instDebugUserStatus,
                              _debugData!['debug_info']['institution_user'],
                              color: AppColors.primary,
                            ),
                          const SizedBox(height: 16),

                          // Applications Summary
                          CustomCard(
                            color: _debugData!['applications_found']?.isNotEmpty == true
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.warning.withValues(alpha: 0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _debugData!['applications_found']?.isNotEmpty == true
                                          ? Icons.check_circle
                                          : Icons.warning,
                                      color: _debugData!['applications_found']?.isNotEmpty == true
                                          ? AppColors.success
                                          : AppColors.warning,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Applications Status',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Total Applications: ${_debugData!['debug_info']?['applications_count'] ?? 0}',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                if (_debugData!['debug_info']?['applications_by_status'] != null)
                                  ..._debugData!['debug_info']['applications_by_status']
                                      .entries
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 2),
                                            child: Text('${e.key}: ${e.value}'),
                                          )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Error Logs
                          if (_debugData!['error_logs']?.isNotEmpty == true) ...[
                            _buildDebugSection(
                              'Issues Found',
                              _debugData!['error_logs'],
                              color: AppColors.error,
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Recommendations
                          if (_debugData!['recommendations']?.isNotEmpty == true) ...[
                            _buildDebugSection(
                              'Recommendations',
                              _debugData!['recommendations'],
                              color: AppColors.info,
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Programs Check
                          if (_debugData!['debug_info']?['programs'] != null)
                            _buildDebugSection(
                              'Programs Status',
                              _debugData!['debug_info']['programs'],
                              color: AppColors.primary,
                            ),
                          const SizedBox(height: 16),

                          // Sample Applications
                          if (_debugData!['applications_found']?.isNotEmpty == true) ...[
                            Text(
                              'Sample Applications',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            ..._debugData!['applications_found'].take(5).map((app) =>
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: CustomCard(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('ID: ${app['id']}',
                                            style: const TextStyle(fontSize: 12)),
                                        Text('Student: ${app['student_id']}'),
                                        Text('Status: ${app['status']}'),
                                        Text('Submitted: ${app['is_submitted']}'),
                                      ],
                                    ),
                                  ),
                                )),
                          ],

                          // Raw Debug Data (Collapsible)
                          const SizedBox(height: 16),
                          ExpansionTile(
                            title: const Text('Raw Debug Data'),
                            children: [
                              CustomCard(
                                child: SelectableText(
                                  const JsonEncoder.withIndent('  ')
                                      .convert(_debugData),
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text('No debug data available'),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _runDebugCheck,
        tooltip: 'Refresh Debug Data',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}