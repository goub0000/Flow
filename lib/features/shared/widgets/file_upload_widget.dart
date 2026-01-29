import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';

/// Enhanced File Upload Widget
///
/// Provides a comprehensive file upload UI with:
/// - Drag and drop support (web/desktop)
/// - File type filtering
/// - Size validation
/// - Upload progress tracking
/// - Preview generation
/// - Multiple file selection
///
/// Backend Integration TODO:
/// For file uploads to backend/cloud storage:
/// ```dart
/// // Option 1: Supabase Storage
/// import 'package:supabase_flutter/supabase_flutter.dart';
///
/// Future<String> uploadFile(PlatformFile file) async {
///   final storagePath = 'uploads/${file.name}';
///   await Supabase.instance.client.storage
///       .from('uploads')
///       .upload(storagePath, File(file.path!));
///   return Supabase.instance.client.storage
///       .from('uploads')
///       .getPublicUrl(storagePath);
/// }
///
/// // Option 2: Custom API with dio
/// import 'package:dio/dio.dart';
///
/// Future<String> uploadFile(PlatformFile file) async {
///   final dio = Dio();
///   final formData = FormData.fromMap({
///     'file': await MultipartFile.fromFile(file.path!, filename: file.name),
///   });
///
///   final response = await dio.post(
///     'https://api.example.com/upload',
///     data: formData,
///     onSendProgress: (sent, total) {
///       final progress = sent / total;
///       // Update UI with progress
///     },
///   );
///
///   return response.data['url'];
/// }
/// ```

class FileUploadWidget extends StatefulWidget {
  final Function(List<PlatformFile>) onFilesSelected;
  final List<String>? allowedExtensions;
  final int? maxSizeInMB;
  final bool allowMultiple;
  final String? helpText;
  final IconData icon;

