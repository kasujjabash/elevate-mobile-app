import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';

// ── Lesson definitions (fixed schedule) ───────────────────────────────────────

class _LessonDef {
  const _LessonDef({
    required this.subject,
    required this.instructor,
    required this.startHour,
    required this.startMin,
    required this.endHour,
    required this.endMin,
    required this.description,
  });
  final String subject, instructor, description;
  final int startHour, startMin, endHour, endMin;

  String get timeDisplay {
    final s = '${startHour.toString().padLeft(2, '0')}:${startMin.toString().padLeft(2, '0')}';
    final e = '${endHour.toString().padLeft(2, '0')}:${endMin.toString().padLeft(2, '0')}';
    return '$s – $e';
  }
}

const _webDev = _LessonDef(
  subject: 'Website Development',
  instructor: 'Mr. Bashir Kasujja',
  startHour: 9, startMin: 0,
  endHour: 11, endMin: 0,
  description: 'HTML, CSS & JavaScript',
);

const _fellowship = _LessonDef(
  subject: 'Fellowship',
  instructor: 'Pastor James',
  startHour: 12, startMin: 0,
  endHour: 13, endMin: 0,
  description: 'Life Skills & Values',
);

// 0=Mon, 1=Tue, 2=Wed, 3=Thu, 4=Fri, 5=Sat, 6=Sun
const _schedule = <int, List<_LessonDef>>{
  0: [_webDev],
  2: [_fellowship],
  3: [_webDev],
};

// ── Runtime lesson model ───────────────────────────────────────────────────────

class _Lesson {
  const _Lesson({
    required this.subject,
    required this.time,
    required this.instructor,
    required this.description,
    this.isOngoing = false,
  });
  final String subject, time, instructor, description;
  final bool isOngoing;
}

List<_Lesson> _lessonsForDay(int dayIndex, {bool isToday = false}) {
  final defs = _schedule[dayIndex] ?? [];
  if (defs.isEmpty) return [];
  final now = DateTime.now();
  final lessons = defs.map((def) {
    bool ongoing = false;
    if (isToday) {
      final start = DateTime(now.year, now.month, now.day, def.startHour, def.startMin);
      final end = DateTime(now.year, now.month, now.day, def.endHour, def.endMin);
      ongoing = now.isAfter(start) && now.isBefore(end);
    }
    return _Lesson(
      subject: def.subject,
      time: def.timeDisplay,
      instructor: def.instructor,
      description: def.description,
      isOngoing: ongoing,
    );
  }).toList()
    ..sort((a, b) {
      if (a.isOngoing == b.isOngoing) return 0;
      return a.isOngoing ? -1 : 1; // ongoing comes first
    });
  return lessons;
}

// ── Day data (dynamic, computed from current week) ────────────────────────────

class _DayData {
  const _DayData({
    required this.date,
    required this.name,
    required this.fullName,
    required this.dayIndex,
    required this.isToday,
  });
  final DateTime date;
  final String name;
  final String fullName;
  final int dayIndex;
  final bool isToday;
}

List<_DayData> _buildWeekDays() {
  final now = DateTime.now();
  final monday = now.subtract(Duration(days: now.weekday - 1));
  const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const fullNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  return List.generate(7, (i) {
    final day = monday.add(Duration(days: i));
    return _DayData(
      date: day,
      name: names[i],
      fullName: fullNames[i],
      dayIndex: i,
      isToday:
          day.day == now.day &&
          day.month == now.month &&
          day.year == now.year,
    );
  });
}

// ── Screen ─────────────────────────────────────────────────────────────────────

class StudentsTimetable extends StatefulWidget {
  const StudentsTimetable({super.key});

  @override
  State<StudentsTimetable> createState() => _StudentsTimetableState();
}

class _StudentsTimetableState extends State<StudentsTimetable> {
  late final List<_DayData> _weekDays;
  late int _selectedDay;
  late final ScrollController _dayStripController;

  @override
  void initState() {
    super.initState();
    _weekDays = _buildWeekDays();
    _selectedDay = _weekDays.indexWhere((d) => d.isToday);
    if (_selectedDay < 0) _selectedDay = 0;
    _dayStripController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollDayIntoView());
  }

  @override
  void dispose() {
    _dayStripController.dispose();
    super.dispose();
  }

  void _scrollDayIntoView() {
    const itemWidth = 54.0;
    const padding = 20.0;
    final offset = (_selectedDay * itemWidth) - padding;
    if (_dayStripController.hasClients) {
      _dayStripController.animateTo(
        offset.clamp(0.0, _dayStripController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = _weekDays[_selectedDay];
    final lessons = _lessonsForDay(_selectedDay, isToday: day.isToday);
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final monthYear = '${months[day.date.month]} ${day.date.year}';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Schedule',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        monthYear,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.calendar_month_rounded, size: 14, color: AppColors.primary),
                        SizedBox(width: 5),
                        Text(
                          'This Week',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Day strip ─────────────────────────────────────────────────────
            SizedBox(
              height: 70,
              child: ListView.builder(
                controller: _dayStripController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _weekDays.length,
                itemBuilder: (context, i) {
                  final d = _weekDays[i];
                  final isSelected = i == _selectedDay;
                  final hasClass = _schedule.containsKey(i);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 46,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : d.isToday
                                  ? AppColors.primary.withValues(alpha: 0.3)
                                  : AppColors.border,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            d.name,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.85)
                                  : AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${d.date.day}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          if (!isSelected && hasClass)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: d.isToday ? AppColors.primary : AppColors.textLight,
                                shape: BoxShape.circle,
                              ),
                            )
                          else
                            const SizedBox(height: 9),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // ── Selected day label ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    day.fullName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (day.isToday) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    lessons.isEmpty
                        ? 'No classes'
                        : '${lessons.length} class${lessons.length == 1 ? '' : 'es'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Lesson list ───────────────────────────────────────────────────
            Expanded(
              child: lessons.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF5F5F7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.wb_sunny_outlined,
                              size: 30,
                              color: AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'No classes today',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Enjoy your day off!',
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
                      itemCount: lessons.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _LessonCard(
                        lesson: lessons[i],
                        number: i + 1,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Lesson card ────────────────────────────────────────────────────────────────

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.lesson, required this.number});
  final _Lesson lesson;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: lesson.isOngoing
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.border,
          width: lesson.isOngoing ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Number column
          Container(
            width: 52,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: lesson.isOngoing
                  ? AppColors.primary.withValues(alpha: 0.06)
                  : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                bottomLeft: Radius.circular(13),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: lesson.isOngoing
                        ? AppColors.primary
                        : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, color: AppColors.divider),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          lesson.time,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (lesson.isOngoing) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.circle, size: 6, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Ongoing',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lesson.subject,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.person_outline_rounded, size: 12, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(
                        lesson.instructor,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.book_outlined, size: 12, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          lesson.description,
                          style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (lesson.isOngoing) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Join live class',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.primary),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
