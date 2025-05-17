import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/feature/ai_coach/presentation/widgets/chat_text_box.dart';

final selectedTimeRangeProvider = StateProvider<TimeRange>((ref) => TimeRange.none);
