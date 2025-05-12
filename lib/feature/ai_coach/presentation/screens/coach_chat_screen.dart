import 'package:flutter/material.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/feature/ai_coach/presentation/widgets/chat_text_box.dart';

class CoachChatScreen extends StatelessWidget {
  const CoachChatScreen({super.key});

  final double _tokenUsage = 1.4;

  final double _tokenLimit = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: SizedBox(
          width: 150,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_tokenUsage}K - ${_tokenLimit}K',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${(_tokenUsage / _tokenLimit * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: _tokenUsage / _tokenLimit,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                minHeight: 4,
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Orbs: 17',
              style: textTheme(context).bodyMedium!.copyWith(color: secondary),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: const [
                // Chat messages will go here
              ],
            ),
          ),
          ChatTextBox(),
        ],
      ),
    );
  }
}
