import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Bir kelimenin GERÇEK TİD işaret videosunu güvenilir/resmî sözlüklerde açar.
///
/// Not: Telif nedeniyle videolar uygulamaya gömülmez; kullanıcı doğrudan
/// kaynağa yönlendirilir. Web'de yeni sekmede açılır.
///  - SpreadTheSign: kelimeye birebir gider (Avrupa İşaret Dili Merkezi, TİD dahil).
///  - Resmî Sözlük: T.C. Aile ve Sosyal Hizmetler Bakanlığı Güncel TİD Sözlüğü.
class DictionaryLinks extends StatelessWidget {
  final String word;
  const DictionaryLinks({super.key, required this.word});

  String get _spreadTheSignUrl =>
      'https://www.spreadthesign.com/tr.tr/search/?q=${Uri.encodeQueryComponent(word)}';

  String get _resmiSozlukUrl => 'https://tidsozluk.aile.gov.tr/';

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bağlantı açılamadı.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sign_language, color: AppColors.primary),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Text(
                  '“$word” işaretini izle',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            'Gerçek TİD videosu için güvenilir sözlükte aç:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppDimensions.md),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: [
              ElevatedButton.icon(
                onPressed: () => _open(context, _spreadTheSignUrl),
                icon: const Icon(Icons.play_circle_outline, size: 18),
                label: const Text('İşaret videosu (SpreadTheSign)'),
              ),
              OutlinedButton.icon(
                onPressed: () => _open(context, _resmiSozlukUrl),
                icon: const Icon(Icons.account_balance, size: 18),
                label: const Text('Resmî Sözlük'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
