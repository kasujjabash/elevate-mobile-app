import 'package:era92_elevate/componets/announcements.dart';
import 'package:era92_elevate/componets/todays_class_card.dart';
import 'package:era92_elevate/models/assessment.dart';
import 'package:era92_elevate/providers/auth_provider.dart';
import 'package:era92_elevate/providers/course_provider.dart';
import 'package:era92_elevate/screens/app_screens/Students_screen/assignment_detail_screen.dart';
import 'package:era92_elevate/screens/app_screens/Students_screen/students_assessment.dart';
import 'package:era92_elevate/screens/app_screens/Students_screen/workshops_screen.dart';
import 'package:era92_elevate/screens/app_screens/Students_screen/course_integration.dart';
import 'package:era92_elevate/screens/auth_screens/welcome_screen.dart';
import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:era92_elevate/componets/profile_card_overlay.dart';
import 'package:provider/provider.dart';

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
    final auth = context.watch<AuthProvider>();
    final courses = context.watch<CourseProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, auth),
              const SizedBox(height: 20),
              _buildAnnouncements(),
              const SizedBox(height: 24),

              // NEW COURSES SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildNewCoursesSection(context, courses),
              ),

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

  // ── New Courses Section Integration ─────────────────────────────────────────

  Widget _buildNewCoursesSection(BuildContext context, CourseProvider courses) {
    if (courses.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (courses.error != null) {
      return Text(
        'Could not load your courses: ${courses.error}',
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      );
    }

    return MyCoursesSection(enrollments: courses.enrollments);
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, AuthProvider auth) {
    final displayName = (auth.user?.fullName.isNotEmpty ?? false)
        ? auth.user!.fullName
        : 'Student';
    final avatarInitial = displayName[0].toUpperCase();

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
                Text(
                  displayName,
                  style: const TextStyle(
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
          GestureDetector(
            onTap: () => showProfileCard(
              context,
              name: displayName,
              email: auth.user?.email ?? '',
              onLogout: () async {
                Navigator.of(context).pop();
                await context.read<AuthProvider>().logout();
                if (!context.mounted) return;
                context.read<CourseProvider>().clear();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              },
            ),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                avatarInitial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
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
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'View all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _todaysClasses.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final c = _todaysClasses[index];
              return TodaysClassCard(
                subjectName: c.subject,
                teacherName: c.teacher,
                startTime: c.start,
                endTime: c.end,
                isLive: c.isLive,
                icon: c.icon,
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Assignments ──────────────────────────────────────────────────────────────

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
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _statusColor.withOpacity(0.20),
                  ),
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

// ── Workshop preview card ───────────────────

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
                  ),
                  // Play button
                  Center(
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.instructor,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
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
