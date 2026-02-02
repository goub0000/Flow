import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/models/message_model.dart';
import '../../../shared/providers/messaging_realtime_provider.dart';
import '../../../shared/widgets/message_widgets.dart' hide Message;

/// Conversation Detail Screen
///
/// Displays a single conversation with real-time message updates.
/// Uses backend API for fetching and sending messages.

class ConversationDetailScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ConversationDetailScreen({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<ConversationDetailScreen> createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends ConsumerState<ConversationDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;
  bool _isUploading = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _handleSendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    _messageController.clear();

    try {
      final notifier = ref.read(conversationRealtimeProvider(widget.conversationId).notifier);
      final message = await notifier.sendMessage(content);

      if (message != null) {
        _scrollToBottom();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.msgFailedToSendMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  /// Show attachment options (image or file)
  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: Text(context.l10n.msgPhotoFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            // Camera option - works differently on web vs mobile
            if (!kIsWeb) ...[
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text(context.l10n.msgTakePhoto),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text(context.l10n.msgTakePhoto),
                subtitle: Text(context.l10n.msgOpensCameraOnMobile),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageWithCameraFallback();
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.attach_file, color: AppColors.primary),
              title: Text(context.l10n.msgDocument),
              onTap: () {
                Navigator.pop(context);
                _pickFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Pick image with camera - for web, use file picker with image filter as fallback
  Future<void> _pickImageWithCameraFallback() async {
    try {
      // First try camera
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final extension = image.name.split('.').last.toLowerCase();
        final mimeType = _getImageMimeType(extension);
        await _uploadAndSendFile(
          bytes: bytes,
          fileName: image.name,
          mimeType: mimeType,
        );
      }
    } catch (e) {
      // On web, camera might not be available - show helpful message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.msgCameraNotAvailable),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Pick an image using image_picker
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final extension = image.name.split('.').last.toLowerCase();
        final mimeType = _getImageMimeType(extension);
        await _uploadAndSendFile(
          bytes: bytes,
          fileName: image.name,
          mimeType: mimeType,
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Failed to pick image';
        if (e.toString().contains('camera_access_denied')) {
          errorMessage = 'Camera access denied. Please enable camera permissions.';
        } else if (e.toString().contains('no_camera')) {
          errorMessage = 'No camera available on this device.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  String _getImageMimeType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/$extension';
    }
  }

  /// Pick a file using file_picker
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx', 'ppt', 'pptx', 'png', 'jpg', 'jpeg', 'gif'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          await _uploadAndSendFile(
            bytes: file.bytes!,
            fileName: file.name,
            mimeType: _getMimeType(file.extension ?? ''),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick file: $e')),
        );
      }
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'txt':
        return 'text/plain';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'gif':
        return 'image/gif';
      default:
        return 'application/octet-stream';
    }
  }

  /// Upload file and send as message
  Future<void> _uploadAndSendFile({
    required Uint8List bytes,
    required String fileName,
    String? mimeType,
  }) async {
    if (_isUploading) return;

    setState(() => _isUploading = true);

    // Show uploading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text('Uploading $fileName...'),
          ],
        ),
        duration: const Duration(seconds: 30),
      ),
    );

    try {
      final messagingService = ref.read(messagingServiceProvider);

      // Use the sendMessageWithFile method which handles upload + send
      final response = await messagingService.sendMessageWithFile(
        conversationId: widget.conversationId,
        content: fileName, // Use filename as content
        fileBytes: bytes,
        fileName: fileName,
        mimeType: mimeType,
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (response.success) {
        _scrollToBottom();
        // Refresh the conversation to show the new message
        ref.read(conversationRealtimeProvider(widget.conversationId).notifier).refresh();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send file: ${response.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Widget _buildMessageList(List<Message> messages, String currentUserId) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              context.l10n.msgNoMessagesYet,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.msgSendMessageToStart,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Group messages by date
    final groupedMessages = <DateTime, List<Message>>{};
    for (final message in messages) {
      final date = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );
      groupedMessages.putIfAbsent(date, () => []).add(message);
    }

    final sortedDates = groupedMessages.keys.toList()..sort();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dayMessages = groupedMessages[date]!;

        return Column(
          children: [
            // Date divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _formatDate(date),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
            ),
            // Messages for this date
            ...dayMessages.map((message) => _buildMessageBubble(message, currentUserId)),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) {
      return 'Today';
    } else if (date == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildMessageBubble(Message message, String currentUserId) {
    final isCurrentUser = message.senderId == currentUserId;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isCurrentUser ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
            bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white70 : Colors.grey,
                    fontSize: 11,
                  ),
                ),
                if (isCurrentUser) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isDeleted
                        ? Icons.block
                        : Icons.done_all,
                    size: 14,
                    color: Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final conversationState = ref.watch(conversationRealtimeProvider(widget.conversationId));
    final currentUser = ref.watch(currentUserProvider);
    final conversation = conversationState.conversation;
    final messages = conversationState.messages;
    final isLoading = conversationState.isLoading;
    final error = conversationState.error;

    // Scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messages.isNotEmpty) {
        _scrollToBottom();
      }
    });

    // Get other participant's name for the title
    String title = context.l10n.msgConversation;
    if (conversation != null && currentUser != null) {
      // For direct conversations, show the other person's name
      // For now, just show a generic title - we'd need to fetch user details
      title = conversation.title ?? 'Chat';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                title.isNotEmpty ? title[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    conversationState.isConnected ? context.l10n.msgOnline : context.l10n.msgConnecting,
                    style: TextStyle(
                      fontSize: 12,
                      color: conversationState.isConnected
                          ? AppColors.success
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(conversationRealtimeProvider(widget.conversationId).notifier).refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Error banner
          if (error != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red[100],
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: () {
                      ref.read(conversationRealtimeProvider(widget.conversationId).notifier).refresh();
                    },
                  ),
                ],
              ),
            ),

          // Messages list
          Expanded(
            child: isLoading && messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _buildMessageList(messages, currentUser?.id ?? ''),
          ),

          // Message input field
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: _isUploading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.attach_file),
                    onPressed: _isUploading ? null : _showAttachmentOptions,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: context.l10n.msgTypeAMessage,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      icon: _isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: _isSending ? null : _handleSendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
