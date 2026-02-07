import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

/// Video Learning & Media Player Widgets Library
///
/// Comprehensive widget collection for video learning:
/// - Video models and types
/// - Player controls and overlays
/// - Video cards and lists
/// - Playlist management
/// - Progress tracking
///
/// Backend Integration TODO:
/// - Integrate video_player package
/// - Stream video content
/// - Track watch progress
/// - Save playback position
/// - Download for offline viewing

// ============================================================================
// MODELS
// ============================================================================

/// Video Quality Enum
enum VideoQuality {
  auto,
  low,
  medium,
  high,
  hd;

  String get displayName {
    switch (this) {
      case VideoQuality.auto:
        return 'Auto';
      case VideoQuality.low:
        return '360p';
      case VideoQuality.medium:
        return '480p';
      case VideoQuality.high:
        return '720p';
      case VideoQuality.hd:
        return '1080p';
    }
  }
}

/// Playback Speed Enum
enum PlaybackSpeed {
  slow,
  normal,
  fast,
  faster,
  fastest;

  double get value {
    switch (this) {
      case PlaybackSpeed.slow:
        return 0.5;
      case PlaybackSpeed.normal:
        return 1.0;
      case PlaybackSpeed.fast:
        return 1.25;
      case PlaybackSpeed.faster:
        return 1.5;
      case PlaybackSpeed.fastest:
        return 2.0;
    }
  }

  String get displayName {
    switch (this) {
      case PlaybackSpeed.slow:
        return '0.5x';
      case PlaybackSpeed.normal:
        return '1.0x';
      case PlaybackSpeed.fast:
        return '1.25x';
      case PlaybackSpeed.faster:
        return '1.5x';
      case PlaybackSpeed.fastest:
        return '2.0x';
    }
  }
}

/// Video Model
class VideoModel {
  final String id;
  final String title;
  final String? description;
  final String thumbnailUrl;
  final String videoUrl;
  final Duration duration;
  final String? courseId;
  final String? courseName;
  final String? lessonId;
  final String? instructor;
  final DateTime uploadedAt;
  final int viewCount;
  final int likeCount;
  final bool isLiked;
  final bool isDownloaded;
  final Duration? watchProgress;
  final List<String> tags;

  VideoModel({
    required this.id,
    required this.title,
    this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    this.courseId,
    this.courseName,
    this.lessonId,
    this.instructor,
    required this.uploadedAt,
    this.viewCount = 0,
    this.likeCount = 0,
    this.isLiked = false,
    this.isDownloaded = false,
    this.watchProgress,
    this.tags = const [],
  });

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  double get progressPercentage {
    if (watchProgress == null) return 0.0;
    return watchProgress!.inSeconds / duration.inSeconds;
  }

  bool get isCompleted => progressPercentage >= 0.95;

  bool get isInProgress =>
      watchProgress != null && !isCompleted && progressPercentage > 0.05;

  VideoModel copyWith({
    String? title,
    String? description,
    bool? isLiked,
    bool? isDownloaded,
    Duration? watchProgress,
    int? viewCount,
    int? likeCount,
  }) {
    return VideoModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl,
      videoUrl: videoUrl,
      duration: duration,
      courseId: courseId,
      courseName: courseName,
      lessonId: lessonId,
      instructor: instructor,
      uploadedAt: uploadedAt,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      watchProgress: watchProgress ?? this.watchProgress,
      tags: tags,
    );
  }
}

/// Playlist Model
class PlaylistModel {
  final String id;
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final List<VideoModel> videos;
  final DateTime createdAt;
  final bool isPublic;

  PlaylistModel({
    required this.id,
    required this.title,
    this.description,
    this.thumbnailUrl,
    required this.videos,
    required this.createdAt,
    this.isPublic = false,
  });

  Duration get totalDuration {
    return videos.fold(
      Duration.zero,
      (sum, video) => sum + video.duration,
    );
  }

  int get completedVideos {
    return videos.where((v) => v.isCompleted).length;
  }

  double get completionPercentage {
    if (videos.isEmpty) return 0.0;
    return completedVideos / videos.length;
  }
}

// ============================================================================
// WIDGETS
// ============================================================================

