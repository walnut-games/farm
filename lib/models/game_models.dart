enum WeatherType { thunderstorm, heatwave, forestFire, flood, fog, calm, cloudy }

enum TreeStatus { growth, rest, dead }

enum TreeRarity { common, rare, epic, legendary }

enum GemType { water, bird, fertilizer, rebirth }

enum MarketItemType { tree, gem }

extension WeatherTypeExt on WeatherType {
  String get label {
    switch (this) {
      case WeatherType.thunderstorm:
        return 'Гроза';
      case WeatherType.heatwave:
        return 'Жара';
      case WeatherType.forestFire:
        return 'Лесной пожар';
      case WeatherType.flood:
        return 'Наводнение';
      case WeatherType.fog:
        return 'Туман';
      case WeatherType.calm:
        return 'Тишь';
      case WeatherType.cloudy:
        return 'Облачно';
    }
  }

  String get emoji {
    switch (this) {
      case WeatherType.thunderstorm:
        return '⛈️';
      case WeatherType.heatwave:
        return '🔥';
      case WeatherType.forestFire:
        return '🌋';
      case WeatherType.flood:
        return '🌊';
      case WeatherType.fog:
        return '🌫️';
      case WeatherType.calm:
        return '🌿';
      case WeatherType.cloudy:
        return '☁️';
    }
  }
}

extension TreeRarityExt on TreeRarity {
  String get title {
    switch (this) {
      case TreeRarity.common:
        return 'Обычное';
      case TreeRarity.rare:
        return 'Редкое';
      case TreeRarity.epic:
        return 'Эпическое';
      case TreeRarity.legendary:
        return 'Легендарное';
    }
  }

  int get baseIncome {
    switch (this) {
      case TreeRarity.common:
        return 40;
      case TreeRarity.rare:
        return 80;
      case TreeRarity.epic:
        return 150;
      case TreeRarity.legendary:
        return 280;
    }
  }

  int get difficulty {
    switch (this) {
      case TreeRarity.common:
        return 1;
      case TreeRarity.rare:
        return 2;
      case TreeRarity.epic:
        return 3;
      case TreeRarity.legendary:
        return 4;
    }
  }
}

class RarityStats {
  final TreeRarity rarity;
  final int health;
  final int basePrice;
  final int growthDays;
  final int restDays;

  const RarityStats({
    required this.rarity,
    required this.health,
    required this.basePrice,
    required this.growthDays,
    required this.restDays,
  });
}

class Gem {
  final GemType type;
  final int level;
  int count;

  Gem({required this.type, required this.level, this.count = 1});

  String get name {
    switch (type) {
      case GemType.water:
        return 'Вода L$level';
      case GemType.bird:
        return 'Птицы L$level';
      case GemType.fertilizer:
        return 'Удобрение L$level';
      case GemType.rebirth:
        return 'Перерождение L$level';
    }
  }

  String get key => '${type.name}_$level';

  int get bonusPercent => level * 5;

  int get buyCost => 80 * level;

  int get sellValue => 50 * level;
}

class TreeModel {
  final String id;
  final String name;
  final TreeRarity rarity;
  final int baseValue;
  TreeStatus status;
  int dayInStage;
  int humidity;
  int durability;
  int caterpillars;
  int openSlots;
  final List<GemType?> gemSlots;
  double restResources;

  TreeModel({
    required this.id,
    required this.name,
    required this.rarity,
    required this.baseValue,
    this.status = TreeStatus.growth,
    this.dayInStage = 0,
    this.humidity = 100,
    this.durability = 100,
    this.caterpillars = 0,
    this.openSlots = 1,
    List<GemType?>? gemSlots,
    this.restResources = 0,
  }) : gemSlots = gemSlots ?? List<GemType?>.filled(4, null);

  bool get isGrowing => status == TreeStatus.growth;
  bool get isResting => status == TreeStatus.rest;
  bool get isMature => isGrowing && dayInStage >= 30;
  bool get isReadyToHarvest => status == TreeStatus.rest && dayInStage >= 30;

  double get humidityProgress => humidity.clamp(0, 100) / 100;
  double get durabilityProgress => durability.clamp(0, 100) / 100;

  int get effectiveYield {
    var bonus = 1.0;
    for (final gem in gemSlots) {
      if (gem != null) {
        bonus += 0.05;
      }
    }
    return (rarity.baseIncome * bonus).round();
  }

  int get openSlotCost {
    switch (openSlots) {
      case 1:
        return 50;
      case 2:
        return 100;
      case 3:
        return 150;
      default:
        return 200;
    }
  }

  String get stageLabel {
    if (status == TreeStatus.rest) {
      return 'Покой';
    }
    if (isMature) {
      return 'Готово';
    }
    return 'Рост';
  }
}

class DailyQuest {
  final String title;
  final String description;
  final int reward;
  bool complete;

  DailyQuest({
    required this.title,
    required this.description,
    required this.reward,
    this.complete = false,
  });
}

class MarketListing {
  final String id;
  final MarketItemType type;
  final String title;
  final String description;
  final int price;
  final TreeRarity? rarity;
  final GemType? gemType;
  final int? gemLevel;

  MarketListing.tree({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rarity,
  })  : type = MarketItemType.tree,
        gemType = null,
        gemLevel = null;

  MarketListing.gem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.gemType,
    required this.gemLevel,
  })  : type = MarketItemType.gem,
        rarity = null;
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int target;
  int progress;
  bool isUnlocked;
  final int rewardWlnt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.target,
    this.progress = 0,
    this.isUnlocked = false,
    required this.rewardWlnt,
  });

  double get completion => target == 0 ? 1 : (progress / target).clamp(0, 1);
}

class PlayerRecord {
  final String email;
  final double wlnt;
  final int treeCount;
  final int plantedTrees;

  PlayerRecord({
    required this.email,
    required this.wlnt,
    required this.treeCount,
    required this.plantedTrees,
  });
}

class DailyReward {
  final int day;
  final String rewardType;
  final dynamic rewardAmount;
  bool isClaimed;

  DailyReward({
    required this.day,
    required this.rewardType,
    required this.rewardAmount,
    this.isClaimed = false,
  });
}
