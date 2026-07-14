import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/local_seed_lesson_datasource.dart';
import 'data/datasources/progress_local_datasource.dart';
import 'data/datasources/srs_local_datasource.dart';
import 'data/repositories/lesson_repository_impl.dart';
import 'domain/repositories/lesson_repository.dart';
import 'presentation/blocs/lesson/lesson_cubit.dart';
import 'presentation/blocs/progress/progress_cubit.dart';
import 'presentation/blocs/srs/srs_cubit.dart';
import 'presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // NOT: Firebase yapilandirmasi sablon oldugu icin devre disi; uygulama
  // dogrudan yerel seed verisiyle calisir.
  final LessonRepository lessonRepository = LessonRepositoryImpl(
    remote: null,
    local: const LocalSeedLessonDataSource(),
  );

  runApp(TidApp(
    lessonRepository: lessonRepository,
    progressStore: ProgressLocalDataSource(prefs),
    srsStore: SrsLocalDataSource(prefs),
  ));
}

class TidApp extends StatelessWidget {
  final LessonRepository lessonRepository;
  final ProgressLocalDataSource progressStore;
  final SrsLocalDataSource srsStore;

  const TidApp({
    super.key,
    required this.lessonRepository,
    required this.progressStore,
    required this.srsStore,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LessonCubit(lessonRepository)..loadLessons(),
        ),
        BlocProvider(create: (_) => ProgressCubit(progressStore)..load()),
        BlocProvider(create: (_) => SrsCubit(srsStore)),
      ],
      child: MaterialApp(
        title: 'TID Ogren',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
