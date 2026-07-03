import 'package:era92_elevate/models/assessment.dart';
import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';

// ── Status helpers ─────────────────────────────────────────────────────────────

Color assignmentStatusColor(AssignmentStatus status) {
  switch (status) {
    case AssignmentStatus.pending:
      return AppColors.warning;
    case AssignmentStatus.submitted:
      return AppColors.info;
    case AssignmentStatus.graded:
      return AppColors.success;
  }
}

String assignmentStatusLabel(AssignmentStatus status) {
  switch (status) {
    case AssignmentStatus.pending:
      return 'Pending';
    case AssignmentStatus.submitted:
      return 'Submitted';
    case AssignmentStatus.graded:
      return 'Graded';
  }
}

// ── Assignment tile ────────────────────────────────────────────────────────────

class AssignmentTile extends StatelessWidget {
  const AssignmentTile({
    super.key,
    required this.item,
    required this.onSubmitted,
    required this.onTap,
  });

  final Assignment item;
  final void Function(Assignment, String) onSubmitted;
  final void Function(Assignment) onTap;

  int get _daysLeft => item.deadline.difference(DateTime.now()).inDays;

  String get _deadlineText {
    final d = _daysLeft;
    if (d < 0) return 'Overdue';
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

  void _showSubmit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AssignmentSubmitSheet(
        assignment: item,
        deadlineText: _deadlineText,
        deadlineColor: _deadlineColor,
        onConfirm: (link) => onSubmitted(item, link),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = assignmentStatusColor(item.status);

    return GestureDetector(
      onTap: () => onTap(item),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Main row ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Icon(item.icon, color: AppColors.textSecondary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.subject,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 13,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.dueDate,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textLight,
                              ),
                            ),
                            if (item.status == AssignmentStatus.pending) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _deadlineColor.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _deadlineText,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _deadlineColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (item.status == AssignmentStatus.graded &&
                          item.score != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${item.score}/${item.totalMarks}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.20),
                          ),
                        ),
                        child: Text(
                          assignmentStatusLabel(item.status),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Footer ────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: item.status == AssignmentStatus.pending
                  ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.instructions,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textLight,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => _showSubmit(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.upload_outlined,
                                  size: 14,
                                  color: AppColors.white,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.instructions,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textLight,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'View details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Submit bottom sheet ────────────────────────────────────────────────────────

class AssignmentSubmitSheet extends StatefulWidget {
  const AssignmentSubmitSheet({
    super.key,
    required this.assignment,
    required this.deadlineText,
    required this.deadlineColor,
    required this.onConfirm,
  });

  final Assignment assignment;
  final String deadlineText;
  final Color deadlineColor;
  final void Function(String link) onConfirm;

  @override
  State<AssignmentSubmitSheet> createState() => _AssignmentSubmitSheetState();
}

class _AssignmentSubmitSheetState extends State<AssignmentSubmitSheet> {
  final _controller = TextEditingController();
  bool _hasError = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  void _confirm() {
    final link = _controller.text.trim();
    if (!_isValidUrl(link)) {
      setState(() => _hasError = true);
      return;
    }
    Navigator.pop(context);
    widget.onConfirm(link);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Submitted successfully!',
              style: TextStyle(color: AppColors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomInset),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Submit Assignment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.assignment.title,
            style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: widget.deadlineColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: widget.deadlineColor.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: widget.deadlineColor,
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.assignment.dueDate}  ·  ${widget.deadlineText}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: widget.deadlineColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Paste your work link',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Share a Google Drive, GitHub, or any public link.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.url,
            onChanged: (_) {
              if (_hasError) setState(() => _hasError = false);
            },
            decoration: InputDecoration(
              hintText: 'https://drive.google.com/...',
              prefixIcon: const Icon(
                Icons.link_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              filled: true,
              fillColor: AppColors.background,
              errorText: _hasError ? 'Please enter a valid URL' : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _confirm,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_rounded, size: 16),
                        SizedBox(width: 6),
                        Text('Confirm'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
