import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// A mini quiz teaser widget for the home page.
///
/// Shows 1-2 sample questions from Find Your Path
/// with animated card transitions and a CTA.
class MiniQuizPreview extends StatefulWidget {
  const MiniQuizPreview({super.key});

  @override
  State<MiniQuizPreview> createState() => _MiniQuizPreviewState();
}

class _MiniQuizPreviewState extends State<MiniQuizPreview> {
  int _currentQuestion = 0;
  String? _selectedAnswer;

  List<_QuizQuestion> _buildQuestions(BuildContext context) {
    return [
      _QuizQuestion(
        question: context.l10n.quizFieldQuestion,
        options: [
          context.l10n.quizFieldTechEngineering,
          context.l10n.quizFieldBusinessFinance,
          context.l10n.quizFieldHealthcareMedicine,
          context.l10n.quizFieldArtsHumanities,
        ],
        icon: Icons.lightbulb_outline,
      ),
      _QuizQuestion(
        question: context.l10n.quizLocationQuestion,
        options: [
          context.l10n.quizLocationWestAfrica,
          context.l10n.quizLocationEastAfrica,
          context.l10n.quizLocationSouthernAfrica,
          context.l10n.quizLocationAnywhereAfrica,
        ],
        icon: Icons.public,
      ),
    ];
  }

  void _selectAnswer(String answer, int questionsLength) {
    setState(() {
      _selectedAnswer = answer;
    });

    // After a brief delay, show CTA or next question
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (_currentQuestion < questionsLength - 1) {
          setState(() {
            _currentQuestion++;
            _selectedAnswer = null;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final questions = _buildQuestions(context);
    final question = questions[_currentQuestion];

    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  question.icon,
                  color: AppColors.accent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.quizFindYourPath,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.l10n.quizQuickPreview,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Progress indicator
              Text(
                '${_currentQuestion + 1}/${questions.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Question
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              question.question,
              key: ValueKey(_currentQuestion),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          // Options
          ...question.options.map((option) {
            final isSelected = _selectedAnswer == option;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _selectAnswer(option, questions.length),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withOpacity(0.1)
                        : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // CTA
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => context.go('/find-your-path'),
              icon: const Icon(Icons.arrow_forward),
              label: Text(context.l10n.quizGetRecommendations),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizQuestion {
  final String question;
  final List<String> options;
  final IconData icon;

  const _QuizQuestion({
    required this.question,
    required this.options,
    required this.icon,
  });
}

/// A compact quiz teaser button
class QuizTeaser extends StatefulWidget {
  final VoidCallback? onTap;

  const QuizTeaser({
    super.key,
    this.onTap,
  });

  @override
  State<QuizTeaser> createState() => _QuizTeaserState();
}

class _QuizTeaserState extends State<QuizTeaser> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap ?? () => context.go('/find-your-path'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isHovered
                  ? [AppColors.accent, AppColors.accentDark]
                  : [AppColors.accent.withOpacity(0.9), AppColors.accentDark.withOpacity(0.9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(_isHovered ? 0.4 : 0.2),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.explore,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.quizFindYourPath,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    context.l10n.quizTakeTheQuiz,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
