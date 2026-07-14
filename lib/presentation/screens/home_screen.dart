import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/lesson_model.dart';
import '../blocs/lesson/lesson_cubit.dart';
import '../blocs/progress/progress_cubit.dart';
import '../blocs/srs/srs_cubit.dart';
import '../widgets/lesson_card.dart';
import '../widgets/streak_banner.dart';
import 'favorites_screen.dart';
import 'hand_tracking_screen.dart';
import 'lesson_detail_screen.dart';
import 'review_today_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        actions: [
          IconButton(
            tooltip: 'İlerlemem',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const StatsScreen(),
            )),
            icon: const Icon(Icons.insights),
          ),
          IconButton(
            tooltip: 'Ara',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const SearchScreen(),
            )),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: 'Favorilerim',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const FavoritesScreen(),
            )),
            icon: const Icon(Icons.star),
          ),
          IconButton(
            tooltip: 'Ayarlar',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const SettingsScreen(),
            )),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<LessonCubit, LessonState>(
          builder: (context, state) {
            return switch (state) {
              LessonInitial() ||
              LessonLoading() =>
                const Center(child: CircularProgressIndicator()),
              LessonError(:final message) => _ErrorView(message: message),
              LessonLoaded(:final lessons) => _LessonList(lessons: lessons),
            };
          },
        ),
      ),
    );
  }
}

class _LessonList extends StatelessWidget {
  final List<LessonModel> lessons;
  const _LessonList({required this.lessons});

  @override
  Widget build(BuildContext context) {
    // Modüle göre grupla (ekleme sırasını koruyarak).
    final byModule = <String, List<LessonModel>>{};
    for (final lesson in lessons) {
      byModule.putIfAbsent(lesson.module, () => <LessonModel>[]).add(lesson);
    }
    final modules = byModule.keys.toList();

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.md),
      children: [
        BlocBuilder<ProgressCubit, ProgressState>(
          builder: (context, ps) =>
              StreakBanner(streak: ps.progress.currentStreak),
        ),
        const SizedBox(height: AppDimensions.md),
        _ReviewTodayEntry(lessons: lessons),
        const SizedBox(height: AppDimensions.sm),
        Card(
          color: AppColors.primary.withOpacity(0.12),
          child: ListTile(
            leading: const Icon(Icons.back_hand, color: AppColors.primary),
            title: const Text('El Takibi (Deneysel)'),
            subtitle: const Text(
                'Kamerada parmak noktalarını canlı gör, işaretini kontrol et'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const HandTrackingScreen(),
            )),
          ),
        ),
        const SizedBox(height: AppDimensions.lg),
        Text(AppStrings.modulesTitle,
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppDimensions.sm),
        for (final module in modules) ...[
          Padding(
            padding: const EdgeInsets.only(
              top: AppDimensions.md,
              bottom: AppDimensions.sm,
            ),
            child: Row(
              children: [
                Container(width: 4, height: 22, color: AppColors.primary),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Text(module,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ],
            ),
          ),
          for (final lesson in byModule[module]!)
            BlocBuilder<ProgressCubit, ProgressState>(
              builder: (context, ps) => LessonCard(
                lesson: lesson,
                completed:
                    ps.progress.completedLessonIds.contains(lesson.lessonId),
                progress: context.read<ProgressCubit>().lessonProgress(lesson),
                onTap: () {
                  context.read<ProgressCubit>().registerStudyToday();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => LessonDetailScreen(lesson: lesson),
                  ));
                },
              ),
            ),
        ],
        const SizedBox(height: AppDimensions.xl),
      ],
    );
  }
}

/// "Bugün Tekrar" giriş kartı — vadesi gelen kelime sayısını gösterir.
class _ReviewTodayEntry extends StatefulWidget {
  final List<LessonModel> lessons;
  const _ReviewTodayEntry({required this.lessons});

  @override
  State<_ReviewTodayEntry> createState() => _ReviewTodayEntryState();
}

class _ReviewTodayEntryState extends State<_ReviewTodayEntry> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final learned =
          context.read<ProgressCubit>().state.progress.learnedWordIds;
      context.read<SrsCubit>().loadDue(widget.lessons, learned);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SrsCubit, SrsState>(
      builder: (context, s) {
        final due = s.dueWords.length;
        return Card(
          color: AppColors.accent.withOpacity(0.14),
          child: ListTile(
            leading: const Icon(Icons.repeat, color: AppColors.accent),
            title: const Text('Bugün Tekrar'),
            subtitle: Text(due > 0
                ? '$due kelime tekrar için hazır'
                : 'Kelimeleri "Öğrendim" işaretle, tekrar burada birikir'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const ReviewTodayScreen(),
            )),
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppDimensions.md),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppDimensions.md),
            ElevatedButton(
              onPressed: () => context.read<LessonCubit>().loadLessons(),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
