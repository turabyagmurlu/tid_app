import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';

/// TİD Özne-Nesne-Yüklem dizilimini öğreten sıralama alıştırması (Bölüm 6-B).
/// Kullanıcı seçenek havuzundan kelimeleri seçerek cevap alanını doldurur.
class GrammarQuizWidget extends StatefulWidget {
  final List<String> correctTidOrder; // ["YARIN","BEN","OKUL","GİTMEK"]
  final List<String> scrambledWords;
  final String? promptTurkish; // İsteğe bağlı Türkçe cümle ipucu

  const GrammarQuizWidget({
    super.key,
    required this.correctTidOrder,
    required this.scrambledWords,
    this.promptTurkish,
  });

  @override
  State<GrammarQuizWidget> createState() => _GrammarQuizWidgetState();
}

class _GrammarQuizWidgetState extends State<GrammarQuizWidget> {
  final List<String> _answers = [];
  bool? _lastResult;

  void _add(String w) => setState(() {
        _answers.add(w);
        _lastResult = null;
      });

  void _remove(String w) => setState(() {
        _answers.remove(w);
        _lastResult = null;
      });

  void _reset() => setState(() {
        _answers.clear();
        _lastResult = null;
      });

  void _check() {
    final ok = _answers.length == widget.correctTidOrder.length &&
        List.generate(
          _answers.length,
          (i) => _answers[i] == widget.correctTidOrder[i],
        ).every((e) => e);

    setState(() => _lastResult = ok);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(ok ? AppStrings.correctOrder : AppStrings.wrongOrder),
        backgroundColor: ok ? AppColors.success : AppColors.error,
      ));
  }

  @override
  Widget build(BuildContext context) {
    final remaining =
        widget.scrambledWords.where((w) => !_answers.contains(w)).toList();
    final borderColor = _lastResult == null
        ? AppColors.primary
        : (_lastResult! ? AppColors.success : AppColors.error);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.quizPrompt,
            style: Theme.of(context).textTheme.titleMedium),
        if (widget.promptTurkish != null) ...[
          const SizedBox(height: AppDimensions.xs),
          Text(
            'Türkçe: “${widget.promptTurkish}”',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
        const SizedBox(height: AppDimensions.md),

        // Cevap alanı — Container(minHeight) yerine BoxConstraints kullanıldı.
        Container(
          constraints: const BoxConstraints(minHeight: 64),
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.sm),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: _answers.isEmpty
              ? Text(
                  AppStrings.emptyAnswerHint,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                )
              : Wrap(
                  spacing: AppDimensions.sm,
                  runSpacing: AppDimensions.xs,
                  children: [
                    for (int i = 0; i < _answers.length; i++)
                      InputChip(
                        label: Text('${i + 1}. ${_answers[i]}'),
                        onDeleted: () => _remove(_answers[i]),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: AppDimensions.md),

        // Seçenek havuzu
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.xs,
          children: [
            for (final w in remaining)
              ActionChip(
                label: Text(w),
                avatar: const Icon(Icons.add, size: 18),
                onPressed: () => _add(w),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.lg),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _answers.isEmpty ? null : _check,
                icon: const Icon(Icons.check),
                label: const Text(AppStrings.check),
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            OutlinedButton(
              onPressed: _answers.isEmpty ? null : _reset,
              child: const Text(AppStrings.clear),
            ),
          ],
        ),
      ],
    );
  }
}
