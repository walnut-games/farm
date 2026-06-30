import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../engine/game_engine.dart';
import '../models/game_models.dart';
import '../widgets/shimmer.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/glow_button.dart';
import '../widgets/animated_wave_background.dart';
import 'achievements_screen.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<GameEngine>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: const Text('Инвентарь'), actions: [
        IconButton(
          icon: const Icon(Icons.emoji_events),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsScreen())),
        ),
      ]),
      body: Stack(
        children: [
          const AnimatedWaveBackground(child: SizedBox.expand()),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const GlassContainer(padding: EdgeInsets.all(14), child: Text('Деревья', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.text))),
              const SizedBox(height: 12),
              if (engine.ownedTrees.isEmpty) ...List.generate(
                3,
                (_) => const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: AppShimmer(height: 70, width: double.infinity)),
              )
              else
                ...engine.ownedTrees.map((tree) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GlassContainer(
                        padding: const EdgeInsets.all(12),
                        child: ListTile(
                          title: Text(tree.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Редкость: ${tree.rarity.title}'),
                          trailing: Text(tree.status == TreeStatus.rest ? 'Покой' : 'Рост'),
                        ),
                      ),
                    )),
              const SizedBox(height: 20),
              const GlassContainer(padding: EdgeInsets.all(14), child: Text('Гемы', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.text))),
              const SizedBox(height: 12),
              if (engine.gemInventory.where((gem) => gem.count > 0).isEmpty) ...List.generate(
                3,
                (_) => const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: AppShimmer(height: 70, width: double.infinity)),
              )
              else
                ...engine.gemInventory.where((gem) => gem.count > 0).map((gem) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GlassContainer(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${gem.name} x${gem.count}', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text('Продать за ${gem.sellValue} WLNT или улучшить 3→1', style: const TextStyle(color: AppTheme.muted))])),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                GlowButton(onPressed: gem.count >= 3 ? () => engine.upgradeGem(gem.type, gem.level) : null, child: const Text('Ул.')),
                                const SizedBox(height: 8),
                                GlowButton(onPressed: () => engine.sellGem(gem.type, gem.level), child: const Text('Продать')),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
              const SizedBox(height: 20),
              GlassContainer(
                padding: const EdgeInsets.all(12),
                child: ListTile(
                  title: const Text('Ресурсы'),
                  subtitle: Text('Вода: ${engine.itemInventory['water_unit']}  •  Удобрения: ${engine.itemInventory['fertilizer_unit']}  •  Птицы: ${engine.itemInventory['bird_unit']}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
