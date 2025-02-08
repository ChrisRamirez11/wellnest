import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/feature/auth/presentation/riverpod/profile_provider.dart';

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
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            minTileHeight: 70,
            leading: CircleAvatar(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(profile.avatarUrl)),
            ),
            title: Text(profile.fullName),
            subtitle: Text(profile.email),
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
