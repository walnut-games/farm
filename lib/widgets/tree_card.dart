import 'package:flutter/material.dart';
import '../models/game_models.dart';
import 'shimmer.dart';

class TreeCard extends StatelessWidget {
  final TreeModel tree;
  final VoidCallback onTap;
  final VoidCallback? onWater;
  final VoidCallback? onDust;
  final VoidCallback? onHarvest;

  const TreeCard({super.key, required this.tree, required this.onTap, this.onWater, this.onDust, this.onHarvest});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.97, end: 1.0),
      duration: const Duration(milliseconds: 320),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(tree.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                    child: _statusIcon(tree.status),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _HoverImage(url: 'https://picsum.photos/seed/${tree.id}/280/140', height: 140, borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 12),
              _statRow('Влажность', tree.humidityProgress, Colors.cyan, '${tree.humidity}%'),
              const SizedBox(height: 8),
              _statRow('Прочность', tree.durabilityProgress, Colors.orange, '${tree.durability}%'),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.bug_report, size: 16, color: Colors.greenAccent),
                  const SizedBox(width: 6),
                  Text('Гусениц: ${tree.caterpillars}'),
                  const Spacer(),
                  Text('День: ${tree.dayInStage}/30'),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(4, (index) {
                  final slot = index < tree.openSlots ? 'Открыт' : 'Закрыт';
                  final gem = tree.gemSlots[index]?.name ?? '-';
                  return Chip(
                    label: Text('Слот ${index + 1}: $slot\n$gem', textAlign: TextAlign.center),
                    backgroundColor: index < tree.openSlots ? Colors.green.shade900 : Colors.grey.shade800,
                  );
                }),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (tree.status == TreeStatus.growth)
                    _ActionIconButton(
                      icon: Icons.water_drop,
                      label: 'Полить',
                      onTap: onWater,
                    ),
                  if (tree.status == TreeStatus.growth)
                    _ActionIconButton(
                      icon: Icons.travel_explore,
                      label: 'Гусениц',
                      onTap: onDust,
                    ),
                  if (tree.status == TreeStatus.rest)
                    _ActionIconButton(
                      icon: Icons.check,
                      label: 'Собрать',
                      onTap: onHarvest,
                    ),
                ],
              ),
            ],
          ),
        ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, double progress, Color color, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: progress, color: color, backgroundColor: Colors.white12),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _statusIcon(TreeStatus status) {
    switch (status) {
      case TreeStatus.growth:
        return const Icon(Icons.local_florist, key: ValueKey('growth'), color: Colors.lightGreenAccent);
      case TreeStatus.rest:
        return const Icon(Icons.self_improvement, key: ValueKey('rest'), color: Colors.blueAccent);
      case TreeStatus.dead:
        return const Icon(Icons.emoji_events, key: ValueKey('dead'), color: Colors.redAccent);
    }
  }
}

class _HoverImage extends StatefulWidget {
  final String url;
  final double height;
  final BorderRadius borderRadius;

  const _HoverImage({required this.url, required this.height, required this.borderRadius});

  @override
  State<_HoverImage> createState() => _HoverImageState();
}

class _HoverImageState extends State<_HoverImage> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 260),
        scale: _hover ? 1.03 : 1.0,
        curve: Curves.easeOutCubic,
        child: Image.network(
          widget.url,
          height: widget.height,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const AppShimmer(height: 140, width: double.infinity, borderRadius: BorderRadius.all(Radius.circular(16)));
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade800,
              child: const Center(child: Icon(Icons.image_not_supported, color: Colors.white54, size: 40)),
            );
          },
        ),
      ),
    );
  }
}

class _ActionIconButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionIconButton({required this.icon, required this.label, this.onTap});

  @override
  State<_ActionIconButton> createState() => _ActionIconButtonState();
}

class _ActionIconButtonState extends State<_ActionIconButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.92),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: ElevatedButton.icon(
          onPressed: widget.onTap,
          icon: Icon(widget.icon, size: 18),
          label: Text(widget.label, style: const TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
        ),
      ),
    );
  }
}
