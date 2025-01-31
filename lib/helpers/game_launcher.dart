import 'package:url_launcher/url_launcher.dart';

class GameLauncher {
  static Future<void> launchGame() async {
    final Uri deepLink = Uri.parse("theforgottenletters://start");

    if (await canLaunchUrl(deepLink)) {
      await launchUrl(deepLink);
      return;
    }

    final Uri playStoreUri =
        Uri.parse("https://aliwafa.itch.io/the-forgotten-letters");

    if (await canLaunchUrl(playStoreUri)) {
      await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
    }
  }
}
