import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/game_models.dart';

class GameEngine extends ChangeNotifier {
  final Random _random = Random();
  final AudioPlayer _player = AudioPlayer();
  WeatherType currentWeather = WeatherType.calm;
  int wlntBalance = 1200;
  int solBalance = 12;
  String referralCode = 'WALNUT-0047';
  bool isMuted = false;
  double soundVolume = 0.6;

  int plantedTrees = 0;
  int completedGrowthCycles = 0;
  int caterpillarsKilled = 0;
  int waterActions = 0;
  int resourcesCollected = 0;
  int roulettePlays = 0;
  int birdsCollected = 0;
  bool reachedMasterGem = false;
  int gameDay = 1;

  final List<TreeModel> ownedTrees = [];
  final List<Gem> gemInventory = [];
  final Map<String, int> itemInventory = {
    'water_unit': 2,
    'fertilizer_unit': 1,
    'bird_unit': 0,
  };

  final List<MarketListing> marketTrees = [];
  final List<MarketListing> marketGems = [];
  final List<DailyQuest> quests = [];
  final List<Achievement> achievements = [];
  final List<DailyReward> dailyRewards = [];
  final List<PlayerRecord> leaderboard = [];
  String playerEmail = 'gardener@walnutfarm.app';
  String lastRoulette = 'Сделайте ставку 100 WLNT';

  GameEngine() {
    _initializeData();
  }

  void _initializeData() {
    ownedTrees.addAll([
      TreeModel(id: 'oak_01', name: 'Дуб Бора', rarity: TreeRarity.common, baseValue: 180),
      TreeModel(id: 'birch_02', name: 'Березка Шепот', rarity: TreeRarity.common, baseValue: 210),
      TreeModel(id: 'pine_03', name: 'Сосна Силы', rarity: TreeRarity.rare, baseValue: 420),
      TreeModel(id: 'maple_04', name: 'Клен Солнца', rarity: TreeRarity.rare, baseValue: 520),
      TreeModel(id: 'willow_05', name: 'Ива Тумана', rarity: TreeRarity.epic, baseValue: 880),
      TreeModel(id: 'walnut_06', name: 'Грецкий орех', rarity: TreeRarity.legendary, baseValue: 1400),
    ]);

    gemInventory.addAll([
      Gem(type: GemType.water, level: 1, count: 1),
      Gem(type: GemType.fertilizer, level: 1, count: 1),
      Gem(type: GemType.bird, level: 1, count: 0),
    ]);

    marketTrees.addAll([
      MarketListing.tree(id: 'market_tree_01', title: 'Садовый кедр', description: 'Редкое дерево с лучшим урожаем', price: 630, rarity: TreeRarity.rare),
      MarketListing.tree(id: 'market_tree_02', title: 'Золотой ясень', description: 'Эпическое дерево для сильного потока WLNT', price: 1250, rarity: TreeRarity.epic),
      MarketListing.tree(id: 'market_tree_03', title: 'Фениксовый орех', description: 'Легендарное дерево с бонусами при перерождении', price: 2320, rarity: TreeRarity.legendary),
    ]);

    marketGems.addAll([
      MarketListing.gem(id: 'market_gem_01', title: 'Вода L1', description: 'Ускоряет восстановление влажности', price: 80, gemType: GemType.water, gemLevel: 1),
      MarketListing.gem(id: 'market_gem_02', title: 'Птицы L1', description: 'Шанс уменьшить гусениц', price: 120, gemType: GemType.bird, gemLevel: 1),
      MarketListing.gem(id: 'market_gem_03', title: 'Удобрение L1', description: 'Добавляет доходность', price: 100, gemType: GemType.fertilizer, gemLevel: 1),
    ]);

    quests.addAll([
      DailyQuest(title: 'Полей дерево', description: 'Используйте воду на любом дереве.', reward: 60),
      DailyQuest(title: 'Победи гусениц', description: 'Устрани угрозу на выращиваемом дереве.', reward: 80),
      DailyQuest(title: 'Продай гем', description: 'Обменяйте гем на WLNT.', reward: 40),
    ]);

    achievements.addAll([
      Achievement(id: 'first_sprout', title: 'Первый росток', description: 'Посадите 1 дерево.', icon: '🌱', target: 1, rewardWlnt: 50),
      Achievement(id: 'gardener', title: 'Садовод', description: 'Посадите 5 деревьев.', icon: '🌿', target: 5, rewardWlnt: 200),
      Achievement(id: 'farmer', title: 'Фермер', description: 'Завершите 10 полных циклов роста.', icon: '🌳', target: 10, rewardWlnt: 500),
      Achievement(id: 'protector', title: 'Защитник', description: 'Убейте 50 гусениц.', icon: '🛡️', target: 50, rewardWlnt: 150),
      Achievement(id: 'waterkeeper', title: 'Водяной', description: 'Используйте 20 единиц полива.', icon: '💧', target: 20, rewardWlnt: 100),
      Achievement(id: 'collector', title: 'Коллекционер', description: 'Соберите 100 единиц ресурсов.', icon: '📦', target: 100, rewardWlnt: 300),
      Achievement(id: 'player', title: 'Игрок', description: 'Сыграйте в казино 5 раз.', icon: '🎲', target: 5, rewardWlnt: 100),
      Achievement(id: 'birdkeeper', title: 'Птицевод', description: 'Соберите 30 птиц.', icon: '🐦', target: 30, rewardWlnt: 250),
      Achievement(id: 'gem_master', title: 'Мастер гемов', description: 'Улучшите гем до 5 уровня.', icon: '💎', target: 1, rewardWlnt: 500),
      Achievement(id: 'millionaire', title: 'Миллионер', description: 'Накопите 10000 WLNT на балансе.', icon: '🪙', target: 10000, rewardWlnt: 1000),
    ]);

    dailyRewards.addAll([
      DailyReward(day: 1, rewardType: 'wlnt', rewardAmount: 50),
      DailyReward(day: 2, rewardType: 'wlnt', rewardAmount: 80),
      DailyReward(day: 3, rewardType: 'water', rewardAmount: 1),
      DailyReward(day: 4, rewardType: 'fertilizer', rewardAmount: 1),
      DailyReward(day: 5, rewardType: 'gem', rewardAmount: 'gem_water_1'),
      DailyReward(day: 6, rewardType: 'wlnt', rewardAmount: 200),
      DailyReward(day: 7, rewardType: 'gem', rewardAmount: 'gem_bird_1'),
    ]);

    currentWeather = getRandomWeather();
  }

