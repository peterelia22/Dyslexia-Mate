import 'package:quick_actions/quick_actions.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_routes.dart';
import 'auth_service.dart';

class QuickActionsService extends GetxService {
  final QuickActions _quickActions = const QuickActions();
  static const String _pendingActionKey = 'pending_quick_action';
  bool _isHandlingAction = false;

  // Get the authentication service safely
  AuthService? get _authService =>
      Get.isRegistered<AuthService>() ? Get.find<AuthService>() : null;

  @override
  void onInit() {
    super.onInit();
    _initializeQuickActions();
  }

  void _initializeQuickActions() {
    print('Initializing Quick Actions...');

    _quickActions.initialize((shortcutType) {
      print('Quick Action triggered: $shortcutType');
      _handleQuickAction(shortcutType);
    });

    _quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'tts_action',
        localizedTitle: 'اسمع الكلام',
        icon: 'ic_tts',
      ),
      const ShortcutItem(
        type: 'stt_action',
        localizedTitle: 'احكي وهي تكتب',
        icon: 'ic_stt',
      ),
      const ShortcutItem(
        type: 'game_action',
        localizedTitle: 'يلا نلعب',
        icon: 'ic_game',
      ),
    ]);

    print('Quick Actions initialized successfully');
  }

  void _handleQuickAction(String shortcutType) {
    if (_isHandlingAction) return;
    _isHandlingAction = true;

    print('Handling quick action: $shortcutType');

    // Save action to SharedPreferences for persistence
    _savePendingAction(shortcutType);

    // Check if AuthService is available
    if (_authService == null) {
      print('AuthService not available, action saved for later execution');
      _isHandlingAction = false;
      return;
    }

    print('User logged in: ${_authService!.isLoggedIn}');

    // Check authentication status
    if (!_authService!.isLoggedIn) {
      print(
          'User not logged in, saving pending action and navigating to login');
      // If not logged in, save the pending action and navigate to login
      _authService!.setPendingAction(shortcutType);

      // Navigate directly to login, skip splash
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAllNamed(AppRoutes.login);
        _isHandlingAction = false;
      });
      return;
    }

    // If logged in, execute the action directly - skip splash completely
    print('User is logged in, executing action directly');
    Future.delayed(const Duration(milliseconds: 500), () {
      _navigateToAction(shortcutType);
      _clearPendingAction();
      _isHandlingAction = false;
    });
  }

  void _navigateToAction(String shortcutType) {
    print('Navigating to action: $shortcutType');

    // Navigate directly to the target screen, bypassing splash
    switch (shortcutType) {
      case 'tts_action':
        Get.offAllNamed(AppRoutes.text_to_speech);
        break;
      case 'stt_action':
        Get.offAllNamed(AppRoutes.speech_to_text);
        break;
      case 'game_action':
        Get.offAllNamed(AppRoutes.game);
        break;
      default:
        print('Unknown action type: $shortcutType');
    }
  }

  // Save pending action to SharedPreferences
  Future<void> _savePendingAction(String action) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pendingActionKey, action);
      print('Pending action saved to SharedPreferences: $action');
    } catch (e) {
      print('Error saving pending action: $e');
    }
  }

  // Get pending action from SharedPreferences
  Future<String?> _getPendingAction() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_pendingActionKey);
    } catch (e) {
      print('Error getting pending action: $e');
      return null;
    }
  }

  // Clear pending action from SharedPreferences
  Future<void> _clearPendingAction() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pendingActionKey);
      print('Pending action cleared from SharedPreferences');
    } catch (e) {
      print('Error clearing pending action: $e');
    }
  }

  // Check and execute pending action (called from splash screen)
  Future<void> checkForPendingActions() async {
    print('Checking for pending actions...');

    final pendingAction = await _getPendingAction();
    if (pendingAction != null) {
      print('Found pending action from previous session: $pendingAction');

      // Check if user is logged in
      if (_authService?.isLoggedIn == true) {
        print('User is logged in, executing pending action');

        // Wait a bit for the app to be ready
        await Future.delayed(const Duration(milliseconds: 1000));

        _navigateToAction(pendingAction);
        _clearPendingAction();
        return; // Important: return here to indicate action was handled
      } else {
        print('User not logged in, redirecting to login');
        _authService?.setPendingAction(pendingAction);

        // Wait a bit for the app to be ready
        await Future.delayed(const Duration(milliseconds: 1000));

        Get.offAllNamed(AppRoutes.login);
        _clearPendingAction();
        return; // Important: return here to indicate action was handled
      }
    }

    print('No pending actions found');
  }

  // Method to execute pending action after successful login
  void executePendingAction() {
    if (_authService == null) return;

    final pendingAction = _authService!.getPendingAction();
    print('Executing pending action from AuthService: $pendingAction');

    if (pendingAction != null) {
      _authService!.clearPendingAction();
      // Add a small delay to ensure the UI is ready
      Future.delayed(const Duration(milliseconds: 500), () {
        _navigateToAction(pendingAction);
      });
    }
  }
}
