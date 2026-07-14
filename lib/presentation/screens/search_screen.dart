import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/lesson_model.dart';
import '../../data/models/word_model.dart';
import '../blocs/lesson/lesson_cubit.dart';
import '../blocs/progress/progress_cubit.dart';
import 'lesson_detail_screen.dart';

/// Tüm kelimelerde arama yapan ekran.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  String _norm(String s) => s.toLowerCase().replaceAll('i̇', 'i');

  @override
  Widget build(BuildContext context) {
    final ls = context.watch<LessonCubit>().state;
    final List<LessonModel> lessons =
        ls is LessonLoaded ? ls.lessons : const [];

    final q = _norm(_query.trim());
    final results = <MapEntry<WordModel, LessonModel>>[];
    if (q.isNotEmpty) {
      for (final l in lessons) {
        for (final w in l.words) {
          if (_norm(w.turkishWord).contains(q)) {
            results.add(MapEntry(w, l));
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Kelime ara…',
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 18),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: SafeArea(
        child: q.isEmpty
            ? const _Hint()
            : results.isEmpty
                ? const Center(child: Text('Sonuç bulunamadı.'))
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, i) {
                      final w = results[i].key;
                      final l = results[i].value;
                      return BlocBuilder<ProgressCubit, ProgressState>(
                        builder: (context, ps) {
                          final fav =
                              ps.progress.favoriteWordIds.contains(w.wordId);
                          return ListTile(
                            leading: const Icon(Icons.sign_language,
                                color: AppColors.primary),
                            title: Text(w.turkishWord),
                            subtitle: Text('${l.level} · ${l.title}'),
                            trailing: IconButton(
                              icon: Icon(
                                fav ? Icons.star : Icons.star_border,
                                color: fav ? AppColors.accent : null,
                              ),
                              onPressed: () => context
                                  .read<ProgressCubit>()
                                  .toggleFavorite(w.wordId),
                            ),
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
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

class _Hint extends StatelessWidget {
  const _Hint();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.lg),
        child: Text(
          'İşaretini öğrenmek istediğin kelimeyi yaz.\n'
          'Örn: "anne", "su", "kırmızı"…',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
