import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../blocs/settings/settings_cubit.dart';

class _Slide {
  final IconData icon;
  final String title;
  final String body;
  const _Slide(this.icon, this.title, this.body);
}

/// İlk açılışta gösterilen kısa tanıtım.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = <_Slide>[
    _Slide(Icons.sign_language, 'Gerçek işaret videolarıyla öğren',
        'A1\'den C2\'ye 47 ders, 300+ kelime. Her işaretin resmî videosunu izle, "Ayna" ile çevir, yavaşlat, taklit et.'),
    _Slide(Icons.check_circle, 'İşaretle ve ilerlemeni gör',
        'Öğrendiğin kelimeleri "Öğrendim" ile işaretle. İlerleme çubukların dolsun, günlük serini büyüt.'),
    _Slide(Icons.repeat, 'Quiz ve akıllı tekrar',
        'Derslerden quiz çöz. "Bugün Tekrar" öğrendiklerini doğru zamanda karşına getirir, kalıcı olsun.'),
    _Slide(Icons.back_hand, 'El takibi ile pratik yap',
        'Kameranı aç; parmakların canlı izlenir, "Sayı Pratiği" oyunuyla eğlenerek çalış.'),
  ];

  void _finish(BuildContext context) {
    context.read<SettingsCubit>().markOnboardingSeen();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final last = _page == _slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _finish(context),
                child: const Text('Atla'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) {
                  final s = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(s.icon, size: 96, color: AppColors.primary),
                        const SizedBox(height: AppDimensions.xl),
                        Text(s.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center),
                        const SizedBox(height: AppDimensions.md),
                        Text(s.body,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _slides.length; i++)
                  Container(
                    margin: const EdgeInsets.all(4),
                    width: i == _page ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _page
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (last) {
                      _finish(context);
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: Text(last ? 'Başla' : 'Devam'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