  List<TreeModel> get growingTrees => ownedTrees.where((tree) => tree.isGrowing).toList();
  List<TreeModel> get restingTrees => ownedTrees.where((tree) => tree.isResting).toList();

  int get totalGemCount => gemInventory.fold(0, (sum, gem) => sum + gem.count);

  Gem gemForKey(String key) {
    return gemInventory.firstWhere(
      (gem) => gem.key == key,
      orElse: () => Gem(type: GemType.water, level: 1, count: 0),
    );
  }

  Gem findGem(GemType type, int level) {
    return gemInventory.firstWhere(
      (g) => g.type == type && g.level == level,
      orElse: () => Gem(type: type, level: level, count: 0),
    );
  }

  void playSound(String asset) {
    if (isMuted) return;
    try {
      _player.setVolume(soundVolume);
      _player.play(AssetSource(asset));
    } catch (_) {
      // Silent fallback if sound is not available.
    }
  }

  void fetchLeaderboard() {
    leaderboard.clear();
    for (var i = 0; i < 19; i++) {
      final email = 'player${i + 1}@walnut.io';
      final wlnt = 400 + _random.nextInt(9600) + _random.nextDouble();
      final trees = 1 + _random.nextInt(24);
      final planted = 1 + _random.nextInt(30);
      leaderboard.add(PlayerRecord(email: email, wlnt: wlnt, treeCount: trees, plantedTrees: planted));
    }
    leaderboard.add(PlayerRecord(email: playerEmail, wlnt: wlntBalance.toDouble(), treeCount: ownedTrees.length, plantedTrees: plantedTrees));
    leaderboard.sort((a, b) => b.wlnt.compareTo(a.wlnt));
    notifyListeners();
  }

  void sortLeaderboardByTrees() {
    leaderboard.sort((a, b) => b.treeCount.compareTo(a.treeCount));
    notifyListeners();
  }

