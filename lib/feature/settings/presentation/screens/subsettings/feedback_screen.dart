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
  final String email = 'dynamicjobs.ch@gmail.com';

  final String subject = 'Wellnest Feedback';

  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
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
                  style: textTheme(context).labelMedium,
                  controller: feedbackController,
                  decoration: InputDecoration(
                    hintStyle: textTheme(context)
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                    hintText: "Give us feedback or any suggestion.",
                    border: OutlineInputBorder(),
                  ),
                  minLines: orientation == Orientation.portrait ? 5 : 2,
                  maxLines: orientation == Orientation.portrait ? 15 : 5,
                ),
                SizedBox(height: 20),
                getSendButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding getSendButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CustomButton(
        color:
            feedbackController.text.isNotEmpty ? primary : Colors.grey.shade700,
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
                  feedbackController.clear();
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                        'Could not launch email client',
                        style: textTheme(context).labelMedium,
                      )),
                    );
                  }
                }
              }
            : null,
        text: 'SEND',
      ),
    );
  }
}
