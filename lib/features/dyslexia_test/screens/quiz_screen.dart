import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/assets.dart';
import '../../../core/services/tts_service/tts_dervice.dart';
import '../../../core/widgets/custom_snackBar.dart';
import '../controllers/quiz_controller.dart';
import '../models/exercise_model.dart';
import '../widgets/auditory_memory_input.dart';
import 'result_screen.dart';
import '../widgets/choice_button.dart';
import '../widgets/progress_bar.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final TextEditingController _textController = TextEditingController();
  final QuizController _quizController = Get.find<QuizController>();
  static const String screenName = 'TestScreen';

  @override
  void initState() {
    super.initState();
    TtsService.to.setCurrentScreen(screenName);
  }

  @override
  void dispose() {
    _textController.dispose();
    TtsService.to.stopSpeaking();
    super.dispose();
  }

  void _speakQuestion(String text) {
    TtsService.to.speak(
      text: text,
      screenName: screenName,
      language: 'ar-SA',
      rate: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_quizController.isQuizComplete) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const ResultScreen(),
            ),
          );
        });
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final question = _quizController.currentQuestion;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            'السؤال ${_quizController.currentQuestionIndex.value + 1} من ${_quizController.exercises.length}',
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.assetsImagesBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // Progress bar
              ProgressBar(
                correctPercentage: _quizController.correctPercentage,
                incorrectPercentage: _quizController.incorrectPercentage,
              ),

              // Question
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w), // متجاوب
                  child: Column(
                    children: [
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(16.w), // متجاوب
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      question.question,
                                      style: TextStyle(
                                        fontSize: 20.sp, // متجاوب
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Obx(() => IconButton(
                                        icon: Icon(
                                          TtsService.to.isSpeakingForScreen(
                                                  screenName)
                                              ? Icons.stop
                                              : Icons.volume_up,
                                        ),
                                        onPressed: () {
                                          if (TtsService.to.isSpeakingForScreen(
                                              screenName)) {
                                            TtsService.to.stopSpeaking();
                                          } else {
                                            _speakQuestion(question.question);
                                          }
                                        },
                                      )),
                                ],
                              ),
                              if (question.imageEmoji != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.h), // متجاوب
                                  child: Text(
                                    question.imageEmoji!,
                                    style: TextStyle(fontSize: 72.sp), // متجاوب
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h), // متجاوب

                      // Choices or text input
                      if (question.type == ExerciseType.auditoryMemory)
                        AuditoryMemoryInput(
                          controller: _textController,
                          isEnabled: !_quizController.showFeedback.value &&
                              !_quizController.isProcessingAnswer.value,
                          onSubmitted: () {
                            _quizController.checkAnswer(_textController.text);
                            _textController.clear();
                          },
                          parentContext: context,
                        )
                      else if (question.choices != null)
                        _buildChoices(question.choices!),

                      // Feedback
                      if (_quizController.showFeedback.value)
                        Container(
                          margin: EdgeInsets.only(top: 24.h), // متجاوب
                          padding: EdgeInsets.all(16.w), // متجاوب
                          decoration: BoxDecoration(
                            color:
                                _quizController.feedback.value!.contains("✔️")
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8.r), // متجاوب
                          ),
                          child: Text(
                            _quizController.feedback.value!,
                            style: TextStyle(fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildChoices(List<String> choices) {
    return Column(
      children: choices.map((choice) {
        return ChoiceButton(
          choice: choice,
          onPressed: (_quizController.showFeedback.value ||
                  _quizController.isProcessingAnswer.value)
              ? null
              : () => _quizController.checkAnswer(choice),
        );
      }).toList(),
    );
  }
}