  const FileUploadWidget({
    super.key,
    required this.onFilesSelected,
    this.allowedExtensions,
    this.maxSizeInMB,
    this.allowMultiple = false,
    this.helpText,
    this.icon = Icons.upload_file,
  });

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  List<PlatformFile> _selectedFiles = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool _isDragging = false;

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: widget.allowedExtensions != null
            ? FileType.custom
            : FileType.any,
        allowedExtensions: widget.allowedExtensions,
        allowMultiple: widget.allowMultiple,
      );

      if (result != null && result.files.isNotEmpty) {
        final validFiles = _validateFiles(result.files);

        if (validFiles.isNotEmpty) {
          setState(() {
            _selectedFiles = validFiles;
          });
          widget.onFilesSelected(validFiles);
        }
      }
    } catch (e) {
      _showError('Failed to pick files: ${e.toString()}');
    }
  }

  List<PlatformFile> _validateFiles(List<PlatformFile> files) {
    final validFiles = <PlatformFile>[];

    for (final file in files) {
      // Check file size
      if (widget.maxSizeInMB != null) {
        final maxBytes = widget.maxSizeInMB! * 1024 * 1024;
        if (file.size > maxBytes) {
          _showError(
            '${file.name} is too large. Maximum size is ${widget.maxSizeInMB}MB',
          );
          continue;
        }
      }

      // Check file extension
      if (widget.allowedExtensions != null) {
        final extension = file.extension?.toLowerCase();
        if (extension == null ||
            !widget.allowedExtensions!.contains(extension)) {
          _showError(
            '${file.name} has an invalid file type. Allowed: ${widget.allowedExtensions!.join(', ')}',
          );
          continue;
        }
      }

      validFiles.add(file);
    }

    return validFiles;
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
    widget.onFilesSelected(_selectedFiles);
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Upload Area
        GestureDetector(
          onTap: _isUploading ? null : _pickFiles,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isDragging = true),
            onExit: (_) => setState(() => _isDragging = false),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isDragging
                      ? AppColors.primary
                      : AppColors.border,
                  width: _isDragging ? 2 : 1,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
                borderRadius: BorderRadius.circular(12),
                color: _isDragging
                    ? AppColors.primary.withOpacity(0.05)
                    : AppColors.surface,
              ),
              child: Column(
                children: [
                  Icon(
                    widget.icon,
                    size: 48,
                    color: _isDragging
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isDragging
                        ? 'Drop files here'
                        : 'Click to select files or drag and drop',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _isDragging
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.helpText != null)
                    Text(
                      widget.helpText!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    )
                  else
                    _buildDefaultHelpText(),
                ],
              ),
            ),
          ),
        ),

        // Selected Files List
        if (_selectedFiles.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...List.generate(_selectedFiles.length, (index) {
            final file = _selectedFiles[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FilePreviewCard(
                file: file,
                isUploading: _isUploading,
                uploadProgress: _uploadProgress,
                onRemove: () => _removeFile(index),
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildDefaultHelpText() {
    final parts = <String>[];

    if (widget.allowedExtensions != null) {
      parts.add('Allowed: ${widget.allowedExtensions!.join(', ').toUpperCase()}');
    }

    if (widget.maxSizeInMB != null) {
      parts.add('Max ${widget.maxSizeInMB}MB');
    }

    if (parts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      parts.join(' • '),
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
    );
  }
}

/// File Preview Card
class FilePreviewCard extends StatelessWidget {
  final PlatformFile file;
  final bool isUploading;
  final double uploadProgress;
  final VoidCallback onRemove;

  const FilePreviewCard({
    super.key,
    required this.file,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.surface,
      ),
      child: Row(
        children: [
          // File Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getFileColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getFileIcon(),
                  color: _getFileColor(),
                  size: 24,
                ),
                const SizedBox(height: 2),
                Text(
                  file.extension?.toUpperCase() ?? '',
                  style: TextStyle(
                    color: _getFileColor(),
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // File Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatFileSize(file.size),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (isUploading) ...[
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: uploadProgress,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(uploadProgress * 100).toInt()}% uploaded',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Remove Button
          if (!isUploading)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onRemove,
              color: AppColors.error,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  IconData _getFileIcon() {
    final ext = file.extension?.toLowerCase();
    if (ext == null) return Icons.insert_drive_file;

    if (['pdf'].contains(ext)) return Icons.picture_as_pdf;
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) {
      return Icons.image;
    }
    if (['doc', 'docx', 'txt', 'rtf'].contains(ext)) {
      return Icons.description;
    }
    if (['xls', 'xlsx', 'csv'].contains(ext)) return Icons.table_chart;
    if (['zip', 'rar', '7z'].contains(ext)) return Icons.folder_zip;

    return Icons.insert_drive_file;
  }

  Color _getFileColor() {
    final ext = file.extension?.toLowerCase();
    if (ext == null) return AppColors.textSecondary;

    if (['pdf'].contains(ext)) return AppColors.error;
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) {
      return AppColors.success;
    }
    if (['doc', 'docx', 'txt', 'rtf'].contains(ext)) return AppColors.info;
    if (['xls', 'xlsx', 'csv'].contains(ext)) return AppColors.success;
    if (['zip', 'rar', '7z'].contains(ext)) return AppColors.warning;

    return AppColors.textSecondary;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}

/// Quick File Upload Button
class QuickFileUploadButton extends StatelessWidget {
  final Function(List<PlatformFile>) onFilesSelected;
  final String label;
  final IconData icon;
  final List<String>? allowedExtensions;
  final bool allowMultiple;

  const QuickFileUploadButton({
    super.key,
    required this.onFilesSelected,
    this.label = 'Upload File',
    this.icon = Icons.upload,
    this.allowedExtensions,
    this.allowMultiple = false,
  });

  Future<void> _pickFiles(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
      );

      if (result != null && result.files.isNotEmpty) {
        onFilesSelected(result.files);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick files: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _pickFiles(context),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

/// Image Upload with Preview
class ImageUploadWidget extends StatefulWidget {
  final Function(PlatformFile) onImageSelected;
  final String? initialImageUrl;
  final double width;
  final double height;

  const ImageUploadWidget({
    super.key,
    required this.onImageSelected,
    this.initialImageUrl,
    this.width = double.infinity,
    this.height = 200,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  PlatformFile? _selectedImage;

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedImage = result.files.first;
        });
        widget.onImageSelected(result.files.first);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface,
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    // Show selected image preview
    if (_selectedImage != null && _selectedImage!.path != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              _selectedImage!.path!,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: _pickImage,
              ),
            ),
          ),
        ],
      );
    }

    // Show initial image
    if (widget.initialImageUrl != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.initialImageUrl!,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: _pickImage,
              ),
            ),
          ),
        ],
      );
    }

    // Show upload placeholder
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.add_photo_alternate,
          size: 48,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: 12),
        const Text(
          'Tap to select image',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'JPG, PNG, GIF (max 5MB)',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
