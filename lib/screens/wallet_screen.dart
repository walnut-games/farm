import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../engine/game_engine.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/glow_button.dart';
import '../widgets/animated_wave_background.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<GameEngine>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: const Text('Кошелёк')),
      body: Stack(
        children: [
          const AnimatedWaveBackground(child: SizedBox.expand()),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(child: GlassContainer(padding: const EdgeInsets.all(14), child: _walletCardContent('WLNT', '${engine.wlntBalance}', AppTheme.gold))),
                  const SizedBox(width: 12),
                  Expanded(child: GlassContainer(padding: const EdgeInsets.all(14), child: _walletCardContent('SOL', '${engine.solBalance}', Colors.cyan))),
                ],
              ),
              const SizedBox(height: 22),
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Text('Финансовые операции', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.text)),
                  const SizedBox(height: 12),
                  Row(children: [
                    GlowButton(onPressed: () => engine.topUpWlnt(200), child: const Text('Пополнить WLNT')),
                    const SizedBox(width: 12),
                    GlowButton(onPressed: () => engine.withdrawWlnt(100), child: const Text('Вывести WLNT')),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    GlowButton(onPressed: () => engine.topUpSol(2), child: const Text('Пополнить SOL')),
                    const SizedBox(width: 12),
                    GlowButton(onPressed: () => engine.withdrawSol(1), child: const Text('Вывести SOL')),
                  ]),
                ]),
              ),
              const SizedBox(height: 22),
              GlassContainer(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Text('Реферальный код', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.text)),
                  const SizedBox(height: 12),
                  TextField(readOnly: true, decoration: InputDecoration(labelText: engine.referralCode, border: const OutlineInputBorder())),
                ]),
              ),
              const SizedBox(height: 22),
              GlassContainer(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  GlowButton(onPressed: engine.toggleMute, child: const Text('Тоггл звука')),
                  const SizedBox(width: 12),
                  Expanded(child: Slider(value: engine.soundVolume, min: 0, max: 1, onChanged: engine.isMuted ? null : engine.setVolume)),
                ]),
              ),
              const SizedBox(height: 22),
              Center(child: GlowButton(onPressed: () {}, child: const Text('Выйти из аккаунта'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _walletCardContent(String title, String value, Color accent) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: accent, child: Text(title[0], style: const TextStyle(color: Colors.white))),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
      ],
    );
  }
}
