import '../utils/export_utils.dart';
import '../../../../core/models/user_model.dart';

/// Service for exporting user data
class ExportService {
  /// Export students data
  static Future<void> exportStudents({
    required List<UserModel> students,
    required ExportFormat format,
  }) async {
    final data = students.map((student) {
      return {
        'Student ID': 'STU${student.id.substring(0, 6).toUpperCase()}',
        'Full Name': student.displayName ?? 'Unknown',
        'Email': student.email,
        'Status': student.metadata?['isActive'] == true ? 'Active' : 'Inactive',
        'Created': student.createdAt.toString().split(' ')[0],
      };
    }).toList();

    await _export(
      data: data,
      filename: 'students_export_${DateTime.now().millisecondsSinceEpoch}',
      format: format,
      title: 'Students Export',
    );
  }

  /// Export institutions data
  static Future<void> exportInstitutions({
    required List<UserModel> institutions,
    required ExportFormat format,
  }) async {
    final data = institutions.map((institution) {
      return {
        'Institution ID': 'INS${institution.id.substring(0, 6).toUpperCase()}',
        'Name': institution.displayName ?? 'Unknown',
        'Email': institution.email,
        'Status': institution.metadata?['isActive'] == true ? 'Active' : 'Inactive',
        'Created': institution.createdAt.toString().split(' ')[0],
      };
    }).toList();

    await _export(
      data: data,
      filename: 'institutions_export_${DateTime.now().millisecondsSinceEpoch}',
      format: format,
      title: 'Institutions Export',
    );
  }

  /// Export parents data
  static Future<void> exportParents({
    required List<UserModel> parents,
    required ExportFormat format,
  }) async {
    final data = parents.map((parent) {
      return {
        'Parent ID': 'PAR${parent.id.substring(0, 6).toUpperCase()}',
        'Full Name': parent.displayName ?? 'Unknown',
        'Email': parent.email,
        'Status': parent.metadata?['isActive'] == true ? 'Active' : 'Inactive',
        'Created': parent.createdAt.toString().split(' ')[0],
      };
    }).toList();

    await _export(
      data: data,
      filename: 'parents_export_${DateTime.now().millisecondsSinceEpoch}',
      format: format,
      title: 'Parents Export',
    );
  }

  /// Export counselors data
  static Future<void> exportCounselors({
    required List<UserModel> counselors,
    required ExportFormat format,
  }) async {
    final data = counselors.map((counselor) {
      return {
        'Counselor ID': 'COU${counselor.id.substring(0, 6).toUpperCase()}',
        'Full Name': counselor.displayName ?? 'Unknown',
        'Email': counselor.email,
        'Status': counselor.metadata?['isActive'] == true ? 'Active' : 'Inactive',
        'Created': counselor.createdAt.toString().split(' ')[0],
      };
    }).toList();

    await _export(
      data: data,
      filename: 'counselors_export_${DateTime.now().millisecondsSinceEpoch}',
      format: format,
      title: 'Counselors Export',
    );
  }

  /// Export recommenders data
  static Future<void> exportRecommenders({
    required List<UserModel> recommenders,
    required ExportFormat format,
  }) async {
    final data = recommenders.map((recommender) {
      return {
        'Recommender ID': 'REC${recommender.id.substring(0, 6).toUpperCase()}',
        'Full Name': recommender.displayName ?? 'Unknown',
        'Email': recommender.email,
        'Status': recommender.metadata?['isActive'] == true ? 'Active' : 'Inactive',
        'Created': recommender.createdAt.toString().split(' ')[0],
      };
    }).toList();

    await _export(
      data: data,
      filename: 'recommenders_export_${DateTime.now().millisecondsSinceEpoch}',
      format: format,
      title: 'Recommenders Export',
    );
  }

  /// Internal export method that routes to appropriate export function
  static Future<void> _export({
    required List<Map<String, dynamic>> data,
    required String filename,
    required ExportFormat format,
    required String title,
  }) async {
    if (data.isEmpty) {
      throw Exception('No data to export');
    }

    switch (format) {
      case ExportFormat.csv:
        await ExportUtils.exportToCSV(data: data, filename: filename);
        break;
      case ExportFormat.excel:
        await ExportUtils.exportToExcel(data: data, filename: filename);
        break;
      case ExportFormat.pdf:
        await ExportUtils.exportToPDF(data: data, filename: filename, title: title);
        break;
    }
  }
}
