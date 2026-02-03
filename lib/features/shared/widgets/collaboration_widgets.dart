import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

/// Whiteboard & Collaboration Widgets Library
///
/// Comprehensive widget collection for collaboration:
/// - Group models and types
/// - Chat message widgets
/// - Study group cards
/// - Collaboration tools
/// - Member management
///
/// Backend Integration TODO:
/// - Real-time messaging with WebSocket
/// - Video/audio calls integration
/// - File sharing and collaboration
/// - Whiteboard sync across devices
/// - Group notifications

// ============================================================================
// MODELS
// ============================================================================

/// Group Member Role
enum MemberRole {
  owner,
  moderator,
  member;

  String get displayName {
    switch (this) {
      case MemberRole.owner:
        return 'Owner';
      case MemberRole.moderator:
        return 'Moderator';
      case MemberRole.member:
        return 'Member';
    }
  }

  Color get color {
    switch (this) {
      case MemberRole.owner:
        return AppColors.error;
      case MemberRole.moderator:
        return AppColors.warning;
      case MemberRole.member:
        return AppColors.primary;
    }
  }

  IconData get icon {
    switch (this) {
      case MemberRole.owner:
        return Icons.star;
      case MemberRole.moderator:
        return Icons.shield;
      case MemberRole.member:
        return Icons.person;
    }
  }
}

/// Message Type
enum MessageType {
  text,
  image,
  file,
  video,
  audio,
  link;

  IconData get icon {
    switch (this) {
      case MessageType.text:
        return Icons.message;
      case MessageType.image:
        return Icons.image;
      case MessageType.file:
        return Icons.insert_drive_file;
      case MessageType.video:
        return Icons.videocam;
      case MessageType.audio:
        return Icons.mic;
      case MessageType.link:
        return Icons.link;
    }
  }
}

/// Group Member Model
class GroupMember {
  final String id;
  final String name;
  final String? avatarUrl;
  final MemberRole role;
  final bool isOnline;
  final DateTime joinedAt;

  GroupMember({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.role,
    this.isOnline = false,
    required this.joinedAt,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }
}

/// Chat Message Model
class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final MessageType type;
  final String content;
  final String? fileUrl;
  final String? fileName;
  final DateTime timestamp;
  final bool isRead;
  final List<String> reactions;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.type,
    required this.content,
    this.fileUrl,
    this.fileName,
    required this.timestamp,
    this.isRead = false,
    this.reactions = const [],
  });

  String get formattedTime {
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}

/// Study Group Model
class StudyGroup {
  final String id;
  final String name;
  final String? description;
  final String? avatarUrl;
  final List<GroupMember> members;
  final String? courseId;
  final String? courseName;
  final DateTime createdAt;
  final bool isPublic;
  final int maxMembers;
  final List<String> tags;
  final ChatMessage? lastMessage;

  StudyGroup({
    required this.id,
    required this.name,
    this.description,
    this.avatarUrl,
    required this.members,
    this.courseId,
    this.courseName,
    required this.createdAt,
    this.isPublic = false,
    this.maxMembers = 50,
    this.tags = const [],
    this.lastMessage,
  });

  int get memberCount => members.length;

  bool get isFull => memberCount >= maxMembers;

  int get onlineMembers => members.where((m) => m.isOnline).length;

  String get membersPreview {
    if (members.isEmpty) return 'No members';
    if (members.length == 1) return members[0].name;
    if (members.length == 2) {
      return '${members[0].name}, ${members[1].name}';
    }
    return '${members[0].name}, ${members[1].name} +${members.length - 2}';
  }
}

// ============================================================================
// WIDGETS
// ============================================================================

/// Study Group Card Widget
class StudyGroupCard extends StatelessWidget {
  final StudyGroup group;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;
  final bool showJoinButton;

  const StudyGroupCard({
    super.key,
    required this.group,
    this.onTap,
    this.onJoin,
    this.showJoinButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Group Avatar
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: group.avatarUrl != null
                        ? NetworkImage(group.avatarUrl!)
                        : null,
                    child: group.avatarUrl == null
                        ? Icon(
                            Icons.group,
                            color: AppColors.primary,
                            size: 28,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),

                  // Group Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                group.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (group.isPublic)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  context.l10n.swCollabPublic,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              context.l10n.swCollabMembersCount(group.memberCount, group.maxMembers),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (group.onlineMembers > 0) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                context.l10n.swCollabOnlineCount(group.onlineMembers),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (group.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  group.description!,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              if (group.courseName != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.class_,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        group.courseName!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              if (group.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: group.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              if (group.lastMessage != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${group.lastMessage!.senderName}: ${group.lastMessage!.content}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      group.lastMessage!.formattedTime,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],

              if (showJoinButton && onJoin != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: group.isFull ? null : onJoin,
                    icon: const Icon(Icons.person_add),
                    label: Text(group.isFull ? context.l10n.swCollabGroupFull : context.l10n.swCollabJoinGroup),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Chat Message Bubble Widget
class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;
  final VoidCallback? onReact;
  final VoidCallback? onDownload;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.onReact,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              backgroundImage: message.senderAvatar != null
                  ? NetworkImage(message.senderAvatar!)
                  : null,
              child: message.senderAvatar == null
                  ? Text(
                      message.senderName[0].toUpperCase(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isCurrentUser) ...[
                  Text(
                    message.senderName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? AppColors.primary
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: isCurrentUser
                        ? null
                        : Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.type != MessageType.text) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              message.type.icon,
                              size: 16,
                              color: isCurrentUser
                                  ? Colors.white
                                  : AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            if (message.fileName != null)
                              Flexible(
                                child: Text(
                                  message.fileName!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isCurrentUser
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                        if (message.content.isNotEmpty) const SizedBox(height: 6),
                      ],
                      if (message.content.isNotEmpty)
                        Text(
                          message.content,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isCurrentUser
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.formattedTime,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    if (isCurrentUser && message.isRead) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.done_all,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isCurrentUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

/// Group Member Item Widget
class GroupMemberItem extends StatelessWidget {
  final GroupMember member;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool showRole;

  const GroupMemberItem({
    super.key,
    required this.member,
    this.onTap,
    this.onRemove,
    this.showRole = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            backgroundImage:
                member.avatarUrl != null ? NetworkImage(member.avatarUrl!) : null,
            child: member.avatarUrl == null
                ? Text(
                    member.initials,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          if (member.isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        member.name,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: showRole
          ? Row(
              children: [
                Icon(
                  member.role.icon,
                  size: 12,
                  color: member.role.color,
                ),
                const SizedBox(width: 4),
                Text(
                  member.role.displayName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: member.role.color,
                  ),
                ),
              ],
            )
          : null,
      trailing: onRemove != null
          ? IconButton(
              icon: const Icon(Icons.person_remove, size: 20),
              onPressed: onRemove,
              color: AppColors.error,
            )
          : null,
      onTap: onTap,
    );
  }
}

/// Empty Collaboration State
class EmptyCollaborationState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyCollaborationState({
    super.key,
    this.message = '',
    this.subtitle,
    this.onAction,
    this.actionLabel,
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
              Icons.groups_outlined,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              message.isEmpty ? context.l10n.swCollabNoGroupsYet : message,
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
                icon: const Icon(Icons.add),
                label: Text(actionLabel ?? context.l10n.swCollabCreateGroup),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Online Status Indicator
class OnlineStatusIndicator extends StatelessWidget {
  final bool isOnline;
  final double size;

  const OnlineStatusIndicator({
    super.key,
    required this.isOnline,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOnline ? AppColors.success : AppColors.textSecondary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}
