import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmptyStateCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyStateCard({super.key, required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0C241B), Color(0xFF102E22)]),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white12, width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(46), blurRadius: 28, offset: const Offset(0, 12))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: AppTheme.gold),
          const SizedBox(height: 18),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.text)),
          const SizedBox(height: 10),
          Text(subtitle, style: const TextStyle(color: AppTheme.muted), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
