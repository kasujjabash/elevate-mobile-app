import 'package:flutter/material.dart';
import 'package:era92_elevate/theme/app_theme.dart';

class LessonCard extends StatelessWidget {
  final String subject;
  final String time;
  final String instructor;
  final String description;
  final bool isActive;

  const LessonCard({
    super.key,
    required this.subject,
    required this.time,
    required this.instructor,
    required this.description,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isActive ? AppGradients.primary : null,
        color: isActive ? null : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: isActive
            ? null
            : Border.all(color: AppColors.divider, width: 1),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.28),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.textLight.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white.withValues(alpha: 0.20)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColors.white : AppColors.textSecondary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              if (isActive) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Ongoing',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12),

          Text(
            subject,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isActive ? AppColors.white : AppColors.textPrimary,
              letterSpacing: -0.3,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            instructor,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? AppColors.white.withValues(alpha: 0.85)
                  : AppColors.textSecondary,
            ),
          ),

          const Spacer(),

          Container(
            height: 1,
            color: isActive
                ? Colors.white.withValues(alpha: 0.20)
                : AppColors.divider,
            margin: const EdgeInsets.only(bottom: 10),
          ),

          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: isActive
                  ? AppColors.white.withValues(alpha: 0.75)
                  : AppColors.textLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
