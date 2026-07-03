import 'package:flutter/material.dart';
import 'package:era92_elevate/componets/lesson_page_view.dart';
import 'package:era92_elevate/theme/app_theme.dart';

class DayCard extends StatelessWidget {
  final String dayName;
  final bool isToday;
  final int currentLessonIndex;
  final int dayIndex;
  final bool isFirst;
  final bool isLast;

  const DayCard({
    super.key,
    required this.dayName,
    required this.isToday,
    required this.currentLessonIndex,
    required this.dayIndex,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ── Left side: timeline ──
          SizedBox(
            width: 44,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                if (!isFirst)
                  Positioned(
                    top: 0,
                    left: 21,
                    child: Container(
                      width: 1.5,
                      height: 16,
                      color: AppColors.divider,
                    ),
                  ),

                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 14),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isToday ? 13 : 9,
                        height: isToday ? 13 : 9,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isToday
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: isToday
                                ? AppColors.primary
                                : AppColors.divider,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (!isLast)
                  Positioned(
                    top: 29,
                    left: 21,
                    bottom: 0,
                    child: Container(
                      width: 1.5,
                      color: AppColors.divider,
                    ),
                  ),
              ],
            ),
          ),

          // ── Right side ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 4, bottom: 6),
                    child: Row(
                      children: [
                        Text(
                          dayName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isToday
                                ? FontWeight.w900
                                : FontWeight.w800,
                            color: isToday
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        if (isToday) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: AppGradients.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Today',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  LessonPageView(
                    currentLessonIndex: currentLessonIndex,
                    isActiveDay: isToday,
                    dayIndex: dayIndex,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}