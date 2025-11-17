import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';
import '../../shared/providers/profile_provider.dart';
import 'universities_provider.dart';
import 'institutions_provider.dart';

/// Model for recommendation items
class RecommendationItem {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? badge;
  final String type; // 'program', 'university', 'course'
  final Map<String, dynamic>? metadata;
  final double? matchScore; // Relevance score 0-100

  RecommendationItem({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.badge,
    required this.type,
    this.metadata,
    this.matchScore,
  });

  factory RecommendationItem.fromJson(Map<String, dynamic> json) {
    return RecommendationItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      badge: json['badge'],
      type: json['type'] ?? 'program',
      metadata: json['metadata'],
      matchScore: (json['matchScore'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl ?? '',
      'badge': badge,
    };
  }
}

/// Provider for personalized recommendations
final recommendationsProvider = FutureProvider<List<RecommendationItem>>((ref) async {
  try {
    // First, try to get recommendations from the backend API
    final apiClient = ref.read(apiClientProvider);

    // Check if recommendations endpoint exists
    try {
      final response = await apiClient.get(
        '${ApiConfig.recommendations}/personalized',
        fromJson: (data) {
          if (data is List) {
            return data.map((json) => RecommendationItem.fromJson(json)).toList();
          }
          return <RecommendationItem>[];
        },
      );

      if (response.success && response.data != null && response.data!.isNotEmpty) {
        print('[DEBUG] Fetched ${response.data!.length} personalized recommendations from API');
        return response.data!;
      }
    } catch (e) {
      print('[DEBUG] Recommendations API not available: $e');
      // Fall back to frontend-based recommendations
    }

    // If API is not available or returns no data, generate recommendations locally
    return await _generateLocalRecommendations(ref);

  } catch (e) {
    print('[DEBUG] Error fetching recommendations: $e');
    // Return default recommendations on error
    return _getDefaultRecommendations();
  }
});

/// Generate recommendations based on available data
Future<List<RecommendationItem>> _generateLocalRecommendations(Ref ref) async {
  final recommendations = <RecommendationItem>[];

  try {
    // Get user profile for personalization
    final userProfile = ref.read(currentProfileProvider);

    // Get available universities and institutions
    final universitiesState = ref.read(universitiesProvider);
    final institutionsState = ref.read(institutionsProvider);

    // Get user preferences from profile (using available fields in UserModel)

    // Since UserModel doesn't have interests, fieldOfStudy, or country fields,
    // we'll use metadata or default values for now
    final userMetadata = userProfile?.metadata ?? {};
    final userInterests = (userMetadata['interests'] as List<dynamic>?)?.cast<String>() ?? <String>[];
    final preferredField = userMetadata['fieldOfStudy'] as String? ?? '';
    final userLocation = userMetadata['country'] as String? ?? '';

    // Generate recommendations from universities
    if (!universitiesState.isLoading && universitiesState.error == null) {
      final universities = universitiesState.universities;

      // Sort universities by relevance
      final sortedUniversities = [...universities];

      // Simple matching: prioritize based on location and programs offered
      if (userLocation.isNotEmpty) {
        sortedUniversities.sort((a, b) {
          final aLocationMatch = a.country.toLowerCase() == userLocation.toLowerCase() ? 1 : 0;
          final bLocationMatch = b.country.toLowerCase() == userLocation.toLowerCase() ? 1 : 0;
          return bLocationMatch.compareTo(aLocationMatch);
        });
      }

      // Take top 3 universities
      for (var i = 0; i < sortedUniversities.length && i < 3; i++) {
        final uni = sortedUniversities[i];

        // Determine badge based on ranking or special features
        String? badge;
        if (i == 0) {
          badge = 'TOP MATCH';
        } else if (uni.globalRank != null && uni.globalRank! <= 100) {
          badge = 'TOP 100';
        } else if (uni.country == userLocation) {
          badge = 'LOCAL';
        }

        recommendations.add(RecommendationItem(
          id: uni.id.toString(),  // Convert int to String
          title: uni.name,
          description: uni.description ?? 'Explore programs at ${uni.name}',
          imageUrl: uni.logoUrl,
          badge: badge,
          type: 'university',
          metadata: {
            'universityId': uni.id,
            'country': uni.country,
            'globalRank': uni.globalRank,
          },
          matchScore: (3 - i) * 25.0 + 25, // Score between 50-100
        ));
      }
    }

    // Generate program recommendations based on field of study
    if (!institutionsState.isLoading && institutionsState.error == null) {
      // For now, we'll use static program recommendations
      final programs = <RecommendationItem>[];

        // Popular programs that align with common student interests
        final popularPrograms = [
          {
            'title': 'Computer Science & Engineering',
            'description': 'Build the future with cutting-edge technology',
            'field': 'technology',
            'badge': 'HIGH DEMAND',
          },
          {
            'title': 'Business Administration',
            'description': 'Develop leadership and management skills',
            'field': 'business',
            'badge': 'POPULAR',
          },
          {
            'title': 'Health Sciences',
            'description': 'Make a difference in healthcare',
            'field': 'health',
            'badge': 'GROWING FIELD',
          },
          {
            'title': 'Environmental Studies',
            'description': 'Address global sustainability challenges',
            'field': 'environment',
            'badge': 'FUTURE FOCUSED',
          },
          {
            'title': 'Data Science & Analytics',
            'description': 'Master the language of modern business',
            'field': 'technology',
            'badge': 'NEW',
          },
        ];

        // Filter and rank programs based on user preferences
        for (final program in popularPrograms) {
          bool shouldInclude = false;
          double matchScore = 50.0;

          // Check if program matches user's field of study
          if (preferredField.isNotEmpty &&
              program['field']?.toString().toLowerCase().contains(preferredField.toLowerCase()) == true) {
            shouldInclude = true;
            matchScore += 30;
          }

          // Check if program matches any user interests
          for (final interest in userInterests) {
            if (program['title']?.toString().toLowerCase().contains(interest.toLowerCase()) == true ||
                program['description']?.toString().toLowerCase().contains(interest.toLowerCase()) == true) {
              shouldInclude = true;
              matchScore += 20;
            }
          }

          // Include popular programs even if no specific match
          if (!shouldInclude && recommendations.length < 5) {
            shouldInclude = true;
          }

          if (shouldInclude && programs.length < 3) {
            programs.add(RecommendationItem(
              id: 'program-${program['title'].hashCode}',
              title: program['title'] ?? '',
              description: program['description'] ?? '',
              badge: program['badge'],
              type: 'program',
              metadata: {
                'field': program['field'],
              },
              matchScore: matchScore.clamp(0, 100),
            ));
          }
        }

      recommendations.addAll(programs);
    }

    // If we still don't have enough recommendations, add default ones
    if (recommendations.length < 3) {
      recommendations.addAll(_getDefaultRecommendations());
    }

    // Sort by match score and return top recommendations
    recommendations.sort((a, b) => (b.matchScore ?? 0).compareTo(a.matchScore ?? 0));
    return recommendations.take(5).toList();

  } catch (e) {
    print('[DEBUG] Error generating local recommendations: $e');
    return _getDefaultRecommendations();
  }
}

/// Get default recommendations when no personalization is possible
List<RecommendationItem> _getDefaultRecommendations() {
  return [
    RecommendationItem(
      id: 'default-1',
      title: 'Explore Top Universities',
      description: 'Discover world-class institutions that match your goals',
      badge: 'START HERE',
      type: 'general',
      matchScore: 75,
    ),
    RecommendationItem(
      id: 'default-2',
      title: 'Find Your Path Assessment',
      description: 'Take our AI-powered assessment to get personalized recommendations',
      badge: 'RECOMMENDED',
      type: 'assessment',
      matchScore: 90,
    ),
    RecommendationItem(
      id: 'default-3',
      title: 'Scholarship Opportunities',
      description: 'Browse available scholarships and financial aid options',
      badge: 'SAVE MONEY',
      type: 'scholarship',
      matchScore: 85,
    ),
  ];
}

/// Provider to refresh recommendations
final refreshRecommendationsProvider = Provider((ref) {
  return () {
    // Invalidate the provider to force refresh
    ref.invalidate(recommendationsProvider);
  };
});