import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../engine/game_engine.dart';
import '../models/game_models.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/glow_button.dart';
import '../widgets/animated_wave_background.dart';

class LuckScreen extends StatelessWidget {
  const LuckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<GameEngine>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: const Text('Удача')),
      body: Stack(
        children: [
          const AnimatedWaveBackground(child: SizedBox.expand()),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const GlassContainer(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Сжигать активы', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.text)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassContainer(
                child: ExpansionTile(
                  leading: const Icon(Icons.local_fire_department, color: AppTheme.gold),
                  title: const Text('Сжечь гемы'),
                  subtitle: const Text('Получите WLNT за каждый гем.'),
                  children: engine.gemInventory.where((gem) => gem.count > 0).map((gem) {
                    return ListTile(
                      title: Text('${gem.name} x${gem.count}'),
                      subtitle: Text('Сжигая вы получите ${gem.sellValue * 2} WLNT'),
                      trailing: GlowButton(
                        onPressed: () => engine.burnGem(gem.type, gem.level),
                        child: const Text('Сжечь'),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              GlassContainer(
                child: ExpansionTile(
                  leading: const Icon(Icons.whatshot, color: Colors.orangeAccent),
                  title: const Text('Сжечь деревья'),
                  subtitle: const Text('Получите WLNT и удобрения за лишние NFT-деревья.'),
                  children: engine.ownedTrees.map((tree) {
                    return ListTile(
                      title: Text(tree.name),
                      subtitle: Text('Редкость: ${tree.rarity.title} • Стадия: ${tree.stageLabel}'),
                      trailing: GlowButton(
                        onPressed: () => engine.burnTree(tree.id),
                        child: const Text('Сжечь'),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Казино', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Text('Рулетка 100 WLNT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Результат: ${engine.lastRoulette}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    GlowButton(
                      onPressed: engine.wlntBalance >= 100 ? () => engine.playRoulette() : null,
                      child: const Text('Сделать ставку'),
                    ),
                    const SizedBox(height: 16),
                    const Text('Таблица выигрышей', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _buildOddsRow('5%', '+600 WLNT'),
                    _buildOddsRow('20%', '+220 WLNT'),
                    _buildOddsRow('35%', '+120 WLNT'),
                    _buildOddsRow('25%', '+80 WLNT'),
                    _buildOddsRow('15%', 'Програл'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOddsRow(String chance, String prize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(chance), Text(prize)],
      ),
    );
  }
}