  int get currentDailyDay => ((gameDay - 1) % 7) + 1;

  void resetDailyRewards() {
    for (final reward in dailyRewards) {
      reward.isClaimed = false;
    }
    notifyListeners();
  }

  void claimDailyReward(int day) {
    if (day != currentDailyDay) return;
    final reward = dailyRewards.firstWhere((item) => item.day == day, orElse: () => DailyReward(day: day, rewardType: 'wlnt', rewardAmount: 0));
    if (reward.isClaimed) return;

    switch (reward.rewardType) {
      case 'wlnt':
        wlntBalance += reward.rewardAmount as int;
        break;
      case 'water':
        itemInventory['water_unit'] = (itemInventory['water_unit'] ?? 0) + (reward.rewardAmount as int);
        break;
      case 'fertilizer':
        itemInventory['fertilizer_unit'] = (itemInventory['fertilizer_unit'] ?? 0) + (reward.rewardAmount as int);
        break;
      case 'gem':
        final rewardGem = reward.rewardAmount as String;
        final parts = rewardGem.split('_');
        final type = parts[1] == 'water' ? GemType.water : GemType.bird;
        final gem = findGem(type, int.parse(parts.last));
        if (gem.count == 0) {
          gemInventory.add(Gem(type: type, level: int.parse(parts.last), count: 1));
        } else {
          gem.count++;
        }
        break;
      default:
    }

    reward.isClaimed = true;
    notifyListeners();
  }

  WeatherType getRandomWeather() {
    const values = WeatherType.values;
    return values[_random.nextInt(values.length)];
  }

  void advanceDay() {
    gameDay++;
    resetDailyRewards();
    currentWeather = getRandomWeather();
    for (final tree in ownedTrees) {
      if (tree.status == TreeStatus.dead) continue;
      if (tree.isGrowing) {
        final wasMature = tree.isMature;
        tree.dayInStage++;
        final weatherPenalty = _calculateWeatherImpact(tree);
        tree.humidity = (tree.humidity - weatherPenalty).clamp(0, 100);
        tree.durability = (tree.durability - tree.caterpillars * 4).clamp(0, 100);
        tree.caterpillars = _spawnCaterpillars(tree);

        if (tree.humidity <= 0 || tree.durability <= 0) {
          tree.status = TreeStatus.dead;
          tree.humidity = 0;
          tree.durability = 0;
        }
        if (!wasMature && tree.isMature && tree.humidity > 0 && tree.durability > 0) {
          tree.status = TreeStatus.rest;
          tree.dayInStage = 0;
          tree.restResources = tree.effectiveYield.toDouble();
          completedGrowthCycles++;
        }
      } else if (tree.isResting) {
        tree.dayInStage++;
        tree.restResources += tree.effectiveYield * 0.8;
        if (tree.isReadyToHarvest) {
          tree.status = TreeStatus.growth;
          tree.dayInStage = 0;
          tree.humidity = 100;
          tree.durability = 100;
          tree.caterpillars = 0;
          tree.restResources = 0;
        }
      }
    }
    checkAchievements();
    notifyListeners();
  }

  int _calculateWeatherImpact(TreeModel tree) {
    switch (currentWeather) {
      case WeatherType.forestFire:
        return 12;
      case WeatherType.heatwave:
        return 8;
      case WeatherType.thunderstorm:
        return 0;
      case WeatherType.flood:
        return -15;
      case WeatherType.fog:
        return 3;
      case WeatherType.calm:
        return 5;
      case WeatherType.cloudy:
        return 4;
    }
  }

  int _spawnCaterpillars(TreeModel tree) {
    if (currentWeather == WeatherType.heatwave || currentWeather == WeatherType.forestFire) {
      return 0;
    }
    var base = 1 + tree.rarity.difficulty;
    if (currentWeather == WeatherType.thunderstorm || currentWeather == WeatherType.cloudy) {
      base += 1;
    }
    if (currentWeather == WeatherType.flood) {
      base *= 2;
    }
    if (currentWeather == WeatherType.calm) {
      base = max(base - 1, 0);
    }
    final birdsGem = tree.gemSlots.where((slot) => slot == GemType.bird).length;
    final reduce = birdsGem * 2;
    return max(base - reduce, 0);
  }

