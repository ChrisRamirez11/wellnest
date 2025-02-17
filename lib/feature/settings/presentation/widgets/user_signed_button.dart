import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/utils/validate_date_model_creation.dart.dart';
import 'package:wellnest/feature/auth/presentation/riverpod/profile_provider.dart';
import 'package:wellnest/feature/data_backup_restore/presentation/provider/data_provider.dart';
import 'package:wellnest/feature/dates/data/models/date_model.dart';
import 'package:wellnest/feature/dates/presentation/providers/date_provider.dart';
import 'package:wellnest/feature/routines/presentation/providers/routine_provider.dart';
import 'package:wellnest/feature/small_routines/presentation/providers/current_selected_date_provider.dart';

class UserSignedButton extends ConsumerStatefulWidget {
  const UserSignedButton({super.key});

  @override
  ConsumerState<UserSignedButton> createState() => _UserSignedButtonState();
}

class _UserSignedButtonState extends ConsumerState<UserSignedButton> {
  @override
  Future<void> didChangeDependencies() async {
    await ref.watch(profileProvider).getUserData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider).profile;
    final failure = ref.watch(profileProvider).failure;
    late Widget widget;

    if (profile != null) {
      widget = InkWell(
        onTap: () async {
          final dateNotifier = ref.watch(dateProvider);
          final selectedDateNotifier = ref.watch(currentSelectedDateProvider);
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => SimpleDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              children: [
                SizedBox(
                  height: size(context).height * 0.09,
                  width: size(context).width,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          );
          //TODO if no connection, wont do and will show a no connection snackbar
          await ref.watch(dataProvider).backupRestore(ref);

          //updating the DateModel
          selectedDateNotifier.changeDate(DateTime.now());
          dateNotifier.setDate(dateNotifier.dates!
                  .where(
                    (element) => element.date.isAtSameMomentAs(
                        selectedDateNotifier.currentSelectedDate),
                  )
                  .firstOrNull ??
              DateModel(
                  date: selectedDateNotifier.currentSelectedDate,
                  routines: [],
                  completedRoutineAmount: 0));

          if (dateNotifier.date!.id != null) {
            await dateNotifier.deleteDate(dateNotifier.date!.id!);
          }

          await validateDateModel(ref.watch(routineProvider).routines!,
              selectedDateNotifier.currentSelectedDate, ref);

          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            minTileHeight: 70,
            leading: CircleAvatar(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    fadeInCurve: Curves.ease,
                    fadeOutCurve: Curves.ease,
                    imageUrl: profile.avatarUrl,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person_off),
                  )),
            ),
            title: SizedBox(
              height: 30,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: Text(
                      profile.fullName),
                ),
              ),
            ), //TODO add the log out or cancel bottom sheet
            subtitle: FittedBox(child: Text(profile.email)),
            trailing: const Icon(Icons.autorenew),
          ),
        ),
      );
    } else if (failure != null) {
      widget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          minTileHeight: 70,
          title: Text(failure.errorMessage),
        ),
      );
    } else {
      widget = const Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          minTileHeight: 70,
          title: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return widget;
  }
}
