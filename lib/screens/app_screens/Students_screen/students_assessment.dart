import 'package:era92_elevate/componets/tiles/assignment_tile.dart';
import 'package:era92_elevate/models/assessment.dart';
import 'package:era92_elevate/screens/app_screens/Students_screen/assignment_detail_screen.dart';
import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';

// ── Sample data ────────────────────────────────────────────────────────────────

final _assignments = [
  Assignment(
    title: 'HTML & CSS Landing Page',
    subject: 'Website Development',
    dueDate: 'Jun 20, 2025',
    deadline: DateTime(2025, 6, 20, 23, 59),
    instructions:
        'Build a responsive landing page using HTML and CSS. Include a navbar, hero section, features section, and footer. Upload to GitHub and submit the repo link.',
    status: AssignmentStatus.graded,
    score: 88,
    totalMarks: 100,
    icon: Icons.laptop_mac_rounded,
    submittedAt: DateTime(2025, 6, 19, 14, 32),
  ),
  Assignment(
    title: 'Speech on Leadership',
    subject: 'Public Speaking',
    dueDate: 'Jun 22, 2025',
    deadline: DateTime(2025, 6, 22, 17, 0),
    instructions:
        'Prepare a 5-minute speech on a leadership figure of your choice. Record and upload the video to Google Drive, then submit the link.',
    status: AssignmentStatus.graded,
    score: 74,
    totalMarks: 100,
    icon: Icons.mic_rounded,
    submittedAt: DateTime(2025, 6, 21, 9, 10),
  ),
  Assignment(
    title: 'JavaScript Functions Quiz',
    subject: 'Website Development',
    dueDate: 'Jun 25, 2025',
    deadline: DateTime(2025, 6, 25, 23, 59),
    instructions:
        'Complete the JavaScript functions quiz on the learning portal. Screenshot your result and submit the Google Drive link.',
    status: AssignmentStatus.submitted,
    icon: Icons.laptop_mac_rounded,
    submittedLink: 'https://drive.google.com/file/example',
    submittedAt: DateTime(2025, 6, 24, 18, 45),
  ),
  Assignment(
    title: 'Group Reflection Essay',
    subject: 'Fellowship',
    dueDate: 'Jun 28, 2025',
    deadline: DateTime(2025, 6, 28, 17, 0),
    instructions:
        'Write a 500-word group reflection on this term\'s fellowship activities. Submit a Google Docs link with comment access.',
    status: AssignmentStatus.pending,
    icon: Icons.people_rounded,
  ),
  Assignment(
    title: 'Debate Preparation',
    subject: 'Public Speaking',
    dueDate: 'Jul 2, 2025',
    deadline: DateTime(2025, 7, 2, 17, 0),
    instructions:
        'Prepare both sides of "Social media does more harm than good." Record a 3-min practice debate and submit the Drive link.',
    status: AssignmentStatus.pending,
    icon: Icons.mic_rounded,
  ),
];

// ── Sample resources ───────────────────────────────────────────────────────────

class _Resource {
  const _Resource({
    required this.title,
    required this.subject,
    required this.type,
    required this.meta,
    required this.icon,
    required this.iconBg,
  });
  final String title;
  final String subject;
  final String type;
  final String meta;
  final IconData icon;
  final Color iconBg;
}

const _resources = [
  _Resource(
    title: 'HTML & CSS Fundamentals',
    subject: 'Website Development',
    type: 'PDF',
    meta: '2.4 MB · 24 pages',
    icon: Icons.picture_as_pdf_rounded,
    iconBg: Color(0xFFFFEEEE),
  ),
  _Resource(
    title: 'Intro to JavaScript — Video',
    subject: 'Website Development',
    type: 'Video',
    meta: '45 min · HD',
    icon: Icons.play_circle_outline_rounded,
    iconBg: Color(0xFFFFF3E0),
  ),
  _Resource(
    title: 'Leadership Essay Examples',
    subject: 'Public Speaking',
    type: 'PDF',
    meta: '1.1 MB · 8 pages',
    icon: Icons.picture_as_pdf_rounded,
    iconBg: Color(0xFFFFEEEE),
  ),
  _Resource(
    title: 'Speech Techniques Guide',
    subject: 'Public Speaking',
    type: 'Link',
    meta: 'External resource',
    icon: Icons.open_in_new_rounded,
    iconBg: Color(0xFFE8F4FD),
  ),
  _Resource(
    title: 'Fellowship Handbook 2025',
    subject: 'Fellowship',
    type: 'PDF',
    meta: '3.7 MB · 52 pages',
    icon: Icons.picture_as_pdf_rounded,
    iconBg: Color(0xFFFFEEEE),
  ),
  _Resource(
    title: 'CSS Grid & Flexbox Cheatsheet',
    subject: 'Website Development',
    type: 'PDF',
    meta: '0.8 MB · 4 pages',
    icon: Icons.picture_as_pdf_rounded,
    iconBg: Color(0xFFFFEEEE),
  ),
];

// ── Screen ─────────────────────────────────────────────────────────────────────

class StudentsAssessment extends StatefulWidget {
  const StudentsAssessment({super.key});

  @override
  State<StudentsAssessment> createState() => _StudentsAssessmentState();
}

