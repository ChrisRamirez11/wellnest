import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/core/widgets/custom_button.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';

class CountdownPage extends ConsumerStatefulWidget {
  final Routine routine;
  final int routineIndex;

  const CountdownPage({
    super.key,
    required this.routine,
    required this.routineIndex,
  });

  @override
  ConsumerState<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends ConsumerState<CountdownPage> {
  Timer? _timer;
  bool _isTimerRunning = false;
  int _elapsedSeconds = 0;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _elapsedSeconds = widget.routine.elapsedTimeSeconds ?? 0;
    _updateProgress();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateProgress() {
    if (widget.routine.targetDurationSeconds != null &&
        widget.routine.targetDurationSeconds! > 0) {
      _progress = _elapsedSeconds / widget.routine.targetDurationSeconds!;

      _progress = _progress.clamp(0.0, 1.0);
    } else {
      _progress = 0.0;
    }
  }

  void _startTimer() {
    final dateNotifier = ref.read(dateProvider.notifier);

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
        _updateProgress();

        // Update the routine in the state
        dateNotifier.date!.routines[widget.routineIndex].elapsedTimeSeconds =
            _elapsedSeconds;

        // Check if target reached
        if (widget.routine.targetDurationSeconds != null &&
            _elapsedSeconds >= widget.routine.targetDurationSeconds!) {
          dateNotifier.date!.routines[widget.routineIndex].finished = true;
          _stopTimer();
        }

        // Save progress
        dateNotifier.upsertDate(dateNotifier.date!);
      });
    });
    setState(() => _isTimerRunning = true);
  }

  void _stopTimer() {
    final dateNotifier = ref.read(dateProvider.notifier);

    _timer?.cancel();
    setState(() => _isTimerRunning = false);

    // Save current progress
    dateNotifier.date!.routines[widget.routineIndex].elapsedTimeSeconds =
        _elapsedSeconds;
    dateNotifier.upsertDate(dateNotifier.date!);
  }

  void _resetTimer() {
    final dateNotifier = ref.read(dateProvider.notifier);

    _timer?.cancel();
    _timer = null;

    setState(() {
      _elapsedSeconds = 0;
      _updateProgress();
      dateNotifier.date!.routines[widget.routineIndex].elapsedTimeSeconds = 0;
      dateNotifier.date!.routines[widget.routineIndex].finished = false;

      _isTimerRunning = false;
    });

    dateNotifier.upsertDate(dateNotifier.date!);
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));
    return hours != '00' ? '$hours:$minutes:$secs' : '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final remainingSeconds =
        (widget.routine.targetDurationSeconds ?? 0) - _elapsedSeconds;
    final isCompleted = widget.routine.targetDurationSeconds != null &&
        (widget.routine.finished == true ||
            _elapsedSeconds >= widget.routine.targetDurationSeconds!);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        } else {
          if (!_isTimerRunning) {
            Navigator.of(context).pop();
            return;
          }
          _stopTimer();
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                localization(context).quitTimer,
                style: textTheme(context).bodyLarge!.copyWith(fontSize: 20),
              ),
              content: Text(
                  localization(context).timerSaved,
                  style: textTheme(context)
                      .bodySmall!
                      .copyWith(color: Colors.grey)),
              actions: [
                TextButton(
                  onPressed: () {
                    _startTimer();
                    Navigator.of(context).pop();
                  },
                  child: Text(localization(context).cancel.toUpperCase(),
                      style: textTheme(context).bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(localization(context).ok.toUpperCase(),
                      style: textTheme(context).bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          titleString: widget.routine.name!,
        ),
        body: Center(
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 190,
                      height: 190,
                      child: CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        value: _progress,
                        strokeWidth: 15,
                        backgroundColor:
                            Color(widget.routine.colorValue!).withAlpha(100),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(widget.routine.colorValue!),
                        ),
                      ),
                    ),
                    Text(
                      _formatDuration(
                          remainingSeconds > 0 ? remainingSeconds : 0),
                      style: textTheme(context)
                          .bodyLarge!
                          .copyWith(color: primary, fontSize: 30),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Play/Pause/Finish Button
              CustomButton(
                onClick: isCompleted
                    ? () {
                        if (context.mounted) {
                          Navigator.pop(
                              context, true); // Return with completion status
                        }
                      }
                    : () {
                        if (_isTimerRunning) {
                          _stopTimer();
                        } else {
                          _startTimer();
                        }
                      },
                text: isCompleted
                    ? localization(context).finish.toUpperCase()
                    : _isTimerRunning
                        ? localization(context).pause.toUpperCase()
                        : localization(context).resume.toUpperCase(),
                icon: isCompleted
                    ? const Icon(Icons.check, color: Colors.white)
                    : Icon(
                        _isTimerRunning ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                color: Colors.blue,
                textColor: Colors.white,
              ),

              // Reset Button
              SizedBox(
                width: 150,
                child: CustomButton(
                  onClick: _resetTimer,
                  icon: const Icon(Icons.restart_alt),
                  text: localization(context).reset.toUpperCase(),
                  color: Colors.transparent,
                ),
              ),

              // Mark as Done Button
              !isCompleted
                  ? CustomButton(
                      onClick: () {
                        final dateNotifier = ref.read(dateProvider.notifier);
                        _stopTimer();

                        // Force complete the routine
                        if (widget.routine.targetDurationSeconds != null) {
                          _elapsedSeconds =
                              widget.routine.targetDurationSeconds!;
                          dateNotifier.date!.routines[widget.routineIndex]
                            ..elapsedTimeSeconds = _elapsedSeconds
                            ..finished = true;

                          _updateProgress();
                          dateNotifier.upsertDate(dateNotifier.date!);
                        }

                        if (context.mounted) {
                          Navigator.pop(
                              context, true); // Return to previous screen
                        }
                      },
                      text: localization(context).markDone,
                      icon: const Icon(Icons.done, color: Colors.white),
                      color: Colors.green,
                      textColor: Colors.white,
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
