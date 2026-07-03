import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.title,
    required this.category,
    required this.progress,
    required this.totalLessons,
    required this.completedLessons,
    required this.icon,
    required this.accent,
    this.featured = false,
    this.onTap,
  });

  final String title;
  final String category;
  final double progress;
  final int totalLessons;
  final int completedLessons;
  final IconData icon;
  final Color accent;
  final bool featured;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: featured ? _FeaturedContent(card: this) : _CompactContent(card: this),
    );
  }
}

class _FeaturedContent extends StatelessWidget {
  const _FeaturedContent({required this.card});
  final CourseCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
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
                  color: card.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: card.accent.withValues(alpha: 0.15)),
                ),
                child: Text(
                  card.category,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: card.accent,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: card.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: card.accent.withValues(alpha: 0.15)),
                ),
                child: Icon(card.icon, color: card.accent, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            card.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${card.totalLessons} lessons',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: card.progress,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(card.accent),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(card.progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: card.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${card.completedLessons} of ${card.totalLessons} lessons completed',
                style: const TextStyle(fontSize: 11, color: AppColors.textLight),
              ),
              const Spacer(),
              const Row(
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.primary),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactContent extends StatelessWidget {
  const _CompactContent({required this.card});
  final CourseCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 158,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: card.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: card.accent.withValues(alpha: 0.15)),
            ),
            child: Icon(card.icon, color: card.accent, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            card.title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: card.progress,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(card.accent),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                '${(card.progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: card.accent,
                ),
              ),
              const Spacer(),
              Text(
                '${card.totalLessons} lessons',
                style: const TextStyle(fontSize: 10, color: AppColors.textLight),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
