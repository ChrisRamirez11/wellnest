import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wellnest/core/utils/utils.dart';
import 'package:wellnest/core/widgets/custom_app_bar.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          titleString: 'About Us',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wellnest App',
                  style: textTheme(context).bodyLarge!.copyWith(fontSize: 24),
                ),
                Text(
                  'Version: $_appVersion',
                  style: textTheme(context).labelMedium,
                ),
                SizedBox(height: 8),
                Text(
                  'Wellnest is an app designed to help you manage your wellness and mental health. Our mission is to provide you with the tools and resources you need to live a healthier, happier life.',
                  style: textTheme(context).labelMedium,
                ),
                SizedBox(height: 8),
                Text(
                  "We are a small team trying to give our users the best we can. Your feedback and ideas are the cornerstone of our innovation. By sharing your thoughts, you're not just using Wellnest – you're helping shape its future. Contributors like you, are acknowledged in our 'Contributors' list",
                  style: textTheme(context).labelMedium,
                ),
                SizedBox(height: 8),
                Text(
                  "Have an idea to make Wellnest even better? We'd love to hear from you! Reach out to us through our in-app suggestion box.",
                  style: textTheme(context).labelMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
