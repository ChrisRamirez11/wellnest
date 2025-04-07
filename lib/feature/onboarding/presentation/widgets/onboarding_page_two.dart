import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/utils/string_to_time_of_day.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/onboarding/presentation/provider/start_and_end_time_provider.dart';
import 'package:wellnest/feature/onboarding/presentation/widgets/digital_clock.dart';

class OnboardingPageTwo extends ConsumerWidget {
  const OnboardingPageTwo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeOfDayNotifier = ref.watch(startAndEndTimeProvider);
    final TimeOfDay endOfDayTime = stringToTimeOfDay(timeOfDayNotifier.end);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 16,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            localization(context).sleepQuestion,
            style: textTheme(context).bodyLarge!.copyWith(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: size(context).width * 0.6,
            child: Text(
              localization(context).sleepMessage,
              style: textTheme(context).labelMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          DigitalClock(
              onPressed: () async {
                final time = await showTimePicker(
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        textTheme: TextTheme(
                          labelLarge: TextStyle(
                              fontSize: 15), // Ajusta el tamaño de fuente
                        ),
                      ),
                      child: child!,
                    );
                  },
                  initialEntryMode: TimePickerEntryMode.input,
                  context: context,
                  initialTime: endOfDayTime,
                );
                if (time != null) {
                  timeOfDayNotifier.setEndOfDay(time);
                }
              },
              selectedTime: endOfDayTime),
          Spacer(),
        ],
      ),
    );
  }
}
