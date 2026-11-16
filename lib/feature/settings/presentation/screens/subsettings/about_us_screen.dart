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
          leadingWidget: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleString: localization(context).about,
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
                  localization(context).wellnestWhatIs,
                  style: textTheme(context).labelMedium,
                ),
                SizedBox(height: 8),
                Text(
                  localization(context).whoWeAre,
                  style: textTheme(context).labelMedium,
                ),
                SizedBox(height: 8),
                Text(
                  localization(context).supportUsWithIdeas,
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
