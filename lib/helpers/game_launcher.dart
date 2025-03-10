import 'package:url_launcher/url_launcher.dart';

class GameLauncher {
  static Future<void> launchGame() async {
    final Uri intentUri = Uri.parse("theforgottenletters://start");

    try {
      print("Attempting to launch deep link: $intentUri");
      if (await canLaunchUrl(intentUri)) {
        print("Deep link is supported. Launching...");
        await launchUrl(intentUri);
      } else {
        print("Deep link is not supported. Falling back to download link...");
        await launchGameDownload();
      }
    } catch (e) {
      print("Deep link failed: $e");
      print("Falling back to download link...");
      await launchGameDownload();
    }
  }

  static Future<void> launchGameDownload() async {
    const String gameUrl = "https://aliwafa.itch.io/the-forgotten-letters";
    final Uri uri = Uri.parse(gameUrl);

    try {
      print("Attempting to launch download link: $gameUrl");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print("Could not launch $gameUrl");
      }
    } catch (e) {
      print("Error launching download link: $e");
    }
  }
}
