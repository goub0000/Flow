// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/models/course_content_models.dart';
import 'content_editor_wrapper.dart';

/// Video platform enumeration for supported video services
enum VideoPlatform {
  youtube('youtube', 'YouTube', Icons.play_circle_filled, Colors.red),
  vimeo('vimeo', 'Vimeo', Icons.play_circle_outline, Colors.blue),
  direct('direct', 'Direct URL', Icons.link, Colors.grey),
  wistia('wistia', 'Wistia', Icons.video_library, Colors.teal),
  custom('custom', 'Custom/Other', Icons.settings_input_component, Colors.purple);

  final String value;
  final String displayName;
  final IconData icon;
  final Color color;

  const VideoPlatform(this.value, this.displayName, this.icon, this.color);

  static VideoPlatform fromString(String value) {
    return VideoPlatform.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => VideoPlatform.youtube,
    );
  }
}

/// Chapter marker model for video bookmarks
class ChapterMarker {
  final String title;
  final Duration timestamp;
  final String? description;

  ChapterMarker({
    required this.title,
    required this.timestamp,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'timestamp_seconds': timestamp.inSeconds,
        'description': description,
      };

  factory ChapterMarker.fromJson(Map<String, dynamic> json) => ChapterMarker(
        title: json['title'] as String,
        timestamp: Duration(seconds: json['timestamp_seconds'] as int),
        description: json['description'] as String?,
      );
}

/// Subtitle track model for accessibility
class SubtitleTrack {
  final String language;
  final String languageCode;
  final String? fileUrl;
  final String? rawContent;

  SubtitleTrack({
    required this.language,
    required this.languageCode,
    this.fileUrl,
    this.rawContent,
  });

  Map<String, dynamic> toJson() => {
        'language': language,
        'language_code': languageCode,
        'file_url': fileUrl,
        'raw_content': rawContent,
      };

  factory SubtitleTrack.fromJson(Map<String, dynamic> json) => SubtitleTrack(
        language: json['language'] as String,
        languageCode: json['language_code'] as String,
        fileUrl: json['file_url'] as String?,
        rawContent: json['raw_content'] as String?,
      );
}

/// A professional video content editor for creating college-grade video lessons.
/// Supports YouTube, Vimeo, direct URLs with comprehensive settings and accessibility features.
class VideoContentEditor extends StatefulWidget {
  final VideoContent? initialContent;
  final Function(VideoContentRequest) onSave;

  const VideoContentEditor({
    super.key,
    this.initialContent,
    required this.onSave,
  });

  @override
  State<VideoContentEditor> createState() => _VideoContentEditorState();
}

class _VideoContentEditorState extends State<VideoContentEditor>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Basic video settings
  late TextEditingController _urlController;
  late TextEditingController _transcriptController;
  VideoPlatform _selectedPlatform = VideoPlatform.youtube;
  String? _thumbnailUrl;
  String? _videoId;
  bool _isValidatingUrl = false;
  bool _urlValidated = false;

  // Duration settings
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  // Playback settings
  bool _allowDownload = false;
  bool _autoPlay = false;
  bool _showControls = true;
  int _startTimeSeconds = 0;
  int _endTimeSeconds = 0;
  String _quality = 'auto';

  // Accessibility
  final List<SubtitleTrack> _subtitles = [];

  // Chapters/Bookmarks
  final List<ChapterMarker> _chapters = [];

  // State tracking
  bool _hasChanges = false;
  bool _isSaving = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _urlController = TextEditingController(
      text: widget.initialContent?.videoUrl ?? '',
    );
    _transcriptController = TextEditingController(
      text: widget.initialContent?.transcript ?? '',
    );

    // Load initial content if editing
    if (widget.initialContent != null) {
      final content = widget.initialContent!;
      _selectedPlatform = VideoPlatform.fromString(content.videoPlatform);
      _thumbnailUrl = content.thumbnailUrl;
      _allowDownload = content.allowDownload;
      _autoPlay = content.autoPlay;
      _showControls = content.showControls;

      if (content.durationSeconds != null) {
        _hours = content.durationSeconds! ~/ 3600;
        _minutes = (content.durationSeconds! % 3600) ~/ 60;
        _seconds = content.durationSeconds! % 60;
      }

      // Auto-detect video ID from URL
      if (_urlController.text.isNotEmpty) {
        _detectVideoDetails(_urlController.text);
      }
    }

