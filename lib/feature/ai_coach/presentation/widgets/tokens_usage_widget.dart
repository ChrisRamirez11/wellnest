import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/ai_coach_provider/providers.dart';

class TokensUsageWidget extends ConsumerWidget {
  const TokensUsageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiCoachNotifierProvider);
    final used = state.data?.tokensUsedThisMonth.toDouble() ?? 0.0;
    final limit = state.data?.monthlyTokenLimit.toDouble() ?? 500000.0;
    final percentage = limit > 0 ? used / limit : 0.0;
    final color = _getProgressColor(percentage, context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_formatNumber(used)} / ${_formatNumber(limit)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${(percentage * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 4,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }

  Color _getProgressColor(double percent, BuildContext context) {
    if (percent < 0.5) {
      return Colors.green;
    } else if (percent < 0.8) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
  }
}
