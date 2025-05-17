import '../repositories/ai_coach_repository.dart';
import '../entity/token_stats.dart';

class GetTokenStatsUseCase {
  final AiCoachRepository repo;
  GetTokenStatsUseCase(this.repo);

  Future<TokenStats> call() => repo.getTokenStats();
}
