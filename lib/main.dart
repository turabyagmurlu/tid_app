import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/local_seed_lesson_datasource.dart';
import 'data/repositories/lesson_repository_impl.dart';
import 'domain/repositories/lesson_repository.dart';
import 'presentation/blocs/lesson/lesson_cubit.dart';
import 'presentation/blocs/progress/progress_cubit.dart';
import 'presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NOT: Firebase yapilandirmasi sablon (yer tutucu) oldugu icin simdilik
  // devre disi; uygulama dogrudan yerel seed verisiyle calisir. Gercek Firebase
  // eklenince remote kaynagi yeniden baglanabilir.
  final LessonRepository lessonRepository = LessonRepositoryImpl(
    remote: null,
    local: const LocalSeedLessonDataSource(),
  );

  runApp(TidApp(lessonRepository: lessonRepository));
}

class TidApp extends StatelessWidget {
  final LessonRepository lessonRepository;
  const TidApp({super.key, required this.lessonRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LessonCubit(lessonRepository)..loadLessons(),
        ),
        BlocProvider(create: (_) => ProgressCubit()..load()),
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
