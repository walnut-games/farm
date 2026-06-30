import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../engine/game_engine.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/glow_button.dart';
import '../widgets/animated_wave_background.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameEngine>().fetchLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<GameEngine>();
    final records = engine.leaderboard;
    return Scaffold(
      appBar: AppBar(title: const Text('Рейтинг'), actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: engine.fetchLeaderboard, tooltip: 'Обновить')]),
      body: Stack(children: [
        const AnimatedWaveBackground(child: SizedBox.expand()),
        Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: GlassContainer(
              padding: const EdgeInsets.all(12),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _StatBadge(label: 'WLNT', value: '${engine.wlntBalance}'),
                _StatBadge(label: 'Деревья', value: '${engine.ownedTrees.length}'),
                _StatBadge(label: 'День', value: '${engine.gameDay}'),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(child: GlowButton(onPressed: () {
                setState(() {
                  _selectedTab = 0;
                  engine.fetchLeaderboard();
                });
              }, child: Text('По WLNT', style: TextStyle(color: _selectedTab == 0 ? Colors.white : AppTheme.muted)))),
              const SizedBox(width: 8),
              Expanded(child: GlowButton(onPressed: () {
                setState(() {
                  _selectedTab = 1;
                  engine.sortLeaderboardByTrees();
                });
              }, child: Text('По деревьям', style: TextStyle(color: _selectedTab == 1 ? Colors.white : AppTheme.muted)))),
            ]),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: records.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      final isCurrentUser = record.email == engine.playerEmail;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: GlassContainer(
                          padding: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: CircleAvatar(backgroundColor: isCurrentUser ? AppTheme.gold : Colors.blueGrey, child: Text('${index + 1}', style: const TextStyle(color: Colors.black))),
                            title: Text(record.email, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Деревьев: ${record.treeCount} • Посажено: ${record.plantedTrees}'),
                            trailing: Text('${record.wlnt.toStringAsFixed(0)} WLNT', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ])
      ]),
    );
  }
}

class SegmentedControl extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const SegmentedControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        final isSelected = selectedIndex == index;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected ? Colors.green.shade800 : Colors.white10,
                foregroundColor: isSelected ? Colors.white : Colors.white70,
                side: BorderSide(color: isSelected ? Colors.greenAccent : Colors.white24),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => onChanged(index),
              child: Text(labels[index]),
            ),
          ),
        );
      }),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;

  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
