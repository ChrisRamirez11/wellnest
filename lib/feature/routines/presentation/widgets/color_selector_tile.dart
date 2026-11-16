import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_nest/core/utils/utils.dart';
import 'package:task_nest/feature/routines/presentation/providers/color_provider.dart';

class ColorSelectorTile extends ConsumerWidget {
  const ColorSelectorTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorNotifier = ref.watch(colorProvider);

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        localization(context).selectColor,
        style: textTheme(
          context,
        ).bodyLarge!.copyWith(color: Colors.grey.shade400),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      leading: CircleAvatar(backgroundColor: colorNotifier.color),
      onTap: () => _showColorPicker(context, ref),
    );
  }

  void _showColorPicker(BuildContext context, WidgetRef ref) {
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
              ...Colors.primaries.map(
                (color) => GestureDetector(
                  onTap: () {
                    colorNotifier.setColor(color);
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(backgroundColor: color, radius: 24),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
