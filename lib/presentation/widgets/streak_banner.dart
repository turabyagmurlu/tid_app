import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import 'gradient_hero_card.dart';

/// Günlük seri (streak) — sıcak, parıltılı gradyan hero kart.
class StreakBanner extends StatelessWidget {
  final int streak;
  const StreakBanner({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return GradientHeroCard(
      icon: Icons.local_fire_department,
      title: '$streak günlük seri',
      subtitle: AppStrings.dailyGoal,
      colors: const [Color(0xFFFB7185), Color(0xFFF59E0B)],
      trailing: streak > 0
          ? Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.22),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text('$streak',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900)),
            )
          : null,
    );
  }
}
