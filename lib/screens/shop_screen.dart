import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../engine/game_engine.dart';
import '../theme/app_theme.dart';
import '../widgets/shimmer.dart';
import '../widgets/glass_container.dart';
import '../widgets/glow_button.dart';
import '../widgets/animated_wave_background.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<GameEngine>();
    final items = selectedTab == 0 ? engine.marketTrees : engine.marketGems;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: const Text('Магазин')),
      body: Stack(
        children: [
          const AnimatedWaveBackground(child: SizedBox.expand()),
          RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Магазин', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        SegmentedButton<int>(
                          segments: const [
                            ButtonSegment(value: 0, label: Text('Деревья')),
                            ButtonSegment(value: 1, label: Text('Гемы')),
                          ],
                          selected: {selectedTab},
                          onSelectionChanged: (newSelection) {
                            setState(() => selectedTab = newSelection.first);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...items.isEmpty
                    ? List.generate(3, (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Card(
                            color: AppTheme.panel,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: const Padding(
                              padding: EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppShimmer(height: 18, width: 120),
                                  SizedBox(height: 12),
                                  AppShimmer(height: 14, width: 200),
                                  SizedBox(height: 14),
                                  AppShimmer(height: 36, width: 120),
                                ],
                              ),
                            ),
                          ),
                        ))
                    : List.generate(items.length, (index) {
                        final item = items[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: GlassContainer(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 6),
                                      Text(item.description, style: const TextStyle(color: AppTheme.muted)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${item.price} WLNT', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.gold)),
                                    const SizedBox(height: 8),
                                    GlowButton(
                                      onPressed: () {
                                        if (selectedTab == 0) {
                                          engine.buyTree(item);
                                        } else {
                                          engine.buyGem(item);
                                        }
                                      },
                                      child: const Text('Купить'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
