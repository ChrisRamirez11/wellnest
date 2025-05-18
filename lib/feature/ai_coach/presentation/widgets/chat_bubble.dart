// presentation/widgets/chat_bubble.dart
import 'package:flutter/material.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isLoading;

  const ChatBubble({
    super.key,
    required this.text,
    this.isUser = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isUser
        ? Theme.of(context).colorScheme.primaryContainer
        : Colors.transparent;
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final radius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          );
    final margin = isUser
        ? EdgeInsets.only(bottom: 4, left: 30, top: 4, right: 4)
        : EdgeInsets.all(4);

    return Align(
      alignment: align,
      child: Container(
        margin: margin,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: bg, borderRadius: radius),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : SelectionArea(child: GptMarkdown(text, style: textTheme(context).labelMedium)),
      ),
    );
  }
}
