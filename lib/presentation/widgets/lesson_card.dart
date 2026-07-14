import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/lesson_model.dart';
import 'pressable.dart';

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
    return Pressable(
      child: Card(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Row(
            children: [
              Builder(builder: (context) {
                final lc = AppColors.forLevel(lesson.level);
                return Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.gradientFor(lc),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: lc.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    lesson.level,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                );
              }),
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
      ),
    );
  }
}
