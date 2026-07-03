import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ── Class data model ──────────────────────────────────────────────────────────

class _ClassData {
  const _ClassData({
    required this.subject,
    required this.instructor,
    required this.startHour,
    required this.startMin,
    required this.endHour,
    required this.endMin,
    required this.description,
    required this.icon,
    required this.accent,
    this.meetLink,
  });
  final String subject, instructor, description;
  final int startHour, startMin, endHour, endMin;
  final IconData icon;
  final Color accent;
  final String? meetLink;

  bool get isLive {
    if (meetLink == null) return false;
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, startHour, startMin);
    final end = DateTime(now.year, now.month, now.day, endHour, endMin);
    return now.isAfter(start) && now.isBefore(end);
  }

  bool get isUpcoming {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, startHour, startMin);
    return now.isBefore(start);
  }

  String get timeDisplay {
    final s = '${startHour.toString().padLeft(2, '0')}:${startMin.toString().padLeft(2, '0')}';
    final e = '${endHour.toString().padLeft(2, '0')}:${endMin.toString().padLeft(2, '0')}';
    return '$s – $e';
  }
}

// ── Schedule (matches timetable) ──────────────────────────────────────────────

const _webDev = _ClassData(
  subject: 'Website Development',
  instructor: 'Mr. Bashir Kasujja',
  startHour: 9, startMin: 0,
  endHour: 11, endMin: 0,
  description: 'HTML, CSS & JavaScript',
  icon: Icons.laptop_mac_rounded,
  accent: Color(0xFF1565C0),
  meetLink: 'https://meet.google.com/abc-defg-hij',
);

const _fellowship = _ClassData(
  subject: 'Fellowship',
  instructor: 'Pastor James',
  startHour: 12, startMin: 0,
  endHour: 13, endMin: 0,
  description: 'Life Skills & Values',
  icon: Icons.people_rounded,
  accent: Color(0xFF2E7D32),
  meetLink: 'https://meet.google.com/xyz-uvwx-yzab',
);

// 0=Mon, 1=Tue, 2=Wed, 3=Thu, 4=Fri, 5=Sat, 6=Sun
const _schedule = <int, List<_ClassData>>{
  0: [_webDev],
  2: [_fellowship],
  3: [_webDev],
};

// ── Screen ────────────────────────────────────────────────────────────────────

class StudentsLiveClass extends StatelessWidget {
  const StudentsLiveClass({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // DateTime.weekday: 1=Mon … 7=Sun; our dayIndex: 0=Mon … 6=Sun
    final todayIndex = now.weekday - 1;
    final todaysClasses = _schedule[todayIndex] ?? [];
    final live = todaysClasses.where((c) => c.isLive).toList();
    final upcoming = todaysClasses.where((c) => c.isUpcoming).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(now: now),
            Expanded(
              child: (live.isEmpty && upcoming.isEmpty)
                  ? _EmptyState()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (live.isNotEmpty) ...[
                            _SectionLabel(
                              label: 'Now Live',
                              icon: Icons.circle,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 12),
                            ...live.map(
                              (c) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _ClassCard(item: c, isLive: true),
                              ),
                            ),
                            if (upcoming.isNotEmpty) const SizedBox(height: 8),
                          ],
                          if (upcoming.isNotEmpty) ...[
                            _SectionLabel(
                              label: live.isEmpty ? "Today's Schedule" : 'Upcoming',
                              icon: Icons.access_time_rounded,
                            ),
                            const SizedBox(height: 12),
                            ...upcoming.map(
                              (c) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _ClassCard(item: c, isLive: false),
                              ),
                            ),
                          ],
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

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.now});
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dayName = days[now.weekday - 1];
    final dateStr = '${months[now.month]} ${now.day}';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Live Classes',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$dayName  ·  $dateStr',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
    required this.icon,
    this.color = AppColors.textSecondary,
  });
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isAccent = color == AppColors.primary;
    return Row(
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isAccent ? AppColors.primary : AppColors.textPrimary,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.videocam_off_outlined, size: 32, color: AppColors.textLight),
            ),
            const SizedBox(height: 16),
            const Text(
              'No classes today',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Classes are scheduled for\nMonday, Wednesday & Thursday',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Class card ────────────────────────────────────────────────────────────────

class _ClassCard extends StatelessWidget {
  const _ClassCard({required this.item, required this.isLive});
  final _ClassData item;
  final bool isLive;

  Future<void> _joinClass(BuildContext context) async {
    if (item.meetLink == null) return;
    final uri = Uri.parse(item.meetLink!);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open Google Meet'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLive
              ? AppColors.primary.withValues(alpha: 0.35)
              : AppColors.border,
          width: isLive ? 1.5 : 1.0,
        ),
        boxShadow: isLive
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject + teacher row
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: item.accent.withValues(alpha: 0.15)),
                  ),
                  child: Icon(item.icon, color: item.accent, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.subject,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.instructor,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.circle, size: 5, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Live',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),

            // Time + description row
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 13, color: AppColors.textLight),
                const SizedBox(width: 5),
                Text(
                  item.timeDisplay,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.book_outlined, size: 13, color: AppColors.textLight),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    item.description,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Action button
            isLive
                ? GestureDetector(
                    onTap: () => _joinClass(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam_rounded, size: 16, color: Colors.white),
                          SizedBox(width: 7),
                          Text(
                            'Join Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Upcoming',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
