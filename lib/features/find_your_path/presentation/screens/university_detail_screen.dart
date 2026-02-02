import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/services/find_your_path_service.dart';
import '../../domain/models/university.dart';

/// University detail screen showing comprehensive information
class UniversityDetailScreen extends ConsumerStatefulWidget {
  final String universityId;

  const UniversityDetailScreen({
    super.key,
    required this.universityId,
  });

  @override
  ConsumerState<UniversityDetailScreen> createState() =>
      _UniversityDetailScreenState();
}

class _UniversityDetailScreenState
    extends ConsumerState<UniversityDetailScreen> {
  University? _university;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUniversity();
  }

  Future<void> _loadUniversity() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = FindYourPathService();
      final university =
          await service.getUniversity(int.parse(widget.universityId));
      setState(() {
        _university = university;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.l10n.fypUniversityDetails),
        backgroundColor: AppColors.surface,
        actions: [
          if (_university?.website != null)
            IconButton(
              icon: const Icon(Icons.launch),
              onPressed: () {
                // Open website - would need url_launcher package
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Website: ${_university!.website}')),
                );
              },
              tooltip: context.l10n.fypVisitWebsite,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState()
              : _university == null
                  ? Center(child: Text(context.l10n.fypUniversityNotFound))
                  : _buildContent(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            context.l10n.fypErrorLoadingUniversity,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? context.l10n.fypUnknownError,
            style: TextStyle(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadUniversity,
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.fypTryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final university = _university!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(university),
              const SizedBox(height: 32),

              // Quick Stats
              _buildQuickStats(university),
              const SizedBox(height: 32),

              // Description
              if (university.description != null) ...[
                _buildSection(
                  context.l10n.fypAbout,
                  Text(
                    university.description!,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Admissions
              _buildSection(
                context.l10n.fypAdmissions,
                _buildAdmissionsInfo(university),
              ),
              const SizedBox(height: 32),

              // Costs & Financial Aid
              _buildSection(
                context.l10n.fypCostsFinancialAid,
                _buildCostsInfo(university),
              ),
              const SizedBox(height: 32),

              // Student Outcomes
              _buildSection(
                context.l10n.fypStudentOutcomes,
                _buildOutcomesInfo(university),
              ),
              const SizedBox(height: 32),

              // Programs
              if (university.programs != null &&
                  university.programs!.isNotEmpty) ...[
                _buildSection(
                  context.l10n.fypProgramsOffered,
                  _buildProgramsList(university.programs!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(University university) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      university.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      university.location,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (university.universityType != null)
                _buildInfoChip(university.universityType!, Colors.white),
              if (university.locationType != null)
                _buildInfoChip(university.locationType!, Colors.white),
              if (university.totalStudents != null)
                _buildInfoChip(
                  context.l10n.fypKStudents((university.totalStudents! / 1000).toStringAsFixed(1)),
                  Colors.white,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildQuickStats(University university) {
    return Row(
      children: [
        if (university.nationalRank != null)
          Expanded(
            child: _buildStatCard(
              icon: Icons.emoji_events,
              label: context.l10n.fypNationalRank,
              value: '#${university.nationalRank}',
              color: AppColors.warning,
            ),
          ),
        const SizedBox(width: 16),
        if (university.acceptanceRate != null)
          Expanded(
            child: _buildStatCard(
              icon: Icons.percent,
              label: context.l10n.fypAcceptanceRate,
              value: university.formattedAcceptanceRate!,
              color: AppColors.success,
            ),
          ),
        const SizedBox(width: 16),
        if (university.tuitionOutState != null)
          Expanded(
            child: _buildStatCard(
              icon: Icons.attach_money,
              label: context.l10n.fypStatTuition,
              value: university.formattedTuition!,
              color: AppColors.error,
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: content,
        ),
      ],
    );
  }

  Widget _buildAdmissionsInfo(University university) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (university.acceptanceRate != null)
          _buildInfoRow(context.l10n.fypAcceptanceRate, university.formattedAcceptanceRate!),
        if (university.gpaAverage != null)
          _buildInfoRow(
              context.l10n.fypAverageGPA, university.gpaAverage!.toStringAsFixed(2)),
        if (university.satMath25th != null && university.satMath75th != null)
          _buildInfoRow(context.l10n.fypSatMathRange,
              '${university.satMath25th}-${university.satMath75th}'),
        if (university.satEbrw25th != null && university.satEbrw75th != null)
          _buildInfoRow(context.l10n.fypSatEbrwRange,
              '${university.satEbrw25th}-${university.satEbrw75th}'),
        if (university.actComposite25th != null &&
            university.actComposite75th != null)
          _buildInfoRow(context.l10n.fypActRange,
              '${university.actComposite25th}-${university.actComposite75th}'),
      ],
    );
  }

  Widget _buildCostsInfo(University university) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (university.tuitionOutState != null)
          _buildInfoRow(context.l10n.fypOutOfStateTuition, university.formattedTuition!),
        if (university.totalCost != null)
          _buildInfoRow(
            context.l10n.fypTotalCostEst,
            '\$${university.totalCost!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}',
          ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: AppColors.info),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.l10n.fypFinancialAidNote,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOutcomesInfo(University university) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (university.graduationRate != null)
          _buildInfoRow(context.l10n.fypGraduationRate,
              '${university.graduationRate!.toStringAsFixed(1)}%'),
        if (university.medianEarnings != null)
          _buildInfoRow(
            context.l10n.fypMedianEarnings,
            '\$${university.medianEarnings!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}',
          ),
      ],
    );
  }

  Widget _buildProgramsList(List<Program> programs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: programs.map((program) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                size: 18,
                color: AppColors.success,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      program.degreeType +
                          (program.field != null ? ' • ${program.field}' : ''),
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
