import 'package:dyslexia_mate/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/services/tts_service/tts_dervice.dart';
import '../../../core/utils/app_routes.dart';
import '../controllers/quiz_controller.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  static const String screenName = 'ResultScreen';

  @override
  void initState() {
    super.initState();
    TtsService.to.setCurrentScreen(screenName);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('نتائج الاختبار',
            style: TextStyle(color: Colors.white, fontSize: 20.sp)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Summary card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          Text(
                            'ملخص النتائج',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontSize: 20.sp),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  'عدد الإجابات الصحيحة: ${controller.correctAnswers.value} من ${controller.exercises.length}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontSize: 16.sp),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  TtsService.to.isSpeakingForScreen(screenName)
                                      ? Icons.stop
                                      : Icons.volume_up,
                                  size: 24.sp,
                                ),
                                onPressed: () {
                                  if (TtsService.to
                                      .isSpeakingForScreen(screenName)) {
                                    TtsService.to.stopSpeaking();
                                  } else {
                                    TtsService.to.speak(
                                      text:
                                          'عدد الإجابات الصحيحة: ${controller.correctAnswers.value} من ${controller.exercises.length}. الزمن الكلي: ${controller.getTotalTime()}',
                                      screenName: screenName,
                                      language: 'ar-SA',
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'الزمن الكلي: ${controller.getTotalTime()}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontSize: 16.sp),
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: controller.getRiskColor().withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                              border:
                                  Border.all(color: controller.getRiskColor()),
                            ),
                            child: Text(
                              'مستوى الخطر: ${controller.getRiskLevel()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 16.sp,
                                    color: controller.getRiskColor(),
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // FL Chart Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          Text(
                            'نسبة الإجابات الصحيحة والخاطئة',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 18.sp),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            height: 200.h,
                            child: ResultPieChart(
                              correctAnswers: controller.correctAnswers.value,
                              incorrectAnswers:
                                  controller.incorrectAnswers.value,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLegendItem(Colors.green, 'صحيح'),
                              SizedBox(width: 24.w),
                              _buildLegendItem(Colors.red, 'خطأ'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Results table
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'تفاصيل الإجابات',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontSize: 20.sp),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          _buildResultsTable(context, controller),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    },
                    icon: Icon(Icons.home, size: 20.sp),
                    label: Text('ابدا رحلتك معنا',
                        style:
                            TextStyle(fontSize: 16.sp, fontFamily: 'maqroo')),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.w),
        Text(label, style: TextStyle(fontSize: 14.sp)),
      ],
    );
  }

  Widget _buildResultsTable(BuildContext context, QuizController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 12.w,
        columns: [
          DataColumn(label: Text('السؤال', style: TextStyle(fontSize: 14.sp))),
          DataColumn(label: Text('إجابتك', style: TextStyle(fontSize: 14.sp))),
          DataColumn(
              label:
                  Text('الإجابة الصحيحة', style: TextStyle(fontSize: 14.sp))),
          DataColumn(label: Text('النتيجة', style: TextStyle(fontSize: 14.sp))),
          DataColumn(
              label: Text('الوقت (ثانية)', style: TextStyle(fontSize: 14.sp))),
        ],
        rows: controller.results.map((result) {
          return DataRow(
            color: MaterialStateProperty.all(
              result.isCorrect
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
            ),
            cells: [
              DataCell(SizedBox(
                width: 150.w,
                child: Text(result.question,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.sp)),
              )),
              DataCell(
                  Text(result.userAnswer, style: TextStyle(fontSize: 14.sp))),
              DataCell(Text(result.correctAnswer,
                  style: TextStyle(fontSize: 14.sp))),
              DataCell(Text(result.status, style: TextStyle(fontSize: 14.sp))),
              DataCell(Text(result.duration.toStringAsFixed(2),
                  style: TextStyle(fontSize: 14.sp))),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ResultPieChart extends StatelessWidget {
  final int correctAnswers;
  final int incorrectAnswers;

  const ResultPieChart({
    super.key,
    required this.correctAnswers,
    required this.incorrectAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final total = correctAnswers + incorrectAnswers;
    // Ensure we don't divide by zero
    final correctPercentage = total > 0 ? correctAnswers / total * 100 : 0.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 50,
            sections: [
              // Correct answers section
              PieChartSectionData(
                color: Colors.green,
                value: correctAnswers.toDouble(),
                title:
                    '', // No title in the section - we'll display it in the center
                radius: 50,
                titleStyle: const TextStyle(
                  fontSize: 0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Incorrect answers section
              PieChartSectionData(
                color: Colors.red,
                value: incorrectAnswers.toDouble(),
                title:
                    '', // No title in the section - we'll display it in the center
                radius: 50,
                titleStyle: const TextStyle(
                  fontSize: 0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // Center text
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${correctPercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'نسبة الإجابات الصحيحة',
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
      ],
    );
  }
}
