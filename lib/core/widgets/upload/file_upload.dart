import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../theme/app_colors.dart';

/// File Upload Widget - Drag and drop file upload component
class FileUpload extends StatefulWidget {
  final void Function(List<UploadedFile> files) onFilesSelected;
  final List<String>? allowedExtensions;
  final int? maxFiles;
  final int? maxSizeInMB;
  final bool allowMultiple;
  final String? hint;

  const FileUpload({
    required this.onFilesSelected,
    this.allowedExtensions,
    this.maxFiles,
    this.maxSizeInMB,
    this.allowMultiple = true,
    this.hint,
    super.key,
  });

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  final List<UploadedFile> _files = [];
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drop Zone
        _buildDropZone(),

        // File List
        if (_files.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildFileList(),
        ],
      ],
    );
  }

  Widget _buildDropZone() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isDragging = true),
      onExit: (_) => setState(() => _isDragging = false),
      child: InkWell(
        onTap: _pickFiles,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: _isDragging
                ? AppColors.primary.withValues(alpha: 0.05)
                : AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isDragging ? AppColors.primary : AppColors.border,
              width: _isDragging ? 2 : 1,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 64,
                color: _isDragging ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                widget.hint ?? 'Drag and drop files here',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _isDragging ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'or click to browse',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              if (widget.allowedExtensions != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Allowed: ${widget.allowedExtensions!.join(", ")}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              if (widget.maxSizeInMB != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Max size: ${widget.maxSizeInMB}MB per file',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected Files (${_files.length})',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: _clearAll,
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Clear All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _files.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.border,
            ),
            itemBuilder: (context, index) {
              final file = _files[index];
              return _buildFileItem(file, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFileItem(UploadedFile file, int index) {
    return ListTile(
      leading: _buildFileIcon(file.extension),
      title: Text(
        file.name,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Text(
            _formatFileSize(file.size),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          if (file.isUploading) ...[
            const SizedBox(width: 12),
            Expanded(
              child: LinearProgressIndicator(
                value: file.uploadProgress,
                backgroundColor: AppColors.textSecondary.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${(file.uploadProgress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 20),
        onPressed: () => _removeFile(index),
        tooltip: 'Remove',
      ),
    );
  }

  Widget _buildFileIcon(String extension) {
    IconData icon;
    Color color;

    switch (extension.toLowerCase()) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case 'doc':
      case 'docx':
        icon = Icons.description;
        color = Colors.blue;
        break;
      case 'xls':
      case 'xlsx':
        icon = Icons.table_chart;
        color = Colors.green;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        icon = Icons.image;
        color = Colors.purple;
        break;
      case 'zip':
      case 'rar':
        icon = Icons.folder_zip;
        color = Colors.orange;
        break;
      default:
        icon = Icons.insert_drive_file;
        color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: widget.allowMultiple,
        type: widget.allowedExtensions != null
            ? FileType.custom
            : FileType.any,
        allowedExtensions: widget.allowedExtensions,
      );

      if (result != null) {
        final newFiles = result.files.map((file) {
          return UploadedFile(
            name: file.name,
            size: file.size,
            extension: file.extension ?? '',
            bytes: file.bytes,
            path: file.path,
          );
        }).toList();

        // Validate files
        final validFiles = _validateFiles(newFiles);

        setState(() {
          if (widget.maxFiles != null) {
            _files.clear();
            _files.addAll(validFiles.take(widget.maxFiles!));
          } else {
            _files.addAll(validFiles);
          }
        });

        widget.onFilesSelected(_files);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking files: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  List<UploadedFile> _validateFiles(List<UploadedFile> files) {
    final validFiles = <UploadedFile>[];

    for (final file in files) {
      // Check file size
      if (widget.maxSizeInMB != null) {
        final maxSizeBytes = widget.maxSizeInMB! * 1024 * 1024;
        if (file.size > maxSizeBytes) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${file.name} exceeds maximum size of ${widget.maxSizeInMB}MB',
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
          continue;
        }
      }

      // Check extension
      if (widget.allowedExtensions != null) {
        if (!widget.allowedExtensions!.contains(file.extension.toLowerCase())) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${file.name} has an unsupported file type',
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
          continue;
        }
      }

      validFiles.add(file);
    }

    return validFiles;
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
    widget.onFilesSelected(_files);
  }

  void _clearAll() {
    setState(() {
      _files.clear();
    });
    widget.onFilesSelected(_files);
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}

/// Uploaded File Model
class UploadedFile {
  final String name;
  final int size;
  final String extension;
  final List<int>? bytes;
  final String? path;
  bool isUploading;
  double uploadProgress;

  UploadedFile({
    required this.name,
    required this.size,
    required this.extension,
    this.bytes,
    this.path,
    this.isUploading = false,
    this.uploadProgress = 0.0,
  });
}
