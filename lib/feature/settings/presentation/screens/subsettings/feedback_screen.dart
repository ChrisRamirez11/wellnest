import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wellnest/core/theme/theme.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';
import 'package:wellnest/core/widgets/custom_button.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final String email = 'dynamicjobs@gmail.com';

  final String subject = 'Wellnest Feedback';

  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          titleString: 'Feedback',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  onChanged: (value) => setState(() {}),
                  controller: feedbackController,
                  decoration: InputDecoration(
                    hintStyle: textTheme(context)
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                    hintText:
                        "Give us feedback or any suggestion.",
                    border: OutlineInputBorder(),
                  ),
                  minLines: 5,
                  maxLines: 20,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomButton(
                    color: feedbackController.text.isNotEmpty
                        ? primary
                        : Colors.grey.shade700,
                    onClick: feedbackController.text.isNotEmpty
                        ? () async {
                            final String feedback = feedbackController.text;
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: email,
                              queryParameters: {
                                'subject': subject,
                                'body': feedback,
                              },
                            );
      
                            if (await canLaunchUrl(emailLaunchUri)) {
                              await launchUrl(emailLaunchUri);
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Could not launch email client')),
                                );
                              }
                            }
                          }
                        : null,
                    text: 'SEND',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