    // Add listeners for change tracking
    _urlController.addListener(_onContentChanged);
    _transcriptController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _urlController.dispose();
    _transcriptController.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  int get _totalDurationSeconds => (_hours * 3600) + (_minutes * 60) + _seconds;

  String get _durationDisplay {
    if (_totalDurationSeconds == 0) return 'Not set';
    final parts = <String>[];
    if (_hours > 0) parts.add('${_hours}h');
    if (_minutes > 0) parts.add('${_minutes}m');
    if (_seconds > 0) parts.add('${_seconds}s');
    return parts.join(' ');
  }

  bool get _isValid {
    return _urlController.text.isNotEmpty && _urlValidated;
  }

  List<String> _validate() {
    final errors = <String>[];

    if (_urlController.text.isEmpty) {
      errors.add('Video URL is required');
    } else if (!_isValidUrl(_urlController.text)) {
      errors.add('Please enter a valid video URL');
    }

    if (_totalDurationSeconds == 0) {
      errors.add('Video duration should be set for better user experience');
    }

    if (_startTimeSeconds > 0 && _endTimeSeconds > 0 && _startTimeSeconds >= _endTimeSeconds) {
      errors.add('Start time must be before end time');
    }

    if (_endTimeSeconds > 0 && _totalDurationSeconds > 0 && _endTimeSeconds > _totalDurationSeconds) {
      errors.add('End time cannot exceed video duration');
    }

    return errors;
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Future<void> _detectVideoDetails(String url) async {
    if (url.isEmpty) return;

    setState(() {
      _isValidatingUrl = true;
      _urlValidated = false;
    });

    // Simulate URL validation and platform detection
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Detect platform from URL
    VideoPlatform detectedPlatform = VideoPlatform.direct;
    String? extractedVideoId;

    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      detectedPlatform = VideoPlatform.youtube;
      extractedVideoId = _extractYouTubeId(url);
      if (extractedVideoId != null) {
        _thumbnailUrl = 'https://img.youtube.com/vi/$extractedVideoId/maxresdefault.jpg';
      }
    } else if (url.contains('vimeo.com')) {
      detectedPlatform = VideoPlatform.vimeo;
      extractedVideoId = _extractVimeoId(url);
    } else if (url.contains('wistia.com')) {
      detectedPlatform = VideoPlatform.wistia;
    }

    setState(() {
      _selectedPlatform = detectedPlatform;
      _videoId = extractedVideoId;
      _isValidatingUrl = false;
      _urlValidated = _isValidUrl(url);
      _hasChanges = true;
    });
  }

  String? _extractYouTubeId(String url) {
    // Handle various YouTube URL formats
    final regexPatterns = [
      RegExp(r'(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&\n?#]+)'),
      RegExp(r'youtube\.com\/embed\/([^&\n?#]+)'),
      RegExp(r'youtube\.com\/v\/([^&\n?#]+)'),
    ];

    for (final pattern in regexPatterns) {
      final match = pattern.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }
    return null;
  }

  String? _extractVimeoId(String url) {
    final pattern = RegExp(r'vimeo\.com\/(?:video\/)?(\d+)');
    final match = pattern.firstMatch(url);
    return match?.group(1);
  }

  @override
  Widget build(BuildContext context) {
    return ContentEditorWrapper(
      title: 'Video Content Editor',
      subtitle: 'Create engaging video lessons with rich features',
      icon: Icons.video_library,
      themeColor: Colors.red,
      editorContent: _buildEditorContent(),
      previewContent: _buildPreviewContent(),
      onSave: _saveContent,
      onCancel: () => Navigator.pop(context),
      hasUnsavedChanges: () => _hasChanges,
      validate: _validate,
      isValid: _isValid,
      isSaving: _isSaving,
      saveButtonLabel: 'Save Video Content',
      summaryWidget: _buildSummaryWidget(),
    );
  }

