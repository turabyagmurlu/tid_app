import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/lesson_model.dart';
import '../../data/models/word_model.dart';
import '../blocs/lesson/lesson_cubit.dart';
import '../blocs/progress/progress_cubit.dart';
import 'lesson_detail_screen.dart';

/// Favori (yıldızlı) kelimeler ekranı.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ls = context.watch<LessonCubit>().state;
    final List<LessonModel> lessons =
        ls is LessonLoaded ? ls.lessons : const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Favorilerim')),
      body: SafeArea(
        child: BlocBuilder<ProgressCubit, ProgressState>(
          builder: (context, ps) {
            final favIds = ps.progress.favoriteWordIds;
            final items = <MapEntry<WordModel, LessonModel>>[];
            for (final l in lessons) {
              for (final w in l.words) {
                if (favIds.contains(w.wordId)) items.add(MapEntry(w, l));
              }
            }
            if (items.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.lg),
                  child: Text(
                    'Henüz favori yok.\n'
                    'Kelime kartındaki ⭐ ile favorilere ekle.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                final w = items[i].key;
                final l = items[i].value;
                return ListTile(
                  leading: const Icon(Icons.star, color: AppColors.accent),
                  title: Text(w.turkishWord),
                  subtitle: Text('${l.level} · ${l.title}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Favoriden çıkar',
                    onPressed: () =>
                        context.read<ProgressCubit>().toggleFavorite(w.wordId),
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => LessonDetailScreen(lesson: l),
                  )),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
