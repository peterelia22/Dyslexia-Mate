import 'package:url_launcher/url_launcher.dart';

class GameLauncher {
  // Launch main game
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

  // Launch Letter Hunt Image Edition
  static Future<void> launchLetterHunt() async {
    final Uri intentUri = Uri.parse("theforgottenletters://letterhunt");

    try {
      print("Attempting to launch Letter Hunt: $intentUri");
      if (await canLaunchUrl(intentUri)) {
        print("Letter Hunt deep link is supported. Launching...");
        await launchUrl(intentUri);
      } else {
        print(
            "Letter Hunt deep link is not supported. Falling back to download link...");
        await launchGameDownload();
      }
    } catch (e) {
      print("Letter Hunt deep link failed: $e");
      print("Falling back to download link...");
      await launchGameDownload();
    }
  }

  // Launch Draw Letters
  static Future<void> launchDrawLetters() async {
    final Uri intentUri = Uri.parse("theforgottenletters://letterdrawing");

    try {
      print("Attempting to launch Draw Letters: $intentUri");
      if (await canLaunchUrl(intentUri)) {
        print("Draw Letters deep link is supported. Launching...");
        await launchUrl(intentUri);
      } else {
        print(
            "Draw Letters deep link is not supported. Falling back to download link...");
        await launchGameDownload();
      }
    } catch (e) {
      print("Draw Letters deep link failed: $e");
      print("Falling back to download link...");
      await launchGameDownload();
    }
  }

  // Launch Object Detection
  static Future<void> launchObjectDetection() async {
    final Uri intentUri = Uri.parse("theforgottenletters://objectdetection");

    try {
      print("Attempting to launch Object Detection: $intentUri");
      if (await canLaunchUrl(intentUri)) {
        print("Object Detection deep link is supported. Launching...");
        await launchUrl(intentUri);
      } else {
        print(
            "Object Detection deep link is not supported. Falling back to download link...");
        await launchGameDownload();
      }
    } catch (e) {
      print("Object Detection deep link failed: $e");
      print("Falling back to download link...");
      await launchGameDownload();
    }
  }

  // Launch game download page
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

  // Helper method to launch any game mode
  static Future<void> launchGameMode(String mode) async {
    switch (mode) {
      case 'letterhunt':
        await launchLetterHunt();
        break;
      case 'letterdrawing':
        await launchDrawLetters();
        break;
      case 'objectdetection':
        await launchObjectDetection();
        break;
      default:
        await launchGame();
        break;
    }
  }
}
