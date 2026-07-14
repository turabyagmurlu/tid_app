import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/lesson_model.dart';
import '../blocs/lesson/lesson_cubit.dart';
import '../blocs/progress/progress_cubit.dart';

/// İlerleme / istatistik paneli: öğrenilen kelime, XP, seri ve seviye
/// başına tamamlanma.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  static const List<String> _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  @override
  Widget build(BuildContext context) {
    final ls = context.watch<LessonCubit>().state;
    final List<LessonModel> lessons =
        ls is LessonLoaded ? ls.lessons : const [];

    return Scaffold(
      appBar: AppBar(title: const Text('İlerlemem')),
      body: SafeArea(
        child: BlocBuilder<ProgressCubit, ProgressState>(
          builder: (context, ps) {
            final p = ps.progress;

            // Toplamlar
            var totalWords = 0;
            final perLevelTotal = {for (final l in _levels) l: 0};
            final perLevelLearned = {for (final l in _levels) l: 0};
            for (final les in lessons) {
              for (final w in les.words) {
                totalWords++;
                if (perLevelTotal.containsKey(les.level)) {
                  perLevelTotal[les.level] = perLevelTotal[les.level]! + 1;
                  if (p.learnedWordIds.contains(w.wordId)) {
                    perLevelLearned[les.level] =
                        perLevelLearned[les.level]! + 1;
                  }
                }
              }
            }
            final learned = p.learnedWordIds.length;

            return ListView(
              padding: const EdgeInsets.all(AppDimensions.md),
              children: [
                Row(
                  children: [
                    _StatCard(
                      icon: Icons.local_fire_department,
                      color: Colors.deepOrange,
                      value: '${p.currentStreak}',
                      label: 'günlük seri',
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    _StatCard(
                      icon: Icons.star,
                      color: AppColors.accent,
                      value: '${p.xp}',
                      label: 'XP',
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: [
                    _StatCard(
                      icon: Icons.school,
                      color: AppColors.success,
                      value: '$learned / $totalWords',
                      label: 'öğrenilen kelime',
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    _StatCard(
                      icon: Icons.check_circle,
                      color: AppColors.primary,
                      value: '${p.completedLessonIds.length}',
                      label: 'biten ders',
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.lg),
                Text('Seviyelere Göre İlerleme',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppDimensions.sm),
                for (final lv in _levels)
                  if (perLevelTotal[lv]! > 0)
                    _LevelRow(
                      level: lv,
                      learned: perLevelLearned[lv]!,
                      total: perLevelTotal[lv]!,
                    ),
                const SizedBox(height: AppDimensions.lg),
                Card(
                  color: AppColors.accent.withOpacity(0.10),
                  child: ListTile(
                    leading: const Icon(Icons.star, color: AppColors.accent),
                    title: const Text('Favori kelime'),
                    trailing: Text('${p.favoriteWordIds.length}',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                Text(
                  learned == 0
                      ? 'Bir derse gir, kelimeleri "Öğrendim" işaretle — burası dolmaya başlasın!'
                      : 'Harika gidiyorsun! Her gün biraz tekrar, seriyi büyütür. 🔥',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 6),
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(label,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelRow extends StatelessWidget {
  final String level;
  final int learned;
  final int total;

  const _LevelRow({
    required this.level,
    required this.learned,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : learned / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Text(level,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 8,
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.success),
                  ),
                ),
                const SizedBox(height: 2),
                Text('$learned / $total  (%${(ratio * 100).round()})',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
