import 'package:era92_elevate/componets/announcements.dart';
import 'package:era92_elevate/componets/tiles/course_card.dart';
import 'package:era92_elevate/componets/todays_class_card.dart';
import 'package:era92_elevate/models/assessment.dart';
import 'package:era92_elevate/screens/app_screens/Students_screen/assignment_detail_screen.dart';
import 'package:era92_elevate/screens/app_screens/Students_screen/students_assessment.dart';
import 'package:era92_elevate/screens/app_screens/Students_screen/workshops_screen.dart';
import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';

// ── Course data ───────────────────────────────────────────────────────────────

class _CourseData {
  const _CourseData({
    required this.title,
    required this.category,
    required this.progress,
    required this.totalLessons,
    required this.completedLessons,
    required this.icon,
    required this.accent,
  });
  final String title;
  final String category;
  final double progress;
  final int totalLessons;
  final int completedLessons;
  final IconData icon;
  final Color accent;
}

const _courses = <_CourseData>[
  _CourseData(
    title: 'Website Development',
    category: 'Technology',
    progress: 0.42,
    totalLessons: 24,
    completedLessons: 10,
    icon: Icons.laptop_mac_rounded,
    accent: Color(0xFF1565C0),
  ),
];

// ── Today's class data ────────────────────────────────────────────────────────

class _ClassItem {
  const _ClassItem({
    required this.subject,
    required this.teacher,
    required this.start,
    required this.end,
    this.isLive = false,
    this.icon = Icons.menu_book_rounded,
  });
  final String subject;
  final String teacher;
  final String start;
  final String end;
  final bool isLive;
  final IconData icon;
}

const _todaysClasses = <_ClassItem>[
  _ClassItem(
    subject: 'Website Development',
    teacher: 'Mr. Bashir Kasujja',
    start: '09:00 AM',
    end: '11:00 AM',
    isLive: true,
    icon: Icons.laptop_mac_rounded,
  ),
  _ClassItem(
    subject: 'Fellowship',
    teacher: 'Pastor James',
    start: '12:00 PM',
    end: '01:00 PM',
    icon: Icons.people_rounded,
  ),
  _ClassItem(
    subject: 'Public Speaking',
    teacher: 'Ms. Grace Apio',
    start: '02:00 PM',
    end: '03:30 PM',
    icon: Icons.mic_rounded,
  ),
];

// ── Recent assignments data ───────────────────────────────────────────────────

final _recentAssignments = <Assignment>[
  Assignment(
    title: 'HTML & CSS Landing Page',
    subject: 'Website Development',
    dueDate: 'Jun 20, 2025',
    deadline: DateTime(2025, 6, 20, 23, 59),
    instructions:
        'Build a responsive landing page using HTML and CSS. Upload your project to GitHub and submit the repository link.',
    status: AssignmentStatus.graded,
    score: 88,
    totalMarks: 100,
    icon: Icons.laptop_mac_rounded,
    submittedAt: DateTime(2025, 6, 19, 14, 32),
  ),
  Assignment(
    title: 'Persuasive Speech Draft',
    subject: 'Public Speaking',
    dueDate: 'Jun 28, 2025',
    deadline: DateTime(2025, 6, 28, 23, 59),
    instructions:
        'Prepare a 3-minute persuasive speech on a topic of your choice and submit a written draft.',
    status: AssignmentStatus.pending,
    icon: Icons.record_voice_over_rounded,
  ),
];

// ── Workshop preview data ─────────────────────────────────────────────────────

const _workshopPreviews = <_WorkshopPreview>[
  _WorkshopPreview(
    title: 'Building Your First Website from Scratch',
    videoId: 'KWuP9WHYFi4',
    instructor: 'Mr. Bashir',
    duration: '42 min',
  ),
  _WorkshopPreview(
    title: 'Mastering Public Speaking & Confidence',
    videoId: 'fI8qTKm0eFI',
    instructor: 'Mrs. Nakato',
    duration: '38 min',
  ),
];

class _WorkshopPreview {
  const _WorkshopPreview({
    required this.title,
    required this.videoId,
    required this.instructor,
    required this.duration,
  });
  final String title;
  final String videoId;
  final String instructor;
  final String duration;
}

// ── Home screen ───────────────────────────────────────────────────────────────

