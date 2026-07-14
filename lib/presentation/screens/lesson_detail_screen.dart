import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/lesson_model.dart';
import '../../data/models/regional_variant_model.dart';
import '../../data/models/word_model.dart';
import '../blocs/progress/progress_cubit.dart';
import '../widgets/dictionary_links.dart';
import '../widgets/dual_video_player.dart';
import '../widgets/grammar_quiz_widget.dart';
import 'camera_practice_screen.dart';
import 'quiz_screen.dart';

/// Ders detay ekranı: her işaret için (gömülü gerçek video varsa) çift açılı
/// oynatıcı; yoksa güvenilir sözlükte gerçek işaret videosuna yönlendiren
/// butonlar. Ayrıca bölgesel varyant seçici, hatırlatıcı ipucu ve ayna modu.
class LessonDetailScreen extends StatelessWidget {
  final LessonModel lesson;
  const LessonDetailScreen({super.key, required this.lesson});

  bool get _isGrammar =>
      lesson.module.toLowerCase().contains('gramer') ||
      lesson.level.startsWith('B');

  @override
  Widget build(BuildContext context) {
    final hasQuiz = lesson.words
            .where((w) =>
                w.regionalVariants.isNotEmpty &&
                w.regionalVariants.first.videoFullBody.trim().isNotEmpty)
            .length >=
        2;
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        actions: [
          if (hasQuiz)
            IconButton(
              tooltip: 'Quiz Başlat',
              icon: const Icon(Icons.quiz),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => QuizScreen(lesson: lesson),
              )),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.md),
          children: [
            _LevelPill(level: lesson.level, module: lesson.module),
            const SizedBox(height: AppDimensions.md),
            if (hasQuiz) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.quiz),
                  label: const Text('Bu Dersten Quiz Çöz'),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => QuizScreen(lesson: lesson),
                  )),
                ),
              ),
              const SizedBox(height: AppDimensions.md),
            ],
            for (final word in lesson.words) ...[
              _WordSection(word: word),
              const Divider(height: AppDimensions.xl),
            ],
            if (_isGrammar) ...[
              Text(AppStrings.quizTitle,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppDimensions.sm),
              const GrammarQuizWidget(
                correctTidOrder: ['YARIN', 'BEN', 'OKUL', 'GİTMEK'],
                scrambledWords: ['GİTMEK', 'YARIN', 'OKUL', 'BEN'],
                promptTurkish: 'Ben yarın okula gideceğim.',
              ),
              const SizedBox(height: AppDimensions.xl),
            ],
            BlocBuilder<ProgressCubit, ProgressState>(
              builder: (context, ps) {
                final done =
                    ps.progress.completedLessonIds.contains(lesson.lessonId);
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(done ? Icons.check_circle : Icons.done),
                    label: Text(done ? 'Ders Tamamlandı ✓' : 'Dersi Tamamla'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: done ? AppColors.success : null,
                      foregroundColor: done ? Colors.white : null,
                    ),
                    onPressed: done
                        ? null
                        : () {
                            context
                                .read<ProgressCubit>()
                                .completeLesson(lesson.lessonId);
                            context
                                .read<ProgressCubit>()
                                .registerStudyToday();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ders tamamlandı! +10 XP'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                  ),
                );
              },
            ),
            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }
}

class _LevelPill extends StatelessWidget {
  final String level;
  final String module;
  const _LevelPill({required this.level, required this.module});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Text(
            level,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: Text(module, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _WordSection extends StatefulWidget {
  final WordModel word;
  const _WordSection({required this.word});

  @override
  State<_WordSection> createState() => _WordSectionState();
}

class _WordSectionState extends State<_WordSection> {
  int _variantIndex = 0;

  @override
  Widget build(BuildContext context) {
    final word = widget.word;
    final variants = word.regionalVariants;
    final RegionalVariant? variant =
        variants.isNotEmpty ? variants[_variantIndex] : null;

    // Gömülü gerçek video var mı? (Boş/eksik URL'lerde sözlüğe yönlendirilir.)
    final bool hasRealVideo =
        variant != null && variant.videoFullBody.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(word.turkishWord,
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            if (word.facialExpressionRequired) const _FacialBadge(),
          ],
        ),
        const SizedBox(height: AppDimensions.xs),
        Align(
          alignment: Alignment.centerLeft,
          child: BlocBuilder<ProgressCubit, ProgressState>(
            builder: (context, ps) {
              final learned =
                  ps.progress.learnedWordIds.contains(word.wordId);
              return FilterChip(
                selected: learned,
                onSelected: (_) => context
                    .read<ProgressCubit>()
                    .toggleWordLearned(word.wordId),
                avatar: Icon(
                  learned
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 18,
                  color: learned ? Colors.white : null,
                ),
                label: Text(learned ? 'Öğrendim' : 'Öğrendim mi?'),
                selectedColor: AppColors.success,
                labelStyle: TextStyle(color: learned ? Colors.white : null),
              );
            },
          ),
        ),
        if (word.tidGrammarNote.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.xs),
          Text(word.tidGrammarNote,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
        const SizedBox(height: AppDimensions.md),

        // Gömülü gerçek video varsa oynat; yoksa sözlük butonlarını göster.
        if (hasRealVideo) ...[
          if (variants.length > 1)
            _VariantSelector(
              variants: variants,
              selected: _variantIndex,
              onChanged: (i) => setState(() => _variantIndex = i),
            ),
          if (variants.length > 1) const SizedBox(height: AppDimensions.sm),
          DualVideoPlayer(
            key: ValueKey('${word.wordId}_${variant!.region}'),
            fullBodyUrl: variant.videoFullBody,
            lipCloseupUrl: variant.videoLipCloseups,
          ),
        ] else
          DictionaryLinks(
            word: word.turkishWord,
            directUrl: word.dictionaryUrl,
          ),

        const SizedBox(height: AppDimensions.md),

        if (word.mnemonicTip.isNotEmpty) _MnemonicCard(tip: word.mnemonicTip),
        const SizedBox(height: AppDimensions.md),

        if (hasRealVideo && variant != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.videocam),
              label: const Text(AppStrings.practiceInMirror),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    CameraPracticeScreen(word: word, variant: variant),
              )),
            ),
          ),
      ],
    );
  }
}

class _VariantSelector extends StatelessWidget {
  final List<RegionalVariant> variants;
  final int selected;
  final ValueChanged<int> onChanged;

  const _VariantSelector({
    required this.variants,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.sm,
      children: [
        for (int i = 0; i < variants.length; i++)
          ChoiceChip(
            label: Text(variants[i].region),
            selected: selected == i,
            onSelected: (_) => onChanged(i),
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              color: selected == i ? Colors.white : null,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class _FacialBadge extends StatelessWidget {
  const _FacialBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: AppColors.warning),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sentiment_satisfied_alt,
              size: 16, color: AppColors.warning),
          SizedBox(width: 4),
          Text(AppStrings.facialRequired,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MnemonicCard extends StatelessWidget {
  final String tip;
  const _MnemonicCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.accent.withOpacity(0.12),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: AppColors.accent),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.mnemonicTitle,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(tip, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
