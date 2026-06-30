import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../engine/game_engine.dart';
import '../models/game_models.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/gradient_progress_bar.dart';
import '../widgets/animated_wave_background.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<GameEngine>();
    return Scaffold(
      appBar: AppBar(title: const Text('🏆 Достижения')),
      body: Stack(children: [
        const AnimatedWaveBackground(child: SizedBox.expand()),
        ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: engine.achievements.length,
          itemBuilder: (context, index) {
            final achievement = engine.achievements[index];
            return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: GlassContainer(padding: const EdgeInsets.all(14), child: _AchievementCard(achievement: achievement)));
          },
        ),
      ]),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(achievement.icon, style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(achievement.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.text)),
          const SizedBox(height: 4),
          Text(achievement.description, style: const TextStyle(color: AppTheme.muted)),
        ])),
        if (achievement.isUnlocked) const Icon(Icons.check_circle, color: Colors.greenAccent) else const SizedBox.shrink(),
      ]),
      const SizedBox(height: 14),
      GradientProgressBar(value: achievement.completion, label: 'Прогресс', startColor: AppTheme.gold, endColor: Colors.greenAccent, percentage: '${(achievement.completion * 100).toStringAsFixed(0)}%'),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('${achievement.progress}/${achievement.target}', style: const TextStyle(color: AppTheme.text)),
        Text('+${achievement.rewardWlnt} WLNT', style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold)),
      ])
    ]);
  }
}