class StudentsHome extends StatelessWidget {
  const StudentsHome({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildAnnouncements(),
              const SizedBox(height: 24),
              _buildCoursesSection(context),
              const SizedBox(height: 24),
              _buildTodaysClassesSection(context),
              const SizedBox(height: 24),
              _buildAssignmentsSection(context),
              const SizedBox(height: 24),
              _buildWorkshopsSection(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_greeting()},',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Student',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Text(
              'S',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Announcements ────────────────────────────────────────────────────────────

  Widget _buildAnnouncements() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: AnnouncementBanner(),
    );
  }

  // ── My Courses ───────────────────────────────────────────────────────────────

  Widget _buildCoursesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text(
                'My Courses',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Featured course (first in list)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CourseCard(
            title: _courses[0].title,
            category: _courses[0].category,
            progress: _courses[0].progress,
            totalLessons: _courses[0].totalLessons,
            completedLessons: _courses[0].completedLessons,
            icon: _courses[0].icon,
            accent: _courses[0].accent,
            featured: true,
          ),
        ),

        // Additional courses (horizontal scroll if more than 1 course)
        if (_courses.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 136,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _courses.length - 1,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final c = _courses[index + 1];
                return CourseCard(
                  title: c.title,
                  category: c.category,
                  progress: c.progress,
                  totalLessons: c.totalLessons,
                  completedLessons: c.completedLessons,
                  icon: c.icon,
                  accent: c.accent,
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  // ── Today's Classes ──────────────────────────────────────────────────────────

  Widget _buildTodaysClassesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text(
                "Today's Classes",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_todaysClasses.length}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 212,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _todaysClasses.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final c = _todaysClasses[index];
              return TodaysClassCard(
                subjectName: c.subject,
                teacherName: c.teacher,
                startTime: c.start,
                endTime: c.end,
                isLive: c.isLive,
                icon: c.icon,
                onJoin: c.isLive
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const _LiveClassSession(),
                          ),
                        )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Recent Assignments ───────────────────────────────────────────────────────

  Widget _buildAssignmentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text(
                'Recent Assignments',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentsAssessment()),
                ),
                child: const Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _recentAssignments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = _recentAssignments[index];
            return _AssignmentPreviewTile(
              item: item,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AssignmentDetailScreen(assignment: item),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ── Workshops ────────────────────────────────────────────────────────────────

  Widget _buildWorkshopsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text(
                'Workshops',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WorkshopsScreen()),
                ),
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _workshopPreviews.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final w = _workshopPreviews[index];
              return _WorkshopPreviewCard(item: w);
            },
          ),
        ),
      ],
    );
  }
}

// ── Assignment preview tile ───────────────────────────────────────────────────

class _AssignmentPreviewTile extends StatelessWidget {
  const _AssignmentPreviewTile({required this.item, this.onTap});

  final Assignment item;
  final VoidCallback? onTap;

  Color get _statusColor {
    switch (item.status) {
      case AssignmentStatus.pending:
        return AppColors.warning;
      case AssignmentStatus.submitted:
        return AppColors.info;
      case AssignmentStatus.graded:
        return AppColors.success;
    }
  }

  String get _statusLabel {
    switch (item.status) {
      case AssignmentStatus.pending:
        return 'Pending';
      case AssignmentStatus.submitted:
        return 'Submitted';
      case AssignmentStatus.graded:
        return 'Graded';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 18, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${item.subject}  ·  ${item.dueDate}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (item.status == AssignmentStatus.graded && item.score != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item.score}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                  Text(
                    '/${item.totalMarks}',
                    style: const TextStyle(fontSize: 10, color: AppColors.textLight),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _statusColor.withValues(alpha: 0.20)),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _statusColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Workshop preview card (vertical card, thumbnail at top) ───────────────────

class _WorkshopPreviewCard extends StatelessWidget {
  const _WorkshopPreviewCard({required this.item});
  final _WorkshopPreview item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WorkshopsScreen()),
      ),
      child: Container(
        width: 206,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            SizedBox(
              height: 116,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://img.youtube.com/vi/${item.videoId}/hqdefault.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF5F5F7),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_outline_rounded,
                          size: 36,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.45),
                        ],
                      ),
                    ),
                  ),
                  // Play button
                  Center(
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                  // Duration
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.70),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        item.duration,
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded, size: 11, color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            item.instructor,
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

// ── In-session live class view (pushed from Join Now) ────────────────────────
// This is a thin wrapper that delegates to StudentsLiveClass from the nav.
// Keeping it here avoids a circular import; the nav version is the full screen.

class _LiveClassSession extends StatelessWidget {
  const _LiveClassSession();

  @override
  Widget build(BuildContext context) {
    // Import would be circular; push a fresh full-screen page via shell index.
    // For now show a direct navigation message until nav wiring is done.
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D12),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Live Class',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: const Center(
        child: Text(
          'Tap Live Class in the navigation bar\nto enter your session.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
        ),
      ),
    );
  }
}
