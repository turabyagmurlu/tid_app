import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/lesson_model.dart';
import '../../data/models/word_model.dart';
import '../blocs/lesson/lesson_cubit.dart';
import '../blocs/progress/progress_cubit.dart';
import '../blocs/quiz/quiz_cubit.dart';
import '../widgets/dual_video_player.dart';

/// Çoktan seçmeli quiz: video göster → 4 Türkçe şıktan doğruyu seç.
class QuizScreen extends StatelessWidget {
  final LessonModel lesson;
  final List<WordModel> extraPool;

  const QuizScreen({super.key, required this.lesson, this.extraPool = const []});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) {
        // Çeldirici havuzu için tüm derslerdeki kelimeleri kullan.
        var pool = extraPool;
        final ls = ctx.read<LessonCubit>().state;
        if (pool.isEmpty && ls is LessonLoaded) {
          pool = ls.lessons.expand((l) => l.words).toList();
        }
        return QuizCubit()..start(lesson, extraPool: pool);
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Quiz — ${lesson.title}')),
        body: SafeArea(
          child: BlocBuilder<QuizCubit, QuizState>(
            builder: (context, state) {
              if (state.isEmpty) {
                return const _NotEnough();
              }
              if (state.finished) {
                return _Result(
                  correct: state.correctCount,
                  total: state.total,
                  onRetry: () =>
                      context.read<QuizCubit>().start(lesson, extraPool: extraPool),
                );
              }
              return _Question(lesson: lesson);
            },
          ),
        ),
      ),
    );
  }
}

class _Question extends StatelessWidget {
  final LessonModel lesson;
  const _Question({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<QuizCubit>().state;
    final q = state.current!;
    final variant = q.word.regionalVariants.first;
    final answered = state.selected != null;

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.md),
      children: [
        LinearProgressIndicator(
          value: (state.index + 1) / state.total,
          backgroundColor: AppColors.primary.withOpacity(0.15),
        ),
        const SizedBox(height: AppDimensions.sm),
        Text('Soru ${state.index + 1} / ${state.total}',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppDimensions.sm),
        Text('Bu işaret hangi kelime?',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppDimensions.md),
        DualVideoPlayer(
          key: ValueKey('quiz_${q.word.wordId}'),
          fullBodyUrl: variant.videoFullBody,
          lipCloseupUrl: variant.videoLipCloseups,
        ),
        const SizedBox(height: AppDimensions.md),
        for (final opt in q.options)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.sm),
            child: _OptionButton(
              label: opt,
              state: state,
              correct: q.correct,
              onTap: () => context.read<QuizCubit>().answer(opt),
            ),
          ),
        const SizedBox(height: AppDimensions.sm),
        if (answered)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: Text(state.index + 1 >= state.total
                  ? 'Sonuçları Gör'
                  : 'Sonraki Soru'),
              onPressed: () => context.read<QuizCubit>().next(),
            ),
          ),
      ],
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String label;
  final QuizState state;
  final String correct;
  final VoidCallback onTap;

  const _OptionButton({
    required this.label,
    required this.state,
    required this.correct,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final answered = state.selected != null;
    Color? bg;
    Color? fg;
    if (answered) {
      if (label == correct) {
        bg = AppColors.success;
        fg = Colors.white;
      } else if (label == state.selected) {
        bg = AppColors.error;
        fg = Colors.white;
      }
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: answered ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          disabledBackgroundColor: bg,
          foregroundColor: fg,
          disabledForegroundColor: fg,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(AppDimensions.md),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

class _Result extends StatefulWidget {
  final int correct;
  final int total;
  final VoidCallback onRetry;

  const _Result({
    required this.correct,
    required this.total,
    required this.onRetry,
  });

  @override
  State<_Result> createState() => _ResultState();
}

class _ResultState extends State<_Result> {
  @override
  void initState() {
    super.initState();
    // XP + seri yalnızca bir kez ödüllendirilir.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final progress = context.read<ProgressCubit>();
      progress.addXp(widget.correct * 5);
      progress.registerStudyToday();
    });
  }

  @override
  Widget build(BuildContext context) {
    final correct = widget.correct;
    final total = widget.total;
    final onRetry = widget.onRetry;
    final pct = total == 0 ? 0 : (correct * 100 / total).round();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(pct >= 60 ? Icons.emoji_events : Icons.school,
                size: 64, color: AppColors.accent),
            const SizedBox(height: AppDimensions.md),
            Text('$correct / $total doğru',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppDimensions.xs),
            Text('%$pct  •  +${correct * 5} XP',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppDimensions.lg),
            Wrap(
              spacing: AppDimensions.sm,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tekrar Çöz'),
                  onPressed: onRetry,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Bitir'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NotEnough extends StatelessWidget {
  const _NotEnough();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, size: 48, color: AppColors.primary),
            const SizedBox(height: AppDimensions.md),
            const Text(
              'Bu derste quiz için yeterli videolu kelime yok. '
              'Videolu kelimeler içeren bir ders seç.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.md),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Geri Dön'),
            ),
          ],
        ),
      ),
    );
  }
}
