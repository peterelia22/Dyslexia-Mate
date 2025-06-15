import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/authentication/firebase_auth_service.dart';
import 'quick_actions_service.dart';

class AuthService extends GetxService {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final Rx<User?> _user = Rx<User?>(null);
  final RxBool _isInitialized = false.obs;
  String? _pendingAction;

  User? get currentUser => _user.value;
  bool get isLoggedIn => _user.value != null;
  bool get isInitialized => _isInitialized.value;
  RxBool get isInitializedStream => _isInitialized;

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  void _initializeAuth() {
    // Set the current user immediately if available
    _user.value = FirebaseAuth.instance.currentUser;

    // Listen to auth state changes
    _user.bindStream(FirebaseAuth.instance.authStateChanges());

    // Mark as initialized
    _isInitialized.value = true;

    // Debug print
    print('AuthService initialized. Current user: ${_user.value?.email}');
  }

  // Pending action methods
  void setPendingAction(String action) {
    _pendingAction = action;
    print('Pending action set: $action');
  }

  String? getPendingAction() {
    return _pendingAction;
  }

  void clearPendingAction() {
    _pendingAction = null;
    print('Pending action cleared');
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final result = await _firebaseAuthService.signIn(email, password);

    if (result['success']) {
      // After successful login, execute pending action if exists
      _executePendingActionAfterDelay();
    }

    return result;
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    final result = await _firebaseAuthService.signInWithGoogle();

    if (result['success']) {
      // After successful login, execute pending action if exists
      _executePendingActionAfterDelay();
    }

    return result;
  }

  void _executePendingActionAfterDelay() {
    // Add a small delay to ensure navigation context is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      if (Get.isRegistered<QuickActionsService>()) {
        final quickActionsService = Get.find<QuickActionsService>();
        quickActionsService.executePendingAction();
      }
    });
  }

  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
    clearPendingAction(); // Clear any pending actions on logout
  }
}
