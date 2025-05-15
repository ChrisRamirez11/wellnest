import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/ai_coach_state.dart';
import '../../business/repositories/ai_coach_repository.dart';
import '../../business/usecases/get_coach_feedback_usecase.dart';
import '../../data/datasources/ai_coach_remote_datasource.dart';
import '../../data/repositories/ai_coach_repository_impl.dart';
import 'ai_coach_notifier.dart';

final supabaseProvider =
    Provider<SupabaseClient>((ref) => Supabase.instance.client);

final aiCoachRemoteDatasourceProvider = Provider<AiCoachRemoteDatasource>(
    (ref) => AiCoachRemoteDatasourceImpl(ref.watch(supabaseProvider)));

final aiCoachRepositoryProvider = Provider<AiCoachRepository>(
    (ref) => AiCoachRepositoryImpl(ref.watch(aiCoachRemoteDatasourceProvider)));

final getCoachFeedbackUseCaseProvider = Provider<GetCoachFeedbackUseCase>(
    (ref) => GetCoachFeedbackUseCase(ref.watch(aiCoachRepositoryProvider)));

final aiCoachNotifierProvider =
    StateNotifierProvider<AiCoachNotifier, AiCoachState>(
        (ref) => AiCoachNotifier(ref.watch(getCoachFeedbackUseCaseProvider)));
