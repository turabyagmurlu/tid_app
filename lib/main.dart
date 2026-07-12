import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/firestore_lesson_datasource.dart';
import 'data/datasources/local_seed_lesson_datasource.dart';
import 'data/repositories/lesson_repository_impl.dart';
import 'domain/repositories/lesson_repository.dart';
import 'firebase_options.dart';
import 'presentation/blocs/lesson/lesson_cubit.dart';
import 'presentation/blocs/progress/progress_cubit.dart';
import 'presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlatmayı dene; yapılandırma yoksa (şablon) yerel seed verisine düş.
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } catch (e) {
    debugPrint('Firebase başlatılamadı, yerel seed verisine düşülüyor: $e');
  }

  final LessonRepository lessonRepository = LessonRepositoryImpl(
    remote: firebaseReady ? FirestoreLessonDataSource() : null,
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
        title: 'TİD Öğren',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