  void waterTree(String treeId) {
    final tree = ownedTrees.firstWhere((t) => t.id == treeId);
    if (tree.status != TreeStatus.growth || tree.status == TreeStatus.dead) return;
    if (itemInventory['water_unit']! > 0) {
      itemInventory['water_unit'] = itemInventory['water_unit']! - 1;
    } else {
      final price = currentWeather == WeatherType.forestFire ? 40 : 20;
      wlntBalance = max(0, wlntBalance - price);
    }
    tree.humidity = min(100, tree.humidity + 40);
    tree.durability = min(100, tree.durability + 15);
    waterActions++;
    _completeQuest('Полей дерево');
    checkAchievements();
    playSound('audio/water.mp3');
    notifyListeners();
  }

  void fightCaterpillars(String treeId) {
    final tree = ownedTrees.firstWhere((t) => t.id == treeId);
    if (tree.status != TreeStatus.growth || tree.status == TreeStatus.dead) return;
    const cost = 15;
    if (wlntBalance >= cost) {
      wlntBalance -= cost;
      caterpillarsKilled += tree.caterpillars;
      tree.caterpillars = 0;
      tree.durability = min(100, tree.durability + 10);
      _completeQuest('Победи гусениц');
      checkAchievements();
      playSound('audio/bird.mp3');
      notifyListeners();
    }
  }

  void openGemSlot(String treeId) {
    final tree = ownedTrees.firstWhere((t) => t.id == treeId);
    if (tree.openSlots >= 4) return;
    final cost = tree.openSlotCost;
    if (wlntBalance >= cost) {
      wlntBalance -= cost;
      tree.openSlots++;
      notifyListeners();
    }
  }

  void insertGem(String treeId, GemType type, int level, int slotIndex) {
    final tree = ownedTrees.firstWhere((t) => t.id == treeId);
    if (slotIndex >= tree.openSlots) return;
    if (tree.gemSlots[slotIndex] != null) return;
    final gem = findGem(type, level);
    if (gem.count <= 0) return;
    gem.count--;
    tree.gemSlots[slotIndex] = type;
    if (type == GemType.bird) {
      birdsCollected += 1;
    }
    checkAchievements();
    notifyListeners();
  }

  void collectHarvest(String treeId) {
    final tree = ownedTrees.firstWhere((t) => t.id == treeId);
    if (!tree.isResting) return;
    final gain = tree.restResources.round();
    wlntBalance += gain;
    resourcesCollected += gain;
    tree.restResources = 0;
    tree.status = TreeStatus.growth;
    tree.dayInStage = 0;
    tree.humidity = 100;
    tree.durability = 100;
    tree.caterpillars = 0;
    checkAchievements();
    playSound('audio/coin.mp3');
    notifyListeners();
  }

  void buyGem(MarketListing listing) {
    if (listing.type != MarketItemType.gem) return;
    if (wlntBalance < listing.price) return;
    wlntBalance -= listing.price;
    final gem = findGem(listing.gemType!, listing.gemLevel!);
    if (gem.count == 0) {
      gemInventory.add(Gem(type: listing.gemType!, level: listing.gemLevel!, count: 1));
    } else {
      gem.count++;
    }
    notifyListeners();
  }

  void buyTree(MarketListing listing) {
    if (listing.type != MarketItemType.tree) return;
    if (wlntBalance < listing.price) return;
    wlntBalance -= listing.price;
    ownedTrees.add(TreeModel(id: listing.id, name: listing.title, rarity: listing.rarity!, baseValue: listing.price));
    plantedTrees++;
    checkAchievements();
    notifyListeners();
  }

  void sellGem(GemType type, int level) {
    final gem = findGem(type, level);
    if (gem.count <= 0) return;
    gem.count--;
    wlntBalance += gem.sellValue;
    playSound('audio/coin.mp3');
    notifyListeners();
  }

