import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'engine/game_engine.dart';
import 'screens/garden_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/luck_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/wallet_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const WalnutFarmApp());
}

class WalnutFarmApp extends StatelessWidget {
  const WalnutFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: AppTheme.bg,
      colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.accent, brightness: Brightness.dark),
      textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.text,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: AppTheme.panelAlt,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.gold,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppTheme.panel.withAlpha(184),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        hintStyle: const TextStyle(color: AppTheme.muted),
      ),
    );

    return ChangeNotifierProvider(
      create: (_) => GameEngine(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Walnut Farm',
        theme: base.copyWith(textTheme: AppTheme.textTheme(base.textTheme)),
        home: const MainShell(),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selectedIndex = 0;

  static const List<Widget> pages = <Widget>[
    GardenScreen(),
    LeaderboardScreen(),
    ShopScreen(),
    LuckScreen(),
    InventoryScreen(),
    WalletScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(child: pages[selectedIndex]),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0x0DFFFFFF), Color(0x12151515)]),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white12, width: 1.2),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(71), blurRadius: 26, offset: const Offset(0, 14))],
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) => setState(() => selectedIndex = value),
          backgroundColor: Colors.transparent,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          indicatorColor: AppTheme.accent.withAlpha(76),
          indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.park_rounded), label: 'Сад'),
            NavigationDestination(icon: Icon(Icons.emoji_events_rounded), label: 'Рейтинг'),
            NavigationDestination(icon: Icon(Icons.storefront_rounded), label: 'Магазин'),
            NavigationDestination(icon: Icon(Icons.casino_rounded), label: 'Удача'),
            NavigationDestination(icon: Icon(Icons.inventory_2_rounded), label: 'Инвентарь'),
            NavigationDestination(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Кошелёк'),
          ],
        ),
      ),
    );
  }
}
