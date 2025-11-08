import 'package:flutter/material.dart';

/// Report Model
class ReportModel {
  final String id;
  final String name;
  final String description;
  final ReportType type;
  final ReportCategory category;
  final IconData icon;
  final DateTime? lastGenerated;
  final bool isScheduled;
  final ReportFrequency? frequency;

  ReportModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.category,
    required this.icon,
    this.lastGenerated,
    this.isScheduled = false,
    this.frequency,
  });
}

/// Report Type
enum ReportType {
  users,
  financial,
  engagement,
  performance,
  system,
  custom,
}

/// Report Category
enum ReportCategory {
  analytics,
  operations,
  finance,
  compliance,
}

/// Report Frequency
enum ReportFrequency {
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
}

/// Report Parameters
class ReportParameters {
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> filters;
  final ReportFormat format;

  ReportParameters({
    required this.startDate,
    required this.endDate,
    this.filters = const {},
    this.format = ReportFormat.pdf,
  });
}

/// Report Format
enum ReportFormat {
  pdf,
  csv,
  excel,
  json,
}

/// Extension for report type
extension ReportTypeExtension on ReportType {
  String get label {
    switch (this) {
      case ReportType.users:
        return 'Users';
      case ReportType.financial:
        return 'Financial';
      case ReportType.engagement:
        return 'Engagement';
      case ReportType.performance:
        return 'Performance';
      case ReportType.system:
        return 'System';
      case ReportType.custom:
        return 'Custom';
    }
  }
}

/// Extension for report category
extension ReportCategoryExtension on ReportCategory {
  String get label {
    switch (this) {
      case ReportCategory.analytics:
        return 'Analytics';
      case ReportCategory.operations:
        return 'Operations';
      case ReportCategory.finance:
        return 'Finance';
      case ReportCategory.compliance:
        return 'Compliance';
    }
  }
}

/// Extension for report frequency
extension ReportFrequencyExtension on ReportFrequency {
  String get label {
    switch (this) {
      case ReportFrequency.daily:
        return 'Daily';
      case ReportFrequency.weekly:
        return 'Weekly';
      case ReportFrequency.monthly:
        return 'Monthly';
      case ReportFrequency.quarterly:
        return 'Quarterly';
      case ReportFrequency.yearly:
        return 'Yearly';
    }
  }
}

/// Extension for report format
extension ReportFormatExtension on ReportFormat {
  String get label {
    switch (this) {
      case ReportFormat.pdf:
        return 'PDF';
      case ReportFormat.csv:
        return 'CSV';
      case ReportFormat.excel:
        return 'Excel';
      case ReportFormat.json:
        return 'JSON';
    }
  }

  String get extension {
    switch (this) {
      case ReportFormat.pdf:
        return '.pdf';
      case ReportFormat.csv:
        return '.csv';
      case ReportFormat.excel:
        return '.xlsx';
      case ReportFormat.json:
        return '.json';
    }
  }
}