  void upgradeGem(GemType type, int level) {
    final gem = findGem(type, level);
    if (gem.count < 3) return;
    gem.count -= 3;
    final nextLevel = level + 1;
    final nextGem = findGem(type, nextLevel);
    if (nextGem.count == 0) {
      gemInventory.add(Gem(type: type, level: nextLevel, count: 1));
    } else {
      nextGem.count++;
    }
    if (nextLevel >= 5) {
      reachedMasterGem = true;
    }
    checkAchievements();
    notifyListeners();
  }

  void burnGem(GemType type, int level) {
    final gem = findGem(type, level);
    if (gem.count <= 0) return;
    gem.count--;
    wlntBalance += max(50 * level, 0);
    playSound('audio/burn.mp3');
    notifyListeners();
  }

  void burnTree(String treeId) {
    final tree = ownedTrees.firstWhere((t) => t.id == treeId, orElse: () => TreeModel(id: '', name: '', rarity: TreeRarity.common, baseValue: 0));
    if (tree.id.isEmpty) return;
    final reward = (tree.baseValue * 0.6).round();
    wlntBalance += reward;
    itemInventory['fertilizer_unit'] = (itemInventory['fertilizer_unit'] ?? 0) + 1;
    ownedTrees.removeWhere((t) => t.id == treeId);
    playSound('audio/burn.mp3');
    notifyListeners();
  }

  void playRoulette() {
    const price = 100;
    if (wlntBalance < price) return;
    wlntBalance -= price;
    roulettePlays++;
    final roll = _random.nextInt(100);
    String result;
    if (roll < 5) {
      wlntBalance += 600;
      result = 'Джекпот! +600 WLNT';
    } else if (roll < 25) {
      wlntBalance += 220;
      result = '+220 WLNT';
    } else if (roll < 60) {
      wlntBalance += 120;
      result = '+120 WLNT';
    } else if (roll < 85) {
      wlntBalance += 80;
      result = '+80 WLNT';
    } else {
      result = 'Проигрыш';
    }
    lastRoulette = result;
    checkAchievements();
    playSound('audio/coin.mp3');
    notifyListeners();
  }

  void toggleMute() {
    isMuted = !isMuted;
    notifyListeners();
  }

  void setVolume(double value) {
    soundVolume = value;
    notifyListeners();
  }

  void topUpWlnt(int amount) {
    wlntBalance += amount;
    checkAchievements();
    notifyListeners();
  }

  void withdrawWlnt(int amount) {
    wlntBalance = max(0, wlntBalance - amount);
    notifyListeners();
  }

  void topUpSol(int amount) {
    solBalance += amount;
    notifyListeners();
  }

  void withdrawSol(int amount) {
    solBalance = max(0, solBalance - amount);
    notifyListeners();
  }

  void _completeQuest(String title) {
    final quest = quests.firstWhere(
      (element) => element.title == title,
      orElse: () => DailyQuest(title: '', description: '', reward: 0),
    );
    if (quest.title.isNotEmpty && !quest.complete) {
      quest.complete = true;
      wlntBalance += quest.reward;
    }
  }

  void checkAchievements() {
    for (final achievement in achievements) {
      switch (achievement.id) {
        case 'first_sprout':
          achievement.progress = ownedTrees.length;
          break;
        case 'gardener':
          achievement.progress = ownedTrees.length;
          break;
        case 'farmer':
          achievement.progress = completedGrowthCycles;
          break;
        case 'protector':
          achievement.progress = caterpillarsKilled;
          break;
        case 'waterkeeper':
          achievement.progress = waterActions;
          break;
        case 'collector':
          achievement.progress = resourcesCollected;
          break;
        case 'player':
          achievement.progress = roulettePlays;
          break;
        case 'birdkeeper':
          achievement.progress = birdsCollected;
          break;
        case 'gem_master':
          final maxLevelGem = gemInventory.where((gem) => gem.count > 0).map((gem) => gem.level).fold<int>(0, (prev, level) => max(prev, level));
          achievement.progress = maxLevelGem >= 5 ? 1 : 0;
          break;
        case 'millionaire':
          achievement.progress = wlntBalance;
          break;
        default:
          achievement.progress = 0;
      }

      if (!achievement.isUnlocked && achievement.progress >= achievement.target) {
        achievement.isUnlocked = true;
        wlntBalance += achievement.rewardWlnt;
      }
    }
  }
}
