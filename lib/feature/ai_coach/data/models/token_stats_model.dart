import '../../business/entity/token_stats.dart';

class TokenStatsModel {
  final int used, limit;
  TokenStatsModel({ required this.used, required this.limit });

  TokenStats toEntity() => TokenStats(usedThisMonth: used, monthlyLimit: limit);
}