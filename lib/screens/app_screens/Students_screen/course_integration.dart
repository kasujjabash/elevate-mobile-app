import 'package:era92_elevate/models/enrollment.dart' show Enrollment;
import 'package:era92_elevate/screens/app_screens/Students_screen/course_content_screen.dart';
import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';

// --- Visual Mapping ---

class _CourseVisual {
  const _CourseVisual(this.icon, this.accent, this.category);
  final IconData icon;
  final Color accent;
  final String category;
}

const _courseVisuals = <String, _CourseVisual>{
  'graphic-design': _CourseVisual(
    Icons.brush_rounded,
    Color(0xFF7B1FA2),
    'Design',
  ),
  'website-development': _CourseVisual(
    Icons.laptop_mac_rounded,
    Color(0xFF1565C0),
    'Technology',
  ),
  'film-photography': _CourseVisual(
    Icons.camera_alt_rounded,
    Color(0xFFEF6C00),
    'Media',
  ),
  'alx-course': _CourseVisual(
    Icons.school_rounded,
    Color(0xFF2E7D32),
    'Program',
  ),
};

const _defaultCourseVisual = _CourseVisual(
  Icons.menu_book_rounded,
  AppColors.primary,
  'Course',
);

_CourseVisual _visualFor(String slug) =>
    _courseVisuals[slug] ?? _defaultCourseVisual;

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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: visual.accent.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: visual.accent.withValues(alpha: 0.1)),
                ),
                child: Text(
                  visual.category,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: visual.accent,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: visual.accent.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: visual.accent.withValues(alpha: 0.1)),
                ),
                child: Icon(visual.icon, color: visual.accent, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            enrollment.courseName,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(visual.accent.withValues(alpha: 0.4)),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Continue',
                      style: textTheme.labelLarge?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
        ],
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
      appBar: AppBar(
        title: const Text('My Courses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: enrollments.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
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
                    accent: visual.accent,
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

    // The enrollments list passed here is already filtered by the provider
    final firstEnrollment = enrollments.isNotEmpty ? enrollments.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Courses (${enrollments.length})',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseUnitsPage(enrollments: enrollments),
                  ),
                );
              },
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
                    accent: visual.accent,
                    icon: visual.icon,
                  ),
                ),
              );
            },
          )
        else
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'No courses enrolled yet',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
      ],
    );
  }
}
