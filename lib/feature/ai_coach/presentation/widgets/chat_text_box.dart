import 'package:flutter/material.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';

class ChatTextBox extends StatefulWidget {
  const ChatTextBox({
    super.key,
  });

  @override
  State<ChatTextBox> createState() => _ChatTextBoxState();
}

class _ChatTextBoxState extends State<ChatTextBox> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primary.withAlpha(200),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Column(
        children: [
          TextField(
            controller: _messageController,
            style: textTheme(context).labelMedium,
            decoration: const InputDecoration(
              hintText: 'Message Axio...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            maxLines: 3,
            minLines: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TimeRangeMenu(),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: secondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: primary),
                ),
                onPressed: () {
                  if (_messageController.text.trim().isNotEmpty) {
                    // Handle send message
                    _messageController.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimeRangeMenu extends StatefulWidget {
  const TimeRangeMenu({super.key});

  @override
  State<TimeRangeMenu> createState() => _TimeRangeMenuState();
}

class _TimeRangeMenuState extends State<TimeRangeMenu> {
  String selectedTimeRange = 'Day';
  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      alignmentOffset: const Offset(0, -200),
      menuChildren: [
        MenuItemButton(
          style: const ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size(150, 0)),
          ),
          child: const Text('Day'),
          onPressed: () {
            setState(() => selectedTimeRange = 'Day');
            _menuController.close();
          },
        ),
        MenuItemButton(
          child: const Text('Week'),
          onPressed: () {
            setState(() => selectedTimeRange = 'Week');
            _menuController.close();
          },
        ),
        MenuItemButton(
          child: const Text('Month'),
          onPressed: () {
            setState(() => selectedTimeRange = 'Month');
            _menuController.close();
          },
        ),
      ],
      child: InkWell(
        onTap: () {
          _menuController.isOpen
              ? _menuController.close()
              : _menuController.open();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedTimeRange,
                style: textTheme(context).bodyMedium,
              ),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
