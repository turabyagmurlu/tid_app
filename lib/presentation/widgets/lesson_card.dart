import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/lesson_model.dart';

/// Home ekranında bir dersi temsil eden kart.
class LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final bool completed;
  final double progress; // 0..1 (öğrenilen kelime oranı)
  final VoidCallback onTap;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
    this.completed = false,
    this.progress = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                alignment: Alignment.center,
                child: Text(
                  lesson.level,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${lesson.words.length} işaret',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (progress > 0) ...[
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 5,
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          valueColor: const AlwaysStoppedAnimation(
                              AppColors.success),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text('%${(progress * 100).round()} öğrenildi',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
              Icon(
                completed ? Icons.check_circle : Icons.chevron_right,
                color: completed ? AppColors.success : null,
                semanticLabel: completed ? 'Tamamlandı' : 'Aç',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
