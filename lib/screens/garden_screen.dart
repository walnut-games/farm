import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../engine/game_engine.dart';
import '../models/game_models.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_wave_background.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/glass_container.dart';
import '../widgets/glow_button.dart';
import '../widgets/particle_effect.dart';
import '../widgets/parallax_garden_background.dart';
import '../widgets/tree_card.dart';
import 'daily_rewards_screen.dart';
import 'tree_detail_screen.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key});

  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _backgroundController;
  bool _showActionPanel = true;
  String? _particleType;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  void _triggerParticle(String type) {
    setState(() => _particleType = type);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _particleType = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<GameEngine>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сад'),
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DailyRewardsScreen()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('${engine.wlntBalance} WLNT')),
          )
        ],
      ),
      body: Stack(
        children: [
          ParallaxGardenBackground(animation: _backgroundController),
          const AnimatedWaveBackground(child: SizedBox.expand()),
          if (_particleType != null) Positioned.fill(child: ParticleEffect(type: _particleType!)),
          RefreshIndicator(
            onRefresh: () async {
              engine.advanceDay();
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Сад', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.text)),
                            SizedBox(height: 4),
                            Text('Управляй ростом, урожаем и стратегией NFT', style: TextStyle(color: AppTheme.muted, fontSize: 13)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppTheme.panelAlt,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.currency_exchange, color: AppTheme.gold, size: 18),
                              const SizedBox(width: 8),
                              Text('${engine.wlntBalance} WLNT', style: const TextStyle(color: AppTheme.text, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _weatherBanner(engine.currentWeather),
                const SizedBox(height: 16),
                AnimatedOpacity(
                  opacity: _showActionPanel ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => setState(() => _showActionPanel = !_showActionPanel),
                          icon: const Icon(Icons.visibility),
                          label: Text(_showActionPanel ? 'Скрыть панель' : 'Показать панель'),
                        ),
                        ElevatedButton(
                          onPressed: engine.advanceDay,
                          child: const Text('Следующий день'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Рост', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ...engine.growingTrees.map((tree) => _AnimatedCardButton(
                      child: TreeCard(
                        tree: tree,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TreeDetailScreen(treeId: tree.id)),
                        ),
                        onWater: () {
                          _triggerParticle('water');
                          engine.waterTree(tree.id);
                        },
                        onDust: () {
                          _triggerParticle('dust');
                          engine.fightCaterpillars(tree.id);
                        },
                        onHarvest: () {
                          _triggerParticle('coins');
                          engine.collectHarvest(tree.id);
                        },
                      ),
                    )),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Покой', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ...engine.restingTrees.map((tree) => _AnimatedCardButton(
                      child: TreeCard(
                        tree: tree,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TreeDetailScreen(treeId: tree.id)),
                        ),
                        onWater: () {
                          _triggerParticle('water');
                          engine.waterTree(tree.id);
                        },
                        onDust: () {
                          _triggerParticle('dust');
                          engine.fightCaterpillars(tree.id);
                        },
                        onHarvest: () {
                          _triggerParticle('coins');
                          engine.collectHarvest(tree.id);
                        },
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherBanner(WeatherType weather) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        padding: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${weather.emoji} ${weather.label}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.text)),
                const SizedBox(height: 6),
                const Text('Потяните вниз, чтобы сменить день', style: TextStyle(color: AppTheme.muted, fontSize: 12)),
              ],
            ),
            GlowButton(
              onPressed: () {
                setState(() => _showActionPanel = !_showActionPanel);
              },
              child: Text(_showActionPanel ? 'Скрыть панель' : 'Показать панель'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionSheet extends StatefulWidget {
  final TreeModel tree;
  final VoidCallback onWater;
  final VoidCallback onDust;
  final VoidCallback onHarvest;

  const _ActionSheet({required this.tree, required this.onWater, required this.onDust, required this.onHarvest});

  @override
  State<_ActionSheet> createState() => _ActionSheetState();
}

class _ActionSheetState extends State<_ActionSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _sheetController;

  @override
  void initState() {
    super.initState();
    _sheetController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _sheetController.forward();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _sheetController, curve: Curves.easeOutBack),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.tree.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Стадия: ${widget.tree.stageLabel}'),
            const SizedBox(height: 12),
              Wrap(spacing: 12, runSpacing: 12, children: [
              _AnimatedActionButton(label: 'Полить', icon: Icons.water_drop, onTap: widget.tree.status == TreeStatus.growth ? widget.onWater : null, soundAsset: 'audio/water.mp3', particleType: 'water'),
              _AnimatedActionButton(label: 'Убрать гусениц', icon: Icons.travel_explore, onTap: widget.tree.status == TreeStatus.growth ? widget.onDust : null, soundAsset: 'audio/bird.mp3', particleType: 'dust'),
              _AnimatedActionButton(label: 'Собрать', icon: Icons.check, onTap: widget.tree.status == TreeStatus.rest ? widget.onHarvest : null, soundAsset: 'audio/coin.mp3', particleType: 'coins'),
              _AnimatedActionButton(label: 'Сжечь', icon: Icons.fireplace, onTap: () {
                context.read<GameEngine>().burnTree(widget.tree.id);
                Navigator.pop(context);
              }, soundAsset: 'audio/burn.mp3', particleType: 'embers'),
            ]),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCardButton extends StatefulWidget {
  final Widget child;

  const _AnimatedCardButton({required this.child});

  @override
  State<_AnimatedCardButton> createState() => _AnimatedCardButtonState();
}

class _AnimatedCardButtonState extends State<_AnimatedCardButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}

class _AnimatedActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final String? soundAsset;
  final String? particleType;

  const _AnimatedActionButton({required this.label, required this.icon, this.onTap, this.soundAsset, this.particleType});

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: () {
        // play optional sound and show particle overlay
        try {
          if (widget.soundAsset != null) {
            final player = AudioPlayer();
            player.play(AssetSource(widget.soundAsset!));
          }
        } catch (_) {}
        final maybeOverlay = Overlay.of(context);
        if (maybeOverlay != null && widget.particleType != null) {
          final overlay = OverlayEntry(builder: (context) => Positioned.fill(child: ParticleEffect(type: widget.particleType!)));
          maybeOverlay.insert(overlay);
          Future.delayed(const Duration(milliseconds: 900), () => overlay.remove());
        }
        widget.onTap?.call();
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: ElevatedButton.icon(
          icon: Icon(widget.icon),
          label: Text(widget.label),
          onPressed: widget.onTap,
        ),
      ),
    );
  }
}
