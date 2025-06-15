import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/date_formatter.dart';
import '../controllers/game_stats_controller.dart';
import '../../../core/constants/assets.dart';

class GameStatsPage extends GetView<GameStatsController> {
  const GameStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.assetsImagesBackground),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  'إحصائيات الألعاب',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 18.sp),
                ),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: controller.refreshData,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: controller.refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPlayerDataCard(),
                      SizedBox(height: 16.h),
                      _buildGamesDataCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerDataCard() {
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'بيانات اللاعب',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            SizedBox(height: 12.h),
            Obx(() {
              if (controller.isLoadingPlayerData) {
                return const Center(child: CircularProgressIndicator());
              }

              final playerData = controller.playerData;
              if (playerData == null) {
                return const Text(
                  "لا توجد بيانات لاعب",
                  style: TextStyle(fontFamily: 'Tajawal'),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                      'نقاط الطاقة', playerData.energyPoints.toString()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                          'آخر زيادة طاقة',
                          playerData.lastEnergyIncrease != 'غير محدد'
                              ? DateFormatter.formatArabicDate(
                                  playerData.lastEnergyIncrease)
                              : 'غير محدد'),
                      if (playerData.lastEnergyIncrease != 'غير محدد')
                        Padding(
                          padding: EdgeInsets.only(right: 16.w, top: 4.h),
                          child: Text(
                            DateFormatter.formatRelativeTime(
                                playerData.lastEnergyIncrease),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[500],
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'المهارات المفتوحة:',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (playerData.unlockedSkills.isEmpty)
                    const Text(
                      'لا توجد مهارات مفتوحة',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    )
                  else
                    Wrap(
                      spacing: 8.w,
                      children: playerData.unlockedSkills
                          .map((skill) => Chip(
                                label: Text(
                                  skill,
                                  style: const TextStyle(fontFamily: 'Tajawal'),
                                ),
                                backgroundColor: Colors.blue.shade100,
                              ))
                          .toList(),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGamesDataCard() {
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إحصائيات الألعاب',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            SizedBox(height: 12.h),
            Obx(() {
              if (controller.isLoadingGamesData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.gamesData.isEmpty) {
                return const Text(
                  "لا توجد بيانات ألعاب",
                  style: TextStyle(fontFamily: 'Tajawal'),
                );
              }

              return Column(
                children: controller.gamesData.map((gameData) {
                  // Sort rounds by timestamp in descending order (newest first)
                  final sortedRounds =
                      List<Map<String, dynamic>>.from(gameData.rounds);
                  sortedRounds.sort((a, b) {
                    final String timestampA = a['timestampCairoTime'] ?? '';
                    final String timestampB = b['timestampCairoTime'] ?? '';
                    return timestampB.compareTo(timestampA); // Reverse order
                  });

                  return ExpansionTile(
                    title: Text(
                      gameData.gameNameInArabic,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 16.sp,
                      ),
                    ),
                    subtitle: Text(
                      'صحيح: ${gameData.correctScore} | خطأ: ${gameData.incorrectScore} | الجولات: ${gameData.rounds.length}',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14.sp,
                      ),
                    ),
                    leading: FaIcon(
                      FontAwesomeIcons.gamepad,
                      size: 24.w,
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildScoreCard('إجابات صحيحة',
                                      gameData.correctScore, Colors.green),
                                  _buildScoreCard('إجابات خاطئة',
                                      gameData.incorrectScore, Colors.red),
                                  _buildScoreCard('إجمالي الجولات',
                                      gameData.rounds.length, Colors.blue),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildLetterMistakesSection(gameData.gameType),
                            SizedBox(height: 16.h),
                            if (sortedRounds.isNotEmpty) ...[
                              Text(
                                'آخر 5 جولات:',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              SizedBox(height: 8.h),
                              ...sortedRounds
                                  .take(5)
                                  .map((round) => _buildRoundCard(round)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLetterMistakesSection(String gameType) {
    return Obx(() {
      final problematicLetters = controller.getMostProblematicLetters(gameType);

      if (problematicLetters.isEmpty) {
        return Container();
      }

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.amber.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber, size: 24.w),
                SizedBox(width: 8.w),
                Text(
                  'نصائح للتحسين',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: Colors.amber.shade800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'الحروف التي تحتاج إلى مزيد من التركيز:',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Tajawal',
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: problematicLetters.map((letter) {
                final mistakeCount =
                    controller.getLetterMistakeCount(gameType, letter);
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'عدد الأخطاء: $mistakeCount',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8.h),
            Text(
              'ركز على تحسين مهاراتك في هذه الحروف للحصول على نتائج أفضل!',
              style: TextStyle(
                fontSize: 12.sp,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String title, int value, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Tajawal',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRoundCard(Map<String, dynamic> round) {
    final bool isCorrect = round['isCorrect'] ?? false;
    final String targetLetter = round['targetLetter'] ?? '';
    final String chosenWord = round['chosenWordCorrectFormate'] ?? '';
    final String timestamp = round['timestampCairoTime'] ?? '';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: ListTile(
        leading: Icon(
          isCorrect ? Icons.check_circle : Icons.cancel,
          color: isCorrect ? Colors.green : Colors.red,
          size: 24.w,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الحرف المستهدف: $targetLetter',
              style: TextStyle(fontFamily: 'Tajawal', fontSize: 14.sp),
            ),
            if (chosenWord.isNotEmpty)
              Text(
                'الكلمة المختارة: $chosenWord',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormatter.formatArabicDate(timestamp),
              style: TextStyle(fontFamily: 'Tajawal', fontSize: 12.sp),
            ),
            Text(
              DateFormatter.formatRelativeTime(timestamp),
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 11.sp,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isCorrect
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            isCorrect ? 'صحيح' : 'خطأ',
            style: TextStyle(
              color: isCorrect ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ),
    );
  }
}
