import 'package:era92_elevate/models/enrollment.dart' show Enrollment;
import 'package:era92_elevate/screens/app_screens/Students_screen/course_content_screen.dart';
import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';

// --- Visual Mapping ---

class _CourseVisual {
  const _CourseVisual(this.icon, this.category);
  final IconData icon;
  final String category;
}

const _courseVisuals = <String, _CourseVisual>{
  'graphic-design': _CourseVisual(Icons.brush_rounded, 'Design'),
  'website-development': _CourseVisual(Icons.laptop_mac_rounded, 'Technology'),
  'film-photography': _CourseVisual(Icons.camera_alt_rounded, 'Media'),
  'ui-ux-design': _CourseVisual(Icons.design_services_rounded, 'Design'),
  'alx-course': _CourseVisual(Icons.school_rounded, 'Program'),
};

const _defaultCourseVisual = _CourseVisual(Icons.menu_book_rounded, 'Course');

_CourseVisual _visualFor(String slug) => _courseVisuals[slug] ?? _defaultCourseVisual;

// --- Widgets ---

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.enrollment, this.onTap});

  final Enrollment enrollment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final visual = _visualFor(enrollment.courseSlug);
    final progress = enrollment.progress / 100;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon with brand gradient (MAINTAINED)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(visual.icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visual.category.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary, // BRAND PRIMARY
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        enrollment.courseName,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 19,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Progress',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary, // BRAND PRIMARY
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Progress Bar with brand primary color (MAINTAINED)
            Stack(
              children: [
                Container(
                  height: 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.divider.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  height: 8,
                  width: MediaQuery.of(context).size.width * (progress * 0.75),
                  decoration: BoxDecoration(
                    color: AppColors.primary, // BRAND PRIMARY
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Action Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08), // BRAND PRIMARY OPACITY
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Continue Learning',
                        style: textTheme.labelLarge?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary, // BRAND PRIMARY
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.play_arrow_rounded,
                        size: 18,
                        color: AppColors.primary, // BRAND PRIMARY
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- Pages ---

class CourseUnitsPage extends StatelessWidget {
  final List<Enrollment> enrollments;
  const CourseUnitsPage({super.key, required this.enrollments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'My Course Units',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        itemCount: enrollments.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final enrollment = enrollments[index];
          final visual = _visualFor(enrollment.courseSlug);
          return CourseCard(
            enrollment: enrollment,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseContentScreen(
                    enrollment: enrollment,
                    accent: AppColors.primary, // BRAND PRIMARY
                    icon: visual.icon,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// --- Main Home Page Section ---

class MyCoursesSection extends StatelessWidget {
  final List<Enrollment> enrollments;
  const MyCoursesSection({super.key, required this.enrollments});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final firstEnrollment = enrollments.isNotEmpty ? enrollments.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Learning Journey',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You are enrolled in ${enrollments.length} active units',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseUnitsPage(enrollments: enrollments),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary, // BRAND PRIMARY
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (firstEnrollment != null)
          CourseCard(
            enrollment: firstEnrollment,
            onTap: () {
              final visual = _visualFor(firstEnrollment.courseSlug);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseContentScreen(
                    enrollment: firstEnrollment,
                    accent: AppColors.primary, // BRAND PRIMARY
                    icon: visual.icon,
                  ),
                ),
              );
            },
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surfaceWarm.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5), style: BorderStyle.none),
            ),
            child: Column(
              children: [
                Icon(Icons.auto_stories_rounded, color: AppColors.textLight.withValues(alpha: 0.5), size: 48),
                const SizedBox(height: 16),
                const Text(
                  'No courses enrolled yet',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
