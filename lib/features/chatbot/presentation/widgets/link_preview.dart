import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';

/// Link preview widget for displaying URL previews in chat
class LinkPreview extends StatelessWidget {
  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? siteName;
  final VoidCallback? onTap;

  const LinkPreview({
    super.key,
    required this.url,
    this.title,
    this.description,
    this.imageUrl,
    this.siteName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap ?? () => _launchUrl(url),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image preview
            if (imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  imageUrl!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Site name
                  if (siteName != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.language,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            siteName!,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Title
                  Text(
                    title ?? _extractDomain(url),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Description
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // URL
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.link,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatUrl(url),
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.open_in_new,
                        size: 14,
                        color: AppColors.primary,
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

  String _extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceFirst('www.', '');
    } catch (e) {
      return url;
    }
  }

  String _formatUrl(String url) {
    try {
      final uri = Uri.parse(url);
      String formatted = uri.host.replaceFirst('www.', '');
      if (uri.path.isNotEmpty && uri.path != '/') {
        formatted += uri.path;
      }
      if (formatted.length > 40) {
        formatted = '${formatted.substring(0, 40)}...';
      }
      return formatted;
    } catch (e) {
      return url.length > 40 ? '${url.substring(0, 40)}...' : url;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Simple inline link widget
class InlineLink extends StatelessWidget {
  final String text;
  final String url;
  final TextStyle? style;

  const InlineLink({
    super.key,
    required this.text,
    required this.url,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Text(
        text,
        style: (style ?? const TextStyle()).copyWith(
          color: AppColors.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Compact link button
class LinkButton extends StatelessWidget {
  final String label;
  final String url;
  final IconData? icon;
  final bool showDomain;

  const LinkButton({
    super.key,
    required this.label,
    required this.url,
    this.icon,
    this.showDomain = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: OutlinedButton.icon(
        onPressed: () => _launchUrl(url),
        icon: Icon(icon ?? Icons.link, size: 16),
        label: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13),
            ),
            if (showDomain)
              Text(
                _extractDomain(url),
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  String _extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceFirst('www.', '');
    } catch (e) {
      return '';
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// List of links widget
class LinkList extends StatelessWidget {
  final String? title;
  final List<LinkListItem> links;

  const LinkList({
    super.key,
    this.title,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.link, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ...links.map((link) => _buildLinkItem(link)),
        ],
      ),
    );
  }

  Widget _buildLinkItem(LinkListItem link) {
    return InkWell(
      onTap: () => _launchUrl(link.url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              link.icon ?? Icons.arrow_forward,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    link.title,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (link.subtitle != null)
                    Text(
                      link.subtitle!,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.open_in_new,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Link list item data
class LinkListItem {
  final String title;
  final String url;
  final String? subtitle;
  final IconData? icon;

  const LinkListItem({
    required this.title,
    required this.url,
    this.subtitle,
    this.icon,
  });
}
