import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Gömülü videosu olmayan işaretler için: kelimeyi güvenilir/resmî sözlükte açar.
///  - SpreadTheSign: kelimeye birebir gider (Avrupa İşaret Dili Merkezi, TİD dahil).
///  - Aile Bakanlığı: T.C. Aile ve Sosyal Hizmetler Bakanlığı Güncel TİD Sözlüğü.
class DictionaryLinks extends StatelessWidget {
  final String word;

  /// Bu işaretin videosuna doğrudan giden bağlantı (ör. parmak alfabesi
  /// harfinin SpreadTheSign sayfası). Boşsa kelime araması kullanılır.
  final String directUrl;

  const DictionaryLinks({super.key, required this.word, this.directUrl = ''});

  String get _spreadTheSignUrl => directUrl.isNotEmpty
      ? directUrl
      : 'https://www.spreadthesign.com/tr.tr/search/?q=${Uri.encodeQueryComponent(word)}';

  String get _aileSozlukUrl => 'https://tidsozluk.aile.gov.tr/';

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
            'Bu işaretin videosu güvenilir sözlükte:',
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
                onPressed: () => _open(context, _aileSozlukUrl),
                icon: const Icon(Icons.account_balance, size: 18),
                label: const Text('Resmî Sözlük (Aile Bakanlığı)'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
