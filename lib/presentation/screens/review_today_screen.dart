import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../blocs/lesson/lesson_cubit.dart';
import '../blocs/progress/progress_cubit.dart';
import '../blocs/srs/srs_cubit.dart';
import '../widgets/dual_video_player.dart';

/// "Bugün Tekrar": aralıklı tekrar (SRS) destesinden vadesi gelen kelimeleri
/// video + "Hatırladım / Zor / Hatırlamadım" akışıyla gösterir.
class ReviewTodayScreen extends StatefulWidget {
  const ReviewTodayScreen({super.key});

  @override
  State<ReviewTodayScreen> createState() => _ReviewTodayScreenState();
}

class _ReviewTodayScreenState extends State<ReviewTodayScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lessonState = context.read<LessonCubit>().state;
      final learned = context.read<ProgressCubit>().state.progress.learnedWordIds;
      if (lessonState is LessonLoaded) {
        context.read<SrsCubit>().loadDue(lessonState.lessons, learned);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bugün Tekrar')),
      body: SafeArea(
        child: BlocBuilder<SrsCubit, SrsState>(
          builder: (context, state) {
            if (state.finished) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<ProgressCubit>().registerStudyToday();
              });
              return _Done(reviewed: state.total);
            }
            final w = state.current;
            if (w == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final variant = w.regionalVariants.first;
            return ListView(
              padding: const EdgeInsets.all(AppDimensions.md),
              children: [
                LinearProgressIndicator(
                  value: state.total == 0 ? 0 : (state.index + 1) / state.total,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                ),
                const SizedBox(height: AppDimensions.sm),
                Text('${state.index + 1} / ${state.total}',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppDimensions.sm),
                Text(w.turkishWord,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppDimensions.md),
                DualVideoPlayer(
                  key: ValueKey('srs_${w.wordId}'),
                  fullBodyUrl: variant.videoFullBody,
                  lipCloseupUrl: variant.videoLipCloseups,
                ),
                const SizedBox(height: AppDimensions.md),
                Text('İşareti hatırladın mı?',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: [
                    Expanded(
                      child: _GradeButton(
                        label: 'Hatırlamadım',
                        color: AppColors.error,
                        onTap: () => context.read<SrsCubit>().grade(1),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: _GradeButton(
                        label: 'Zor',
                        color: AppColors.warning,
                        onTap: () => context.read<SrsCubit>().grade(3),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: _GradeButton(
                        label: 'Hatırladım',
                        color: AppColors.success,
                        onTap: () => context.read<SrsCubit>().grade(5),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GradeButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _GradeButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
      ),
      child: Text(label, textAlign: TextAlign.center),
    );
  }
}

class _Done extends StatelessWidget {
  final int reviewed;
  const _Done({required this.reviewed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.done_all, size: 64, color: AppColors.success),
            const SizedBox(height: AppDimensions.md),
            Text(
              reviewed == 0
                  ? 'Bugün tekrar edilecek kelime yok.\nYeni kelimeler öğrenip "Öğrendim" işaretle!'
                  : 'Bugünkü tekrar bitti! 🎉',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.lg),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ana Sayfa'),
            ),
          ],
        ),
      ),
    );
  }
}
