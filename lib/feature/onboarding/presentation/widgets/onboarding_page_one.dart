import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/utils/string_to_time_of_day.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/onboarding/presentation/provider/start_and_end_time_provider.dart';
import 'package:wellnest/feature/onboarding/presentation/widgets/digital_clock.dart';

class OnboardingPageOne extends ConsumerWidget {
  const OnboardingPageOne({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeOfDayNotifier = ref.watch(startAndEndTimeProvider);
    final TimeOfDay startOfDayTime = stringToTimeOfDay(timeOfDayNotifier.start);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 16,
        children: [
          SizedBox(height: 30,),
          Text(
            'What time do you usually wake up?',
            style: textTheme(context).bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: size(context).width * 0.6,
            child: Text(
              'Choose the time you usually start a new day.',
              style: textTheme(context).labelMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          DigitalClock(
            selectedTime: startOfDayTime,
            onPressed:  () async {
              final time = await showTimePicker(
                initialEntryMode: TimePickerEntryMode.input,
                context: context,
                initialTime: startOfDayTime,
              );
              if (time != null) {
                timeOfDayNotifier.setStartOfDay(time);
              }
            }),
          Spacer(),
        ],
      ),
    );
  }
}
