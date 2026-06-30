PR: UI: polish animations and premium styling

Краткое описание:
- Полировка UI: микровзаимодействия (звук на нажатия, particle feedback, hover для карточек), обновлённые экраны: Garden, Shop, Luck, Inventory, Wallet, Leaderboard, Achievements, Daily Rewards.

Файлы с изменениями (ключевые):
- lib/widgets/glow_button.dart
- lib/widgets/particle_effect.dart
- lib/widgets/hoverable_card.dart
- lib/widgets/glass_container.dart
- lib/widgets/tree_card.dart
- lib/screens/garden_screen.dart
- lib/screens/shop_screen.dart
- lib/screens/luck_screen.dart
- lib/screens/inventory_screen.dart
- lib/screens/wallet_screen.dart
- lib/screens/leaderboard_screen.dart
- lib/screens/achievements_screen.dart
- lib/screens/daily_rewards_screen.dart
- pubspec.yaml (assets/audio/...)

QA Checklist (перед ревью):
- [ ] Навигация: открыть все перечисленные экраны без ошибок.
- [ ] Hover: на десктопе навести курсор на карточки в Inventory / Leaderboard — карточки слегка увеличиваются и получают тень.
- [ ] Button hover/press: hover и scale на `GlowButton` работают; при клике проигрывается `coin.mp3` и появляются частицы.
- [ ] Audio: звук запускается при явном клике пользователя (проверить в Chrome/Chromium/Firefox).
- [ ] Particles: particle overlay отображается корректно и исчезает через ~900ms.
- [ ] Accessibility: кнопки остаются доступными для клавиатуры и имеют фокус-стили.
- [ ] Performance: проверить профиль рендера на предмет просадок при множественных частицах.
- [ ] Analyzer: `flutter analyze --no-pub` не должен выдавать ошибок (только рекомендации `prefer_const`).
- [ ] Build: `flutter build web --release` проходит и `build/web` загружается в браузере.

Notes / Caveats:
- Web audio может требовать пользовательского взаимодействия (autoplay restrictions). Проверяйте клики, а не автоматические воспроизведения.
- Hover-эффекты не доступны на мобильных устройствах; убедитесь, что для мобильного поведения нет регрессий.

Рекомендации по меткам PR (labels):
- ui
- needs-review
- qa
- chore

Suggested reviewers:
- @team-ui
- @team-qa

Команды локальной проверки (копировать в терминал):
```bash
# serve build
python3 -m http.server 8080 --directory build/web
# открыть в браузере http://127.0.0.1:8080
# статический скриншот (если есть Chromium):
chromium-browser --headless --no-sandbox --disable-gpu --window-size=1366,768 --screenshot=screenshots/ui_screenshot.png http://127.0.0.1:8080
```
