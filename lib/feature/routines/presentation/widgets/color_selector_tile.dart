import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wellnest/core/global_providers/is_premium_user_provider.dart';
import 'package:wellnest/core/utils/show_paywall.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/routines/presentation/providers/color_provider.dart';

class ColorSelectorTile extends ConsumerWidget {
  const ColorSelectorTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorNotifier = ref.watch(colorProvider);

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        localization(context).selectColor,
        style:
            textTheme(context).bodyLarge!.copyWith(color: Colors.grey.shade400),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      leading: CircleAvatar(
        backgroundColor: colorNotifier.color,
      ),
      onTap: () => _showColorPicker(context, ref),
    );
  }

  void _showColorPicker(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumUser).isPremium ?? false;
    final colorNotifier = ref.watch(colorProvider);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              ...Colors.primaries.asMap().entries.map((entry) {
                final index = entry.key;
                final color = entry.value;
                final isLocked = (index >= 6 && !isPremium);

                return GestureDetector(
                  onTap: () {
                    if (isLocked) {
                      showPaywall();
                    } else {
                      colorNotifier.setColor(color);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: color,
                        radius: 24,
                        child: isLocked
                            ? const Icon(Icons.lock, color: Colors.white)
                            : null,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
