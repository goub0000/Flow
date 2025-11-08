import 'university.dart';

/// Recommendation model
class Recommendation {
  final int id;
  final int? universityId;
  final University? university;
  final double matchScore;
  final String category; // Safety, Match, Reach
  final Map<String, double>? scoreBreakdown;
  final List<String> strengths;
  final List<String> concerns;
  final bool favorited;

  Recommendation({
    required this.id,
    this.universityId,
    this.university,
    required this.matchScore,
    required this.category,
    this.scoreBreakdown,
    this.strengths = const [],
    this.concerns = const [],
    this.favorited = false,
  });

  /// Helper to parse boolean values from JSON (handles both bool and int 0/1)
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'] as int,
      universityId: json['university_id'] as int?,
      university: json['university'] != null
          ? University.fromJson(json['university'] as Map<String, dynamic>)
          : null,
      matchScore: (json['match_score'] as num).toDouble(),
      category: json['category'] as String,
      scoreBreakdown: json['score_breakdown'] != null
          ? Map<String, double>.from(
              (json['score_breakdown'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(key, (value as num).toDouble()),
              ),
            )
          : null,
      strengths: (json['strengths'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      concerns: (json['concerns'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      favorited: _parseBool(json['favorited']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'university': university?.toJson(),
      'match_score': matchScore,
      'category': category,
      'score_breakdown': scoreBreakdown,
      'strengths': strengths,
      'concerns': concerns,
      'favorited': favorited,
    };
  }

  /// Get match score as percentage string
  String get matchScoreFormatted => '${matchScore.toStringAsFixed(0)}%';

  /// Get category color (for UI)
  String get categoryColor {
    switch (category.toLowerCase()) {
      case 'safety':
        return 'success';
      case 'match':
        return 'primary';
      case 'reach':
        return 'warning';
      default:
        return 'primary';
    }
  }

  Recommendation copyWith({
    int? id,
    int? universityId,
    University? university,
    double? matchScore,
    String? category,
    Map<String, double>? scoreBreakdown,
    List<String>? strengths,
    List<String>? concerns,
    bool? favorited,
  }) {
    return Recommendation(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      university: university ?? this.university,
      matchScore: matchScore ?? this.matchScore,
      category: category ?? this.category,
      scoreBreakdown: scoreBreakdown ?? this.scoreBreakdown,
      strengths: strengths ?? this.strengths,
      concerns: concerns ?? this.concerns,
      favorited: favorited ?? this.favorited,
    );
  }
}

/// Recommendation list response
class RecommendationListResponse {
  final List<Recommendation> recommendations;
  final int totalCount;
  final int safetyCount;
  final int matchCount;
  final int reachCount;

  RecommendationListResponse({
    required this.recommendations,
    required this.totalCount,
    required this.safetyCount,
    required this.matchCount,
    required this.reachCount,
  });

  factory RecommendationListResponse.fromJson(Map<String, dynamic> json) {
    // Parse the three separate lists from backend
    final safetySchools = (json['safety_schools'] as List<dynamic>? ?? [])
        .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
        .toList();
    final matchSchools = (json['match_schools'] as List<dynamic>? ?? [])
        .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
        .toList();
    final reachSchools = (json['reach_schools'] as List<dynamic>? ?? [])
        .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
        .toList();

    // Combine into single list
    final allRecommendations = [
      ...safetySchools,
      ...matchSchools,
      ...reachSchools,
    ];

    return RecommendationListResponse(
      recommendations: allRecommendations,
      totalCount: json['total'] as int? ?? allRecommendations.length,
      safetyCount: safetySchools.length,
      matchCount: matchSchools.length,
      reachCount: reachSchools.length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recommendations': recommendations.map((r) => r.toJson()).toList(),
      'total_count': totalCount,
      'safety_count': safetyCount,
      'match_count': matchCount,
      'reach_count': reachCount,
    };
  }
}
