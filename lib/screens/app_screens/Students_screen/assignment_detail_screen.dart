import 'package:era92_elevate/models/assessment.dart';
import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AssignmentDetailScreen extends StatelessWidget {
  const AssignmentDetailScreen({super.key, required this.assignment});

  final Assignment assignment;

  Color get _statusColor {
    switch (assignment.status) {
      case AssignmentStatus.pending:
        return AppColors.warning;
      case AssignmentStatus.submitted:
        return AppColors.info;
      case AssignmentStatus.graded:
        return AppColors.success;
    }
  }

  String get _statusLabel {
    switch (assignment.status) {
      case AssignmentStatus.pending:
        return 'Pending';
      case AssignmentStatus.submitted:
        return 'Submitted';
      case AssignmentStatus.graded:
        return 'Graded';
    }
  }

  int get _daysLeft => assignment.deadline.difference(DateTime.now()).inDays;

  String get _deadlineLabel {
    final d = _daysLeft;
    if (d < 0) return 'Overdue by ${d.abs()} day${d.abs() == 1 ? '' : 's'}';
    if (d == 0) return 'Due today';
    if (d == 1) return '1 day left';
    return '$d days left';
  }

  Color get _deadlineColor {
    final d = _daysLeft;
    if (d < 0) return AppColors.error;
    if (d <= 1) return AppColors.warning;
    return AppColors.success;
  }

  String _formatDateTime(DateTime dt) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '${months[dt.month]} ${dt.day}, ${dt.year}  ·  $hour:$minute $period';
  }

  double get _scorePercent =>
      assignment.score != null ? assignment.score! / assignment.totalMarks : 0;

  Color get _scoreColor {
    if (_scorePercent >= 0.75) return AppColors.success;
    if (_scorePercent >= 0.50) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 18),
          ),
        ),
        title: Text(
          assignment.subject,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Assignment header card ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(assignment.icon, size: 22, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assignment.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          assignment.subject,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Status badges ──────────────────────────────────────────────
            Row(
              children: [
                _StatusBadge(label: _statusLabel, color: _statusColor),
                if (assignment.status == AssignmentStatus.pending) ...[
                  const SizedBox(width: 8),
                  _StatusBadge(
                    label: _deadlineLabel,
                    color: _deadlineColor,
                    icon: Icons.access_time_rounded,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // ── Score card (graded only) ───────────────────────────────────
            if (assignment.status == AssignmentStatus.graded &&
                assignment.score != null) ...[
              _ScoreCard(
                score: assignment.score!,
                total: assignment.totalMarks,
                percent: _scorePercent,
                color: _scoreColor,
              ),
              const SizedBox(height: 20),
            ],

            // ── Info rows ──────────────────────────────────────────────────
            _InfoCard(
              children: [
                _InfoRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Deadline',
                  value: assignment.dueDate,
                ),
                if (assignment.submittedAt != null) ...[
                  const _Divider(),
                  _InfoRow(
                    icon: Icons.check_circle_rounded,
                    label: 'Submitted on',
                    value: _formatDateTime(assignment.submittedAt!),
                    valueColor: AppColors.success,
                  ),
                ],
                if (assignment.submittedLink != null) ...[
                  const _Divider(),
                  _InfoRow(
                    icon: Icons.link_rounded,
                    label: 'Work link',
                    value: assignment.submittedLink!,
                    valueColor: AppColors.primary,
                    isLink: true,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // ── Instructions ───────────────────────────────────────────────
            _SectionLabel(icon: Icons.info_outline_rounded, label: 'Instructions'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                assignment.instructions,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Timeline ───────────────────────────────────────────────────
            _SectionLabel(icon: Icons.timeline_rounded, label: 'Timeline'),
            const SizedBox(height: 10),
            _TimelineCard(assignment: assignment),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Score card (clean, no gradient) ───────────────────────────────────────────

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.score,
    required this.total,
    required this.percent,
    required this.color,
  });

  final int score;
  final int total;
  final double percent;
  final Color color;

  String get _grade {
    if (percent >= 0.90) return 'A';
    if (percent >= 0.80) return 'B';
    if (percent >= 0.70) return 'C';
    if (percent >= 0.60) return 'D';
    return 'F';
  }

  String get _feedback {
    if (percent >= 0.90) return 'Outstanding work!';
    if (percent >= 0.80) return 'Great job!';
    if (percent >= 0.70) return 'Good effort.';
    if (percent >= 0.60) return 'Needs improvement.';
    return 'Please see your lecturer.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Score',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$score',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: color,
                          height: 1,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      TextSpan(
                        text: ' / $total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _feedback,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.25), width: 2),
            ),
            child: Center(
              child: Text(
                _grade,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: color,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info card ──────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.isLink = false,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLink;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary,
                    decoration: isLink ? TextDecoration.underline : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.divider, height: 1, indent: 60);
  }
}

// ── Timeline ───────────────────────────────────────────────────────────────────

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.assignment});
  final Assignment assignment;

  String _formatDate(DateTime dt) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final steps = <_Step>[
      _Step(
        label: 'Assignment Posted',
        subtitle: 'Available in your assessments',
        icon: Icons.assignment_rounded,
        color: AppColors.primary,
        done: true,
      ),
      _Step(
        label: 'Deadline',
        subtitle: assignment.dueDate,
        icon: Icons.calendar_today_rounded,
        color: AppColors.warning,
        done: assignment.status != AssignmentStatus.pending,
      ),
      _Step(
        label: 'Submitted',
        subtitle: assignment.submittedAt != null
            ? _formatDate(assignment.submittedAt!)
            : 'Not yet submitted',
        icon: Icons.upload_rounded,
        color: AppColors.info,
        done: assignment.status == AssignmentStatus.submitted ||
            assignment.status == AssignmentStatus.graded,
      ),
      _Step(
        label: 'Graded',
        subtitle: assignment.status == AssignmentStatus.graded
            ? 'Score: ${assignment.score} / ${assignment.totalMarks}'
            : 'Awaiting grade',
        icon: Icons.star_rounded,
        color: AppColors.success,
        done: assignment.status == AssignmentStatus.graded,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: List.generate(steps.length, (i) {
          final step = steps[i];
          final isLast = i == steps.length - 1;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: step.done
                          ? step.color.withValues(alpha: 0.12)
                          : const Color(0xFFF5F5F7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      step.done ? step.icon : Icons.radio_button_unchecked,
                      size: 18,
                      color: step.done ? step.color : AppColors.textLight,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 32,
                      color: step.done
                          ? step.color.withValues(alpha: 0.25)
                          : AppColors.border,
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 18, top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: step.done ? AppColors.textPrimary : AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _Step {
  const _Step({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.done,
  });
  final String label, subtitle;
  final IconData icon;
  final Color color;
  final bool done;
}

// ── Small helpers ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color, this.icon});
  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
