import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/settings_widgets.dart';

/// Data & Storage Settings Screen
///
/// Allows users to manage app data and storage:
/// - View storage usage breakdown
/// - Manage cache
/// - Download preferences
/// - Offline content
/// - Data usage statistics
/// - Auto-download settings
///
/// Backend Integration TODO:
/// - Fetch actual storage usage from device
/// - Clear cache functionality
/// - Manage downloaded content
/// - Track data usage statistics
/// - Sync preferences with backend

class DataStorageSettingsScreen extends StatefulWidget {
  const DataStorageSettingsScreen({super.key});

  @override
  State<DataStorageSettingsScreen> createState() =>
      _DataStorageSettingsScreenState();
}

class _DataStorageSettingsScreenState extends State<DataStorageSettingsScreen> {
  bool _autoDownloadVideos = false;
  bool _downloadOnWifiOnly = true;
  bool _autoDeleteWatched = false;
  String _videoQuality = 'auto';
  bool _offlineMode = false;

  // Mock storage data (in MB)
  final Map<String, double> _storageBreakdown = {
    'Videos': 245.3,
    'Documents': 89.7,
    'Images': 52.1,
    'Audio': 34.8,
    'Cache': 127.5,
    'Other': 15.2,
  };

  double get _totalStorage =>
      _storageBreakdown.values.fold(0.0, (sum, value) => sum + value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: const Text('Data & Storage'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Storage Usage Section
          SettingsSectionHeader(
            title: 'STORAGE USAGE',
            subtitle: 'Manage your app storage',
          ),
          SettingsCard(
            children: [
              DataUsageDisplay(
                totalBytes: _totalStorage * 1024 * 1024, // Convert MB to bytes
                breakdown: _storageBreakdown,
              ),
              const Divider(height: 1),
              SettingsTile(
                icon: Icons.cleaning_services,
                title: 'Clear Cache',
                subtitle: '${_storageBreakdown['Cache']!.toStringAsFixed(1)} MB',
                iconColor: AppColors.warning,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showClearCacheDialog();
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Download Settings Section
          SettingsSectionHeader(
            title: 'DOWNLOAD SETTINGS',
            subtitle: 'Control how content is downloaded',
          ),
          SettingsCard(
            children: [
              SettingsSwitchTile(
                icon: Icons.cloud_download,
                title: 'Auto-Download Videos',
                subtitle: 'Automatically download enrolled course videos',
                value: _autoDownloadVideos,
                onChanged: (value) {
                  setState(() {
                    _autoDownloadVideos = value;
                  });
                },
              ),
              SettingsSwitchTile(
                icon: Icons.wifi,
                title: 'Download on Wi-Fi Only',
                subtitle: 'Prevent mobile data usage for downloads',
                value: _downloadOnWifiOnly,
                iconColor: AppColors.info,
                onChanged: (value) {
                  setState(() {
                    _downloadOnWifiOnly = value;
                  });
                },
              ),
              SettingsSwitchTile(
                icon: Icons.delete_sweep,
                title: 'Auto-Delete Watched Videos',
                subtitle: 'Free up space by removing watched content',
                value: _autoDeleteWatched,
                onChanged: (value) {
                  setState(() {
                    _autoDeleteWatched = value;
                  });
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Video Quality Section
          SettingsSectionHeader(
            title: 'VIDEO QUALITY',
            subtitle: 'Choose default video quality',
          ),
          SettingsCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Quality',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...[
                      VideoQualityOption(
                        value: 'auto',
                        label: 'Auto',
                        description: 'Adjust quality based on connection',
                        dataUsage: 'Varies',
                      ),
                      VideoQualityOption(
                        value: '1080p',
                        label: '1080p HD',
                        description: 'Best quality, larger file size',
                        dataUsage: '~3 GB/hour',
                      ),
                      VideoQualityOption(
                        value: '720p',
                        label: '720p',
                        description: 'Good quality, moderate file size',
                        dataUsage: '~1.5 GB/hour',
                      ),
                      VideoQualityOption(
                        value: '480p',
                        label: '480p',
                        description: 'Standard quality, smaller file size',
                        dataUsage: '~700 MB/hour',
                      ),
                      VideoQualityOption(
                        value: '360p',
                        label: '360p',
                        description: 'Lower quality, minimal data',
                        dataUsage: '~400 MB/hour',
                      ),
                    ].map((option) {
                      final isSelected = _videoQuality == option.value;
                      return _VideoQualityTile(
                        option: option,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _videoQuality = option.value;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Offline Content Section
          SettingsSectionHeader(
            title: 'OFFLINE CONTENT',
            subtitle: 'Manage downloaded content',
          ),
          SettingsCard(
            children: [
              SettingsSwitchTile(
                icon: Icons.cloud_off,
                title: 'Offline Mode',
                subtitle: 'Use only downloaded content',
                value: _offlineMode,
                onChanged: (value) {
                  setState(() {
                    _offlineMode = value;
                  });
                },
              ),
              SettingsTile(
                icon: Icons.download,
                title: 'Manage Downloads',
                subtitle: '12 videos, 245 MB',
                onTap: () {
                  _showDownloadsDialog();
                },
              ),
              SettingsTile(
                icon: Icons.delete_forever,
                title: 'Delete All Downloads',
                subtitle: 'Free up storage space',
                iconColor: AppColors.error,
                onTap: () {
                  _showDeleteAllDownloadsDialog();
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Data Usage Statistics Section
          SettingsSectionHeader(
            title: 'DATA USAGE',
            subtitle: 'Track your data consumption',
          ),
          SettingsCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DataUsageStatCard(
                      icon: Icons.wifi,
                      label: 'Wi-Fi Usage (This Month)',
                      value: '2.4 GB',
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 12),
                    _DataUsageStatCard(
                      icon: Icons.signal_cellular_alt,
                      label: 'Mobile Data (This Month)',
                      value: '487 MB',
                      color: AppColors.warning,
                    ),
                    const SizedBox(height: 12),
                    _DataUsageStatCard(
                      icon: Icons.trending_up,
                      label: 'Total Usage (This Month)',
                      value: '2.9 GB',
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Advanced Options Section
          SettingsSectionHeader(
            title: 'ADVANCED',
          ),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.refresh,
                title: 'Sync Now',
                subtitle: 'Sync all data with server',
                onTap: () {
                  _syncData();
                },
              ),
              SettingsTile(
                icon: Icons.folder_open,
                title: 'Storage Location',
                subtitle: 'Internal Storage',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Storage location management coming soon'),
                    ),
                  );
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.tips_and_updates,
                  color: AppColors.info,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Storage Tip',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'To save mobile data, enable "Download on Wi-Fi Only" and download content when connected to Wi-Fi. Clear cache regularly to free up space.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: Text(
          'This will clear ${_storageBreakdown['Cache']!.toStringAsFixed(1)} MB of cached data. This may slow down the app temporarily while data is re-cached.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _storageBreakdown['Cache'] = 0.0;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
              // TODO: Actually clear cache
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showDownloadsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Downloaded Content'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _DownloadItem(
                title: 'Introduction to Programming',
                subtitle: '5 videos, 87 MB',
                onDelete: () {
                  // TODO: Delete download
                },
              ),
              _DownloadItem(
                title: 'Data Structures Fundamentals',
                subtitle: '4 videos, 102 MB',
                onDelete: () {
                  // TODO: Delete download
                },
              ),
              _DownloadItem(
                title: 'Web Development Basics',
                subtitle: '3 videos, 56 MB',
                onDelete: () {
                  // TODO: Delete download
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDownloadsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Downloads'),
        content: const Text(
          'Are you sure you want to delete all downloaded content? This will free up approximately 245 MB of storage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _storageBreakdown['Videos'] = 0.0;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All downloads deleted'),
                  backgroundColor: AppColors.success,
                ),
              );
              // TODO: Actually delete downloads
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _syncData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Text('Syncing data...'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );

    // TODO: Implement actual sync
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sync completed'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }
}

/// Video quality option model
class VideoQualityOption {
  final String value;
  final String label;
  final String description;
  final String dataUsage;

  const VideoQualityOption({
    required this.value,
    required this.label,
    required this.description,
    required this.dataUsage,
  });
}

/// Video quality selection tile
class _VideoQualityTile extends StatelessWidget {
  final VideoQualityOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _VideoQualityTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  Text(
                    option.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              option.dataUsage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data usage stat card
class _DataUsageStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DataUsageStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Download item widget
class _DownloadItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onDelete;

  const _DownloadItem({
    required this.title,
    required this.subtitle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(
          Icons.video_library,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        color: AppColors.error,
        onPressed: onDelete,
      ),
    );
  }
}
