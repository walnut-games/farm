import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../engine/game_engine.dart';
import '../models/game_models.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/glow_button.dart';
import '../widgets/gradient_progress_bar.dart';

class TreeDetailScreen extends StatelessWidget {
  final String treeId;

  const TreeDetailScreen({super.key, required this.treeId});

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<GameEngine>();
    final tree = engine.ownedTrees.firstWhere((tree) => tree.id == treeId);

    return Scaffold(
      appBar: AppBar(
        title: Text(tree.name, style: Theme.of(context).textTheme.headlineSmall),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
      ),
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient)),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'tree-${tree.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Image.network(
                      'https://picsum.photos/seed/${tree.id}/600/320',
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GlassContainer(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_graph_rounded, color: AppTheme.gold, size: 28),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(tree.stageLabel, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.text)),
                          ),
                          Container(
                            decoration: BoxDecoration(color: AppTheme.gold.withAlpha(46), borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            child: Text(tree.rarity.title, style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      GradientProgressBar(value: tree.humidityProgress, label: 'Влажность', startColor: Colors.cyanAccent, endColor: Colors.blueAccent, percentage: '${tree.humidity}%'),
                      const SizedBox(height: 14),
                      GradientProgressBar(value: tree.durabilityProgress, label: 'Прочность', startColor: Colors.orangeAccent, endColor: Colors.redAccent, percentage: '${tree.durability}%'),
                      const SizedBox(height: 18),
                      Row(children: [const Icon(Icons.bug_report, color: AppTheme.neon), const SizedBox(width: 8), Text('Гусениц: ${tree.caterpillars}', style: const TextStyle(color: AppTheme.text))]),
                      const SizedBox(height: 18),
                      Wrap(spacing: 12, runSpacing: 12, children: List.generate(4, (index) {
                        final slot = index < tree.openSlots ? 'Открыт' : 'Закрыт';
                        final gem = tree.gemSlots[index]?.name ?? '-';
                        return Chip(
                          backgroundColor: index < tree.openSlots ? AppTheme.accent.withAlpha(36) : Colors.white10,
                          label: Text('Слот ${index + 1}: $slot\n$gem', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppTheme.text)),
                        );
                      })),
                      const SizedBox(height: 16),
                      Text('Описание', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Это древнее дерево обеспечит стабильный поток WLNT и уникальные гемовые слоты. Поддерживайте его влажность и прочность, чтобы собирать редкий урожай.', style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GlassContainer(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Действия', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.text, fontSize: 18)),
                      const SizedBox(height: 14),
                      GlowButton(
                        onPressed: tree.status == TreeStatus.growth ? () {
                          engine.waterTree(tree.id);
                          Navigator.pop(context);
                        } : null,
                        soundAsset: 'audio/water.mp3',
                        particleType: 'water',
                        child: const Text('Полить'),
                      ),
                      const SizedBox(height: 12),
                      GlowButton(
                        onPressed: tree.status == TreeStatus.growth ? () {
                          engine.fightCaterpillars(tree.id);
                          Navigator.pop(context);
                        } : null,
                        soundAsset: 'audio/bird.mp3',
                        particleType: 'dust',
                        child: const Text('Убрать гусениц'),
                      ),
                      const SizedBox(height: 12),
                      GlowButton(
                        onPressed: tree.status == TreeStatus.rest ? () {
                          engine.collectHarvest(tree.id);
                          Navigator.pop(context);
                        } : null,
                        soundAsset: 'audio/coin.mp3',
                        particleType: 'coins',
                        child: const Text('Собрать'),
                      ),
                      const SizedBox(height: 12),
                      GlowButton(
                        onPressed: () {
                          engine.burnTree(tree.id);
                          Navigator.pop(context);
                        },
                        soundAsset: 'audio/burn.mp3',
                        particleType: 'embers',
                        child: const Text('Сжечь'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
