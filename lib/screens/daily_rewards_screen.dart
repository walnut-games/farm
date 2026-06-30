import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../engine/game_engine.dart';
import '../models/game_models.dart';
import '../widgets/glass_container.dart';
import '../widgets/glow_button.dart';
import '../widgets/animated_wave_background.dart';
import '../theme/app_theme.dart';

class DailyRewardsScreen extends StatelessWidget {
  const DailyRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<GameEngine>();
    return Scaffold(
      appBar: AppBar(title: const Text('Ежедневные награды')),
      body: Stack(children: [
        const AnimatedWaveBackground(child: SizedBox.expand()),
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GlassContainer(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Текущий день', style: TextStyle(color: AppTheme.muted, fontSize: 12)),
                const SizedBox(height: 8),
                Text('День ${engine.currentDailyDay}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.text)),
                const SizedBox(height: 12),
                const Text('Претендуйте на бонусы, обновляя сад каждый день.', style: TextStyle(color: AppTheme.muted)),
              ]),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: engine.dailyRewards.length,
              itemBuilder: (context, index) {
                final reward = engine.dailyRewards[index];
                final isToday = reward.day == engine.currentDailyDay;
                final claimed = reward.isClaimed;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      leading: _rewardIcon(reward),
                      title: Text('День ${reward.day}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.text)),
                      subtitle: Text(_descriptionForReward(reward), style: const TextStyle(color: AppTheme.muted)),
                      trailing: GlowButton(
                        onPressed: isToday && !claimed ? () => engine.claimDailyReward(reward.day) : null,
                        child: Text(claimed ? 'Получено' : isToday ? 'Забрать' : 'Ждите'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _rewardIcon(DailyReward reward) {
    switch (reward.rewardType) {
      case 'wlnt':
        return const CircleAvatar(child: Icon(Icons.currency_bitcoin, color: Colors.amber));
      case 'water':
        return const CircleAvatar(child: Icon(Icons.water_drop, color: Colors.cyan));
      case 'fertilizer':
        return const CircleAvatar(child: Icon(Icons.grass, color: Colors.lightGreen));
      case 'gem':
        return const CircleAvatar(child: Icon(Icons.diamond, color: Colors.purpleAccent));
      default:
        return const CircleAvatar(child: Icon(Icons.card_giftcard));
    }
  }

  String _descriptionForReward(DailyReward reward) {
    switch (reward.rewardType) {
      case 'wlnt':
        return '+${reward.rewardAmount} WLNT';
      case 'water':
        return '+${reward.rewardAmount} Воды';
      case 'fertilizer':
        return '+${reward.rewardAmount} Удобрения';
      case 'gem':
        return '+1 ${reward.rewardAmount}';
      default:
        return 'Награда';
    }
  }
}