/// Video Card Widget
class VideoCard extends StatelessWidget {
  final VideoModel video;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onDownload;
  final VoidCallback? onMore;
  final bool showProgress;

  const VideoCard({
    super.key,
    required this.video,
    this.onTap,
    this.onLike,
    this.onDownload,
    this.onMore,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.border,
                          child: const Icon(
                            Icons.play_circle_outline,
                            size: 64,
                            color: Colors.white54,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Duration Badge
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      video.formattedDuration,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Status Badge
                if (video.isCompleted)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.swVideoCompleted,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (video.isInProgress)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_circle,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.swVideoInProgress,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Download Badge
                if (video.isDownloaded)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.info,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.download_done,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),

                // Progress Bar
                if (showProgress && video.isInProgress)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: video.progressPercentage,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      minHeight: 3,
                    ),
                  ),
              ],
            ),

            // Video Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Metadata
                  Row(
                    children: [
                      if (video.instructor != null) ...[
                        Expanded(
                          child: Text(
                            video.instructor!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatViews(video.viewCount, context),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.thumb_up,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${video.likeCount}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  // Actions
                  if (onLike != null || onDownload != null || onMore != null) ...[
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (onLike != null)
                          Expanded(
                            child: TextButton.icon(
                              onPressed: onLike,
                              icon: Icon(
                                video.isLiked
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_outlined,
                                size: 18,
                              ),
                              label: Text(context.l10n.swVideoLike),
                            ),
                          ),
                        if (onDownload != null)
                          Expanded(
                            child: TextButton.icon(
                              onPressed: onDownload,
                              icon: Icon(
                                video.isDownloaded
                                    ? Icons.download_done
                                    : Icons.download,
                                size: 18,
                              ),
                              label: Text(
                                video.isDownloaded ? context.l10n.swVideoDownloaded : context.l10n.swVideoDownload,
                              ),
                            ),
                          ),
                        if (onMore != null)
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: onMore,
                            iconSize: 20,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatViews(int views, BuildContext context) {
    if (views >= 1000000) {
      return context.l10n.swVideoViewsMillions((views / 1000000).toStringAsFixed(1));
    } else if (views >= 1000) {
      return context.l10n.swVideoViewsThousands((views / 1000).toStringAsFixed(1));
    }
    return context.l10n.swVideoViewsCount(views.toString());
  }
}

/// Compact Video List Item
class VideoListItem extends StatelessWidget {
  final VideoModel video;
  final VoidCallback? onTap;
  final bool showProgress;

  const VideoListItem({
    super.key,
    required this.video,
    this.onTap,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.border,
                          child: const Icon(
                            Icons.play_circle_outline,
                            color: Colors.white54,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      video.formattedDuration,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (video.instructor != null)
                    Text(
                      video.instructor!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (video.isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 10,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                context.l10n.swVideoCompleted,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (showProgress && video.isInProgress)
                        Text(
                          context.l10n.swVideoPercentWatched((video.progressPercentage * 100).toInt().toString()),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Playlist Card Widget
class PlaylistCard extends StatelessWidget {
  final PlaylistModel playlist;
  final VoidCallback? onTap;

  const PlaylistCard({
    super.key,
    required this.playlist,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with video count
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: playlist.thumbnailUrl != null
                        ? Image.network(
                            playlist.thumbnailUrl!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.playlist_play,
                            size: 64,
                            color: Colors.white54,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.playlist_play,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${playlist.videos.length}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Playlist Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (playlist.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      playlist.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),

                  // Progress
                  if (playlist.completionPercentage > 0) ...[
                    LinearProgressIndicator(
                      value: playlist.completionPercentage,
                      backgroundColor: AppColors.border,
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Stats
                  Row(
                    children: [
                      Text(
                        context.l10n.swVideoPlaylistCompleted(playlist.completedVideos.toString(), playlist.videos.length.toString()),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDuration(playlist.totalDuration),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

/// Empty Videos State
class EmptyVideosState extends StatelessWidget {
  final String? message;
  final String? subtitle;
  final VoidCallback? onAction;

  const EmptyVideosState({
    super.key,
    this.message,
    this.subtitle,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              message ?? context.l10n.swVideoNoVideos,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.explore),
                label: Text(context.l10n.swVideoBrowseVideos),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
