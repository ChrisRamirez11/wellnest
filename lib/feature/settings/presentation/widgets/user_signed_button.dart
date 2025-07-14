import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_button.dart';
import 'package:wellnest/feature/auth/data/models/profile_model.dart';
import 'package:wellnest/feature/auth/presentation/riverpod/profile_provider.dart';
import 'package:wellnest/feature/data_backup_restore/presentation/provider/data_provider.dart';
import 'package:wellnest/feature/settings/presentation/providers/orange_icon_provider.dart';

class UserSignedButton extends ConsumerStatefulWidget {
  const UserSignedButton({super.key});

  @override
  ConsumerState<UserSignedButton> createState() => _UserSignedButtonState();
}

class _UserSignedButtonState extends ConsumerState<UserSignedButton> {
  @override
  Future<void> didChangeDependencies() async {
    await ref.watch(profileProvider).getMyUserData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final hasSeenOrangeIconState =
        ref.watch(orangeIconProvider.notifier).currentState;

    final profile = ref.watch(profileProvider).profile;
    final failure = ref.watch(profileProvider).failure;
    late Widget widget;

    if (profile != null) {
      widget = Padding(
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
                child: InkWell(
                  onTap: () => showModalBottomSheet(
                      backgroundColor: Colors.grey.shade900,
                      useSafeArea: true,
                      showDragHandle: true,
                      constraints:
                          BoxConstraints(maxHeight: size(context).height * .4),
                      context: context,
                      builder: (context) =>
                          getLogOutBottomSheet(context, profile)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profile.fullName,
                        style: textTheme(context).bodyLarge,
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 25,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          subtitle: SizedBox(
              height: 20,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                      child: Text(
                    profile.email,
                    style: textTheme(context).bodyMedium,
                  )))),
          trailing: Tooltip(
            textStyle:
                textTheme(context).bodySmall!.copyWith(color: obsidian),
            message: localization(context).syncTooltip,
            child: IconButton(
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.autorenew),
                  if (!hasSeenOrangeIconState)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () async {
                await _performSync(context);
              },
            ),
          ),
        ),
      );
    } else if (failure != null) {
      widget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          minTileHeight: 70,
          title: Text(
            failure.errorMessage,
            style: textTheme(context).bodyMedium,
          ),
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

  Future<void> _performSync(BuildContext context) async {
    //shows the loading dialog
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
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text(localization(context).syncingData),
                ],
              ),
            ),
          )
        ],
      ),
    );

    final hasSeenOrangeIconNotifier = ref.watch(orangeIconProvider.notifier);
    // Update the orange icon state
    if (!hasSeenOrangeIconNotifier.currentState) {
      hasSeenOrangeIconNotifier.setHasSeenOrangeIcon();
    }

    final dataNotifier = ref.read(dataProvider);
    dataNotifier.clearFailure();
    // Perform backup & restore
    await dataNotifier.backupRestore(ref, context);

    //closes the dialog
    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localization(context).dataSynced,
            style: textTheme(context).labelMedium,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget getLogOutBottomSheet(BuildContext context, ProfileModel profile) {
    return SizedBox(
      width: size(context).width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
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
                            profile.fullName,
                            style: textTheme(context).bodyLarge,
                          ),
                        ))),
                subtitle: SizedBox(
                    height: 20,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                            child: Text(
                          profile.email,
                          style: textTheme(context).bodyMedium,
                        )))),
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: size(context).width,
              height: 50,
              child: CustomButton(
                onClick: () async {
                  await ref.watch(profileProvider).signOut(context);
                  ref.watch(orangeIconProvider.notifier).reset();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                text: localization(context).logOut,
                color: errorColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: size(context).width,
              height: 50,
              child: CustomButton(
                onClick: () => Navigator.of(context).pop(),
                text: localization(context).cancel,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
