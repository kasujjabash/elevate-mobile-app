import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TodaysClassCard extends StatelessWidget {
  const TodaysClassCard({
    super.key,
    required this.subjectName,
    required this.teacherName,
    required this.startTime,
    required this.endTime,
    this.isLive = false,
    this.icon = Icons.menu_book_rounded,
    this.onJoin,
  });

  final String subjectName;
  final String teacherName;
  final String startTime;
  final String endTime;
  final bool isLive;
  final IconData icon;
  final VoidCallback? onJoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 172,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + live badge
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isLive
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : const Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isLive ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (isLive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Subject
          Text(
            subjectName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Teacher
          Text(
            teacherName,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Time row
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 11, color: AppColors.textLight),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '$startTime – $endTime',
                  style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Action button
          if (isLive)
            GestureDetector(
              onTap: onJoin,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.videocam_rounded, size: 13, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'Join Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Upcoming',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
