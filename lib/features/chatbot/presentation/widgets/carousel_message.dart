import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'card_message.dart';

/// Carousel item data model
class CarouselItem {
  final String? imageUrl;
  final String title;
  final String? subtitle;
  final String? description;
  final List<CardAction>? actions;
  final VoidCallback? onTap;

  const CarouselItem({
    this.imageUrl,
    required this.title,
    this.subtitle,
    this.description,
    this.actions,
    this.onTap,
  });
}

/// Carousel message widget for displaying multiple cards horizontally
class CarouselMessage extends StatefulWidget {
  final List<CarouselItem> items;
  final String? title;
  final double itemWidth;
  final double itemHeight;

  const CarouselMessage({
    super.key,
    required this.items,
    this.title,
    this.itemWidth = 260,
    this.itemHeight = 240,
  });

  @override
  State<CarouselMessage> createState() => _CarouselMessageState();
}

class _CarouselMessageState extends State<CarouselMessage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.title!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          // Carousel
          SizedBox(
            height: widget.itemHeight,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: (page) => setState(() => _currentPage = page),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _CarouselCard(
                    item: item,
                    width: widget.itemWidth,
                  ),
                );
              },
            ),
          ),

          // Page indicators
          if (widget.items.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.items.length,
                  (index) => _buildIndicator(index),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final CarouselItem item;
  final double width;

  const _CarouselCard({
    required this.item,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (item.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  item.imageUrl!,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 100,
                    color: AppColors.border,
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Subtitle
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Description
                    if (item.description != null) ...[
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          item.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],

                    const Spacer(),

                    // Actions
                    if (item.actions != null && item.actions!.isNotEmpty)
                      Row(
                        children: item.actions!.take(2).map((action) {
                          if (action.isPrimary) {
                            return Expanded(
                              child: ElevatedButton(
                                onPressed: action.onPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  minimumSize: const Size(0, 32),
                                ),
                                child: Text(
                                  action.label,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            );
                          }
                          return Expanded(
                            child: TextButton(
                              onPressed: action.onPressed,
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                minimumSize: const Size(0, 32),
                              ),
                              child: Text(
                                action.label,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Factory for creating common carousel types
class CarouselMessageFactory {
  /// Create a carousel of universities
  static CarouselMessage universities({
    required List<UniversityCarouselData> universities,
    String? title,
    Function(String universityId)? onViewDetails,
    Function(String universityId)? onApply,
  }) {
    return CarouselMessage(
      title: title ?? 'Recommended Universities',
      items: universities.map((uni) {
        return CarouselItem(
          imageUrl: uni.logoUrl,
          title: uni.name,
          subtitle: uni.location,
          description: [
            if (uni.rank != null) 'Rank: #${uni.rank}',
            if (uni.acceptanceRate != null) '${uni.acceptanceRate!.toStringAsFixed(1)}% acceptance',
          ].join(' | '),
          actions: [
            CardAction(
              label: 'Details',
              onPressed: () => onViewDetails?.call(uni.id),
            ),
            CardAction(
              label: 'Apply',
              onPressed: () => onApply?.call(uni.id),
              isPrimary: true,
            ),
          ],
        );
      }).toList(),
    );
  }

  /// Create a carousel of courses
  static CarouselMessage courses({
    required List<CourseCarouselData> courses,
    String? title,
    Function(String courseId)? onViewDetails,
    Function(String courseId)? onEnroll,
  }) {
    return CarouselMessage(
      title: title ?? 'Recommended Courses',
      items: courses.map((course) {
        return CarouselItem(
          imageUrl: course.thumbnailUrl,
          title: course.name,
          subtitle: course.university,
          description: [
            if (course.duration != null) course.duration!,
            if (course.level != null) course.level!,
          ].join(' | '),
          actions: [
            CardAction(
              label: 'Learn More',
              onPressed: () => onViewDetails?.call(course.id),
            ),
            CardAction(
              label: 'Enroll',
              onPressed: () => onEnroll?.call(course.id),
              isPrimary: true,
            ),
          ],
        );
      }).toList(),
    );
  }
}

/// Data model for university carousel
class UniversityCarouselData {
  final String id;
  final String name;
  final String location;
  final String? logoUrl;
  final int? rank;
  final double? acceptanceRate;

  const UniversityCarouselData({
    required this.id,
    required this.name,
    required this.location,
    this.logoUrl,
    this.rank,
    this.acceptanceRate,
  });
}

/// Data model for course carousel
class CourseCarouselData {
  final String id;
  final String name;
  final String university;
  final String? thumbnailUrl;
  final String? duration;
  final String? level;

  const CourseCarouselData({
    required this.id,
    required this.name,
    required this.university,
    this.thumbnailUrl,
    this.duration,
    this.level,
  });
}
