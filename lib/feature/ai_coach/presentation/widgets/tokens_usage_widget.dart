// ai_coach/presentation/widgets/tokens_usage_widget.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/feature/ai_coach/presentation/provider/ai_coach_provider/providers.dart';

enum TokenViewMode {
  input,
  output,
}

/// Now a ConsumerStatefulWidget to maintain view mode and timer.
class TokensUsageWidget extends ConsumerStatefulWidget {
  const TokensUsageWidget({super.key});

  @override
  ConsumerState<TokensUsageWidget> createState() => _TokensUsageWidgetState();
}

class _TokensUsageWidgetState extends ConsumerState<TokensUsageWidget> {
  TokenViewMode _viewMode = TokenViewMode.input;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    // Every 5 seconds, automatically alternate between input and output
    _autoTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() {
        _viewMode = (_viewMode == TokenViewMode.input)
            ? TokenViewMode.output
            : TokenViewMode.input;
      });
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiCoachNotifierProvider);
    final data = state.data;

    final inputUsed = data?.inputUsedThisMonth ?? 0;
    final inputLimit = data?.inputMonthlyLimit ?? 0;
    final outputUsed = data?.outputUsedThisMonth ?? 0;
    final outputLimit = data?.outputMonthlyLimit ?? 0;

    // If there is no data yet, show placeholder
    if (data == null) {
      ref.watch(aiCoachNotifierProvider.notifier).loadInitialStats();
    }

    // Select values according to the current mode
    final used = (_viewMode == TokenViewMode.input
            ? inputUsed
            : outputUsed)
        .toDouble();
    final limit = (_viewMode == TokenViewMode.input
            ? inputLimit
            : outputLimit)
        .toDouble();
    final percentage = limit > 0 ? (used / limit).clamp(0.0, 1.0) : 0.0;
    final color = _getProgressColor(percentage, context);

    // Label showing whether it's Input or Output
    // final label = (_viewMode == TokenViewMode.input) ? 'Input' : 'Output';

    return GestureDetector(
      onTap: () {
        setState(() {
          _viewMode = (_viewMode == TokenViewMode.input)
              ? TokenViewMode.output
              : TokenViewMode.input;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 750),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        // Use the viewMode as key so the switcher knows when to transition
        child: _buildContent(used, limit, percentage, color, _viewMode),
      ),
    );
  }

  Widget _buildContent(double used, double limit, double percentage,
      Color color, TokenViewMode mode) {
    return Column(
      key: ValueKey(mode),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
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
