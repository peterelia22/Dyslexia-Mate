import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../../core/widgets/custom_snackBar.dart';
import '../models/game_model.dart';
import '../models/player_model.dart';

class GameStatsController extends GetxController {
  // Observable variables
  final _playerData = Rxn<PlayerModel>();
  final _gamesData = <GameModel>[].obs;
  final _isLoadingPlayerData = false.obs;
  final _isLoadingGamesData = false.obs;

  // Getters
  PlayerModel? get playerData => _playerData.value;
  List<GameModel> get gamesData => _gamesData;
  bool get isLoadingPlayerData => _isLoadingPlayerData.value;
  bool get isLoadingGamesData => _isLoadingGamesData.value;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    await Future.wait([
      getPlayerData(),
      getGameData(),
    ]);
  }

  Future<void> refreshData() async {
    await loadAllData();
  }

  Future<void> getPlayerData() async {
    try {
      _isLoadingPlayerData.value = true;

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot playerDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('game_data')
            .doc('player_data')
            .get();

        if (playerDoc.exists) {
          _playerData.value =
              PlayerModel.fromMap(playerDoc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      if (Get.context != null) {
        CustomSnackbar.show(
          Get.context!,
          title: 'خطأ',
          message: 'فشل في تحميل بيانات اللاعب: ${e.toString()}',
          contentType: ContentType.failure,
        );
      }
    } finally {
      _isLoadingPlayerData.value = false;
    }
  }

  Future<void> getGameData() async {
    try {
      _isLoadingGamesData.value = true;

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<String> gameTypes = [
          'draw_letter',
          'letter_hunt',
          'object_detection'
        ];

        _gamesData.clear();

        for (String gameType in gameTypes) {
          DocumentSnapshot gameDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('game_data')
              .doc(gameType)
              .get();

          if (gameDoc.exists) {
            Map<String, dynamic> data = gameDoc.data() as Map<String, dynamic>;
            data['gameType'] = gameType;
            _gamesData.add(GameModel.fromMap(data));
          }
        }
      }
    } catch (e) {
      if (Get.context != null) {
        CustomSnackbar.show(
          Get.context!,
          title: 'خطأ',
          message: 'فشل في تحميل بيانات الألعاب: ${e.toString()}',
          contentType: ContentType.failure,
        );
      }
    } finally {
      _isLoadingGamesData.value = false;
    }
  }
}