class _StudentsAssessmentState extends State<StudentsAssessment>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<Assignment> get _graded =>
      _assignments.where((a) => a.status == AssignmentStatus.graded).toList();
  List<Assignment> get _pending =>
      _assignments.where((a) => a.status == AssignmentStatus.pending).toList();
  List<Assignment> get _submitted =>
      _assignments.where((a) => a.status == AssignmentStatus.submitted).toList();

  double get _averageScore {
    if (_graded.isEmpty) return 0;
    return _graded.fold<int>(0, (s, a) => s + (a.score ?? 0)) /
        _graded.length;
  }

  void _onSubmitted(Assignment a, String link) {
    setState(() {
      a.status = AssignmentStatus.submitted;
      a.submittedLink = link;
      a.submittedAt = DateTime.now();
    });
  }

  void _openDetail(Assignment a) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AssignmentDetailScreen(assignment: a)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assessments',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Track your marks and submissions',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Stats row ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _StatsRow(
                average: _averageScore,
                pending: _pending.length,
                submitted: _submitted.length,
                graded: _graded.length,
              ),
            ),
            const SizedBox(height: 20),

            // ── Tab bar ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SegmentedTabBar(controller: _tab),
            ),
            const SizedBox(height: 8),

            // ── Tab views ────────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _AssignmentsTab(
                    assignments: _assignments,
                    onSubmitted: _onSubmitted,
                    onTap: _openDetail,
                  ),
                  const _ResourcesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stats row ──────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.average,
    required this.pending,
    required this.submitted,
    required this.graded,
  });

  final double average;
  final int pending;
  final int submitted;
  final int graded;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Average score
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Average Score',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${average.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$graded graded',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 52, color: AppColors.divider),
          const SizedBox(width: 16),
          // Counts
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatBadge(
                count: pending,
                label: 'Pending',
                color: AppColors.warning,
              ),
              const SizedBox(height: 6),
              _StatBadge(
                count: submitted,
                label: 'Submitted',
                color: AppColors.info,
              ),
              const SizedBox(height: 6),
              _StatBadge(
                count: graded,
                label: 'Graded',
                color: AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.count,
    required this.label,
    required this.color,
  });
  final int count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$count $label',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ── Segmented tab bar ──────────────────────────────────────────────────────────

class _SegmentedTabBar extends StatelessWidget {
  const _SegmentedTabBar({required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(7),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Assignments'),
          Tab(text: 'Resources'),
        ],
      ),
    );
  }
}

// ── Assignments tab ────────────────────────────────────────────────────────────

class _AssignmentsTab extends StatefulWidget {
  const _AssignmentsTab({
    required this.assignments,
    required this.onSubmitted,
    required this.onTap,
  });

  final List<Assignment> assignments;
  final void Function(Assignment, String) onSubmitted;
  final void Function(Assignment) onTap;

  @override
  State<_AssignmentsTab> createState() => _AssignmentsTabState();
}

class _AssignmentsTabState extends State<_AssignmentsTab> {
  AssignmentStatus? _filter;

  List<Assignment> get _filtered {
    if (_filter == null) return widget.assignments;
    return widget.assignments.where((a) => a.status == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Filter chips ──────────────────────────────────────────────────
        SizedBox(
          height: 36,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: [
              _FilterChip(
                label: 'All',
                selected: _filter == null,
                onTap: () => setState(() => _filter = null),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Pending',
                selected: _filter == AssignmentStatus.pending,
                color: AppColors.warning,
                onTap: () => setState(
                  () => _filter = _filter == AssignmentStatus.pending
                      ? null
                      : AssignmentStatus.pending,
                ),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Submitted',
                selected: _filter == AssignmentStatus.submitted,
                color: AppColors.info,
                onTap: () => setState(
                  () => _filter = _filter == AssignmentStatus.submitted
                      ? null
                      : AssignmentStatus.submitted,
                ),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Graded',
                selected: _filter == AssignmentStatus.graded,
                color: AppColors.success,
                onTap: () => setState(
                  () => _filter = _filter == AssignmentStatus.graded
                      ? null
                      : AssignmentStatus.graded,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── List ──────────────────────────────────────────────────────────
        Expanded(
          child: _filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWarm,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.inbox_rounded,
                          size: 32,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Nothing here',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'No assignments match this filter.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => AssignmentTile(
                    item: _filtered[i],
                    onSubmitted: widget.onSubmitted,
                    onTap: widget.onTap,
                  ),
                ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? activeColor : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? activeColor : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ── Resources tab ──────────────────────────────────────────────────────────────

class _ResourcesTab extends StatelessWidget {
  const _ResourcesTab();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: _resources.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _ResourceTile(resource: _resources[i]),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  const _ResourceTile({required this.resource});
  final _Resource resource;

  Color get _typeColor {
    switch (resource.type) {
      case 'Video':
        return AppColors.warning;
      case 'Link':
        return AppColors.info;
      default:
        return const Color(0xFFD62828);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: resource.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(resource.icon, color: _typeColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  resource.subject,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  resource.meta,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _typeColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _typeColor.withValues(alpha: 0.18)),
            ),
            child: Text(
              resource.type,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _typeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