  Widget _buildSummaryWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isValid ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isValid ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isValid ? Icons.check_circle : Icons.warning,
            size: 20,
            color: _isValid ? Colors.green.shade700 : Colors.orange.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                _buildSummaryChip(
                  Icons.play_circle,
                  _selectedPlatform.displayName,
                  _selectedPlatform.color,
                ),
                const SizedBox(width: 12),
                _buildSummaryChip(
                  Icons.timer,
                  _durationDisplay,
                  Colors.blue,
                ),
                if (_chapters.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  _buildSummaryChip(
                    Icons.bookmark,
                    '${_chapters.length} chapters',
                    Colors.purple,
                  ),
                ],
                if (_subtitles.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  _buildSummaryChip(
                    Icons.subtitles,
                    '${_subtitles.length} languages',
                    Colors.teal,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorContent() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.video_settings), text: 'Video Source'),
              Tab(icon: Icon(Icons.settings), text: 'Playback'),
              Tab(icon: Icon(Icons.accessibility), text: 'Accessibility'),
              Tab(icon: Icon(Icons.bookmark), text: 'Chapters'),
            ],
            labelColor: Colors.red.shade700,
            indicatorColor: Colors.red.shade700,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVideoSourceTab(),
                _buildPlaybackSettingsTab(),
                _buildAccessibilityTab(),
                _buildChaptersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSourceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video URL Input
          EditorSection(
            title: 'Video URL',
            icon: Icons.link,
            iconColor: Colors.blue,
            subtitle: 'Enter the URL of your video',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: 'Video URL *',
                    hintText: 'https://www.youtube.com/watch?v=...',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(
                      _selectedPlatform.icon,
                      color: _selectedPlatform.color,
                    ),
                    suffixIcon: _isValidatingUrl
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : _urlValidated
                            ? Icon(Icons.check_circle, color: Colors.green.shade700)
                            : null,
                    helperText: 'Supports YouTube, Vimeo, Wistia, or direct video links',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a video URL';
                    }
                    if (!_isValidUrl(value)) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _detectVideoDetails(value);
                  },
                ),
                const SizedBox(height: 16),

                // Platform selector
                Row(
                  children: [
                    const Text(
                      'Platform:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 16),
                    ...VideoPlatform.values.take(4).map((platform) {
                      final isSelected = _selectedPlatform == platform;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          selected: isSelected,
                          label: Text(platform.displayName),
                          avatar: Icon(
                            platform.icon,
                            size: 18,
                            color: isSelected ? platform.color : Colors.grey,
                          ),
                          selectedColor: platform.color.withValues(alpha:0.2),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPlatform = platform;
                                _hasChanges = true;
                              });
                            }
                          },
                        ),
                      );
                    }),
                  ],
                ),

                // Video ID display
                if (_videoId != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Video ID detected: $_videoId',
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Thumbnail Preview
          EditorSection(
            title: 'Thumbnail Preview',
            icon: Icons.image,
            iconColor: Colors.orange,
            subtitle: 'Preview how the video will appear',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_thumbnailUrl != null) ...[
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                      image: DecorationImage(
                        image: NetworkImage(_thumbnailUrl!),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {},
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha:0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha:0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _durationDisplay,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          'Thumbnail will appear here',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enter a valid video URL to auto-detect',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _thumbnailUrl,
                  decoration: const InputDecoration(
                    labelText: 'Custom Thumbnail URL (Optional)',
                    hintText: 'https://example.com/thumbnail.jpg',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image),
                    helperText: 'Override auto-detected thumbnail',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _thumbnailUrl = value.isEmpty ? null : value;
                      _hasChanges = true;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Duration Input
          EditorSection(
            title: 'Video Duration',
            icon: Icons.timer,
            iconColor: Colors.blue,
            subtitle: 'Set the video length for progress tracking',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildDurationInput('Hours', _hours, 23, (value) {
                      setState(() {
                        _hours = value;
                        _hasChanges = true;
                      });
                    }),
                    const SizedBox(width: 8),
                    const Text(':', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    _buildDurationInput('Minutes', _minutes, 59, (value) {
                      setState(() {
                        _minutes = value;
                        _hasChanges = true;
                      });
                    }),
                    const SizedBox(width: 8),
                    const Text(':', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    _buildDurationInput('Seconds', _seconds, 59, (value) {
                      setState(() {
                        _seconds = value;
                        _hasChanges = true;
                      });
                    }),
                    const SizedBox(width: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Total: $_durationDisplay',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Tip: Duration helps students estimate time needed and enables progress tracking.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationInput(
    String label,
    int value,
    int max,
    ValueChanged<int> onChanged,
  ) {
    return SizedBox(
      width: 80,
      child: TextFormField(
        initialValue: value.toString().padLeft(2, '0'),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        onChanged: (text) {
          final parsed = int.tryParse(text) ?? 0;
          if (parsed >= 0 && parsed <= max) {
            onChanged(parsed);
          }
        },
      ),
    );
  }

  Widget _buildPlaybackSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Player Settings
          EditorSection(
            title: 'Player Settings',
            icon: Icons.play_circle_outline,
            iconColor: Colors.green,
            subtitle: 'Configure video player behavior',
            child: Column(
              children: [
                LabeledSwitch(
                  title: 'Auto-play',
                  subtitle: 'Start playing video automatically when loaded',
                  icon: Icons.play_arrow,
                  iconColor: Colors.green,
                  value: _autoPlay,
                  onChanged: (value) {
                    setState(() {
                      _autoPlay = value;
                      _hasChanges = true;
                    });
                  },
                ),
                LabeledSwitch(
                  title: 'Show Controls',
                  subtitle: 'Display play/pause, volume, and progress controls',
                  icon: Icons.tune,
                  iconColor: Colors.blue,
                  value: _showControls,
                  onChanged: (value) {
                    setState(() {
                      _showControls = value;
                      _hasChanges = true;
                    });
                  },
                ),
                LabeledSwitch(
                  title: 'Allow Download',
                  subtitle: 'Let students download this video for offline viewing',
                  icon: Icons.download,
                  iconColor: Colors.orange,
                  value: _allowDownload,
                  onChanged: (value) {
                    setState(() {
                      _allowDownload = value;
                      _hasChanges = true;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Playback Range
          EditorSection(
            title: 'Playback Range',
            icon: Icons.content_cut,
            iconColor: Colors.purple,
            subtitle: 'Set start and end points for the video',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _formatSecondsToTime(_startTimeSeconds),
                        decoration: const InputDecoration(
                          labelText: 'Start Time',
                          hintText: '00:00:00',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.skip_next),
                          helperText: 'Skip intro (HH:MM:SS)',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _startTimeSeconds = _parseTimeToSeconds(value);
                            _hasChanges = true;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: _endTimeSeconds > 0
                            ? _formatSecondsToTime(_endTimeSeconds)
                            : '',
                        decoration: const InputDecoration(
                          labelText: 'End Time',
                          hintText: '00:00:00',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.skip_previous),
                          helperText: 'Cut outro (leave empty for full)',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _endTimeSeconds = _parseTimeToSeconds(value);
                            _hasChanges = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 20, color: Colors.purple.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Students will see the video from $_formatSecondsToTime(_startTimeSeconds) '
                          '${_endTimeSeconds > 0 ? 'to ${_formatSecondsToTime(_endTimeSeconds)}' : 'to end'}',
                          style: TextStyle(color: Colors.purple.shade700, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Quality Settings
          EditorSection(
            title: 'Quality Settings',
            icon: Icons.high_quality,
            iconColor: Colors.teal,
            subtitle: 'Set default video quality',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _quality,
                  decoration: const InputDecoration(
                    labelText: 'Default Quality',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.hd),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'auto', child: Text('Auto (Recommended)')),
                    DropdownMenuItem(value: '1080p', child: Text('1080p (Full HD)')),
                    DropdownMenuItem(value: '720p', child: Text('720p (HD)')),
                    DropdownMenuItem(value: '480p', child: Text('480p (SD)')),
                    DropdownMenuItem(value: '360p', child: Text('360p (Low)')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _quality = value ?? 'auto';
                      _hasChanges = true;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Auto quality adjusts based on student\'s internet connection.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Transcript Editor
          EditorSection(
            title: 'Video Transcript',
            icon: Icons.description,
            iconColor: Colors.blue,
            subtitle: 'Add a transcript for accessibility and searchability',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _transcriptController,
                  decoration: const InputDecoration(
                    labelText: 'Transcript',
                    hintText: 'Enter or paste the video transcript...\n\n[00:00] Introduction\n[00:30] Main topic begins...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 12,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement file upload
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('File upload coming soon')),
                        );
                      },
                      icon: const Icon(Icons.upload_file, size: 18),
                      label: const Text('Upload .txt/.srt'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement auto-transcription
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Auto-transcription coming soon')),
                        );
                      },
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      label: const Text('Auto-Transcribe'),
                    ),
                    const Spacer(),
                    if (_transcriptController.text.isNotEmpty)
                      Text(
                        '${_transcriptController.text.split(' ').length} words',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 20, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tip: Use timestamps like [00:00] to help students navigate. '
                          'Transcripts also improve search and accessibility.',
                          style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Subtitles/Captions
          EditorSection(
            title: 'Subtitles & Captions',
            icon: Icons.subtitles,
            iconColor: Colors.teal,
            subtitle: 'Add subtitles in multiple languages',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_subtitles.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.subtitles_off, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'No subtitles added yet',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add subtitles to make your video accessible to more students',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                else
                  ...List.generate(_subtitles.length, (index) {
                    final subtitle = _subtitles[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.shade100,
                          child: Text(
                            subtitle.languageCode.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                          ),
                        ),
                        title: Text(subtitle.language),
                        subtitle: Text(
                          subtitle.fileUrl ?? 'Manual entry',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red.shade400),
                          onPressed: () {
                            setState(() {
                              _subtitles.removeAt(index);
                              _hasChanges = true;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _showAddSubtitleDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Subtitle Track'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChaptersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          EditorSection(
            title: 'Chapter Markers',
            icon: Icons.bookmark,
            iconColor: Colors.purple,
            subtitle: 'Add bookmarks for easy navigation',
            trailing: Text(
              '${_chapters.length} chapters',
              style: TextStyle(
                color: Colors.purple.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_chapters.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.bookmark_border, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'No chapters added yet',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Chapters help students navigate to specific sections',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                else
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _chapters.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = _chapters.removeAt(oldIndex);
                        _chapters.insert(newIndex, item);
                        _hasChanges = true;
                      });
                    },
                    itemBuilder: (context, index) {
                      final chapter = _chapters[index];
                      return Card(
                        key: ValueKey(chapter),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _formatDuration(chapter.timestamp),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.purple.shade700,
                              ),
                            ),
                          ),
                          title: Text(chapter.title),
                          subtitle: chapter.description != null
                              ? Text(
                                  chapter.description!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : null,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => _showEditChapterDialog(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, size: 20, color: Colors.red.shade400),
                                onPressed: () {
                                  setState(() {
                                    _chapters.removeAt(index);
                                    _hasChanges = true;
                                  });
                                },
                              ),
                              const Icon(Icons.drag_handle),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _showAddChapterDialog,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Chapter'),
                    ),
                    const SizedBox(width: 12),
                    if (_chapters.isNotEmpty)
                      OutlinedButton.icon(
                        onPressed: () {
                          // Sort chapters by timestamp
                          setState(() {
                            _chapters.sort((a, b) =>
                                a.timestamp.compareTo(b.timestamp));
                            _hasChanges = true;
                          });
                        },
                        icon: const Icon(Icons.sort, size: 18),
                        label: const Text('Sort by Time'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Video Player Preview
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            image: _thumbnailUrl != null
                ? DecorationImage(
                    image: NetworkImage(_thumbnailUrl!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha:0.3),
                      BlendMode.darken,
                    ),
                  )
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha:0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
              if (_showControls)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha:0.7),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Progress bar
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha:0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              '0:00 / $_durationDisplay',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            const Spacer(),
                            const Icon(Icons.volume_up, color: Colors.white, size: 20),
                            const SizedBox(width: 16),
                            const Icon(Icons.settings, color: Colors.white, size: 20),
                            const SizedBox(width: 16),
                            const Icon(Icons.fullscreen, color: Colors.white, size: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha:0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _selectedPlatform.displayName,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Video Info
        Text(
          'Video Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildPreviewInfoRow(Icons.timer, 'Duration', _durationDisplay),
        _buildPreviewInfoRow(Icons.play_circle, 'Platform', _selectedPlatform.displayName),
        if (_autoPlay)
          _buildPreviewInfoRow(Icons.play_arrow, 'Auto-play', 'Enabled'),
        if (_allowDownload)
          _buildPreviewInfoRow(Icons.download, 'Download', 'Allowed'),

        if (_chapters.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Chapters',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_chapters.length, (index) {
            final chapter = _chapters[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _formatDuration(chapter.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.title,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (chapter.description != null)
                          Text(
                            chapter.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],

        if (_transcriptController.text.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Transcript',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _transcriptController.text,
              style: const TextStyle(height: 1.6),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPreviewInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatSecondsToTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  int _parseTimeToSeconds(String time) {
    final parts = time.split(':');
    if (parts.isEmpty) return 0;

    try {
      if (parts.length == 3) {
        return (int.parse(parts[0]) * 3600) +
            (int.parse(parts[1]) * 60) +
            int.parse(parts[2]);
      } else if (parts.length == 2) {
        return (int.parse(parts[0]) * 60) + int.parse(parts[1]);
      } else {
        return int.parse(parts[0]);
      }
    } catch (_) {
      return 0;
    }
  }

  void _showAddSubtitleDialog() {
    final languageController = TextEditingController();
    final codeController = TextEditingController();
    String? fileUrl;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.subtitles, color: Colors.teal),
            SizedBox(width: 12),
            Text('Add Subtitle Track'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<Map<String, String>>(
              decoration: const InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: {'name': 'English', 'code': 'en'},
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: {'name': 'Spanish', 'code': 'es'},
                  child: Text('Spanish'),
                ),
                DropdownMenuItem(
                  value: {'name': 'French', 'code': 'fr'},
                  child: Text('French'),
                ),
                DropdownMenuItem(
                  value: {'name': 'German', 'code': 'de'},
                  child: Text('German'),
                ),
                DropdownMenuItem(
                  value: {'name': 'Chinese', 'code': 'zh'},
                  child: Text('Chinese'),
                ),
                DropdownMenuItem(
                  value: {'name': 'Japanese', 'code': 'ja'},
                  child: Text('Japanese'),
                ),
                DropdownMenuItem(
                  value: {'name': 'Portuguese', 'code': 'pt'},
                  child: Text('Portuguese'),
                ),
                DropdownMenuItem(
                  value: {'name': 'Arabic', 'code': 'ar'},
                  child: Text('Arabic'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  languageController.text = value['name']!;
                  codeController.text = value['code']!;
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Subtitle File URL (Optional)',
                hintText: 'https://example.com/subtitles.srt',
                border: OutlineInputBorder(),
                helperText: 'Supports .srt and .vtt formats',
              ),
              onChanged: (value) => fileUrl = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (languageController.text.isNotEmpty &&
                  codeController.text.isNotEmpty) {
                setState(() {
                  _subtitles.add(SubtitleTrack(
                    language: languageController.text,
                    languageCode: codeController.text,
                    fileUrl: fileUrl?.isEmpty == true ? null : fileUrl,
                  ));
                  _hasChanges = true;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddChapterDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final timestampController = TextEditingController(text: '00:00:00');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.bookmark_add, color: Colors.purple),
            SizedBox(width: 12),
            Text('Add Chapter'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Chapter Title *',
                hintText: 'e.g., Introduction',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: timestampController,
              decoration: const InputDecoration(
                labelText: 'Timestamp *',
                hintText: 'HH:MM:SS',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Brief description of this chapter',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final seconds = _parseTimeToSeconds(timestampController.text);
                setState(() {
                  _chapters.add(ChapterMarker(
                    title: titleController.text,
                    timestamp: Duration(seconds: seconds),
                    description: descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text,
                  ));
                  _hasChanges = true;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditChapterDialog(int index) {
    final chapter = _chapters[index];
    final titleController = TextEditingController(text: chapter.title);
    final descriptionController =
        TextEditingController(text: chapter.description ?? '');
    final timestampController =
        TextEditingController(text: _formatDuration(chapter.timestamp));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.edit, color: Colors.purple),
            SizedBox(width: 12),
            Text('Edit Chapter'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Chapter Title *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: timestampController,
              decoration: const InputDecoration(
                labelText: 'Timestamp *',
                hintText: 'HH:MM:SS',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final seconds = _parseTimeToSeconds(timestampController.text);
                setState(() {
                  _chapters[index] = ChapterMarker(
                    title: titleController.text,
                    timestamp: Duration(seconds: seconds),
                    description: descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text,
                  );
                  _hasChanges = true;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _saveContent() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);

      final request = VideoContentRequest(
        videoUrl: _urlController.text,
        videoPlatform: _selectedPlatform.value,
        thumbnailUrl: _thumbnailUrl,
        durationSeconds: _totalDurationSeconds > 0 ? _totalDurationSeconds : null,
        transcript: _transcriptController.text.isEmpty
            ? null
            : _transcriptController.text,
        allowDownload: _allowDownload,
        autoPlay: _autoPlay,
        showControls: _showControls,
      );

      widget.onSave(request);
      Navigator.pop(context);
    }
  }
}
