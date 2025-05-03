import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/tts_service/tts_dervice.dart';
import '../models/exercise_model.dart';
import '../data/exercises_data.dart';
import '../models/result_model.dart';

class QuizController extends GetxController {
  final exercises = ExercisesData.getExercises();
  final results = <QuizResult>[].obs;
  final currentQuestionIndex = 0.obs;
  final correctAnswers = 0.obs;
  final incorrectAnswers = 0.obs;
  final feedback = Rx<String?>(null);
  final showFeedback = false.obs;
  final isProcessingAnswer =
      false.obs; // Flag to track if we're processing an answer

  Rx<DateTime?> startTime = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    startQuiz();
  }

  void startQuiz() {
    currentQuestionIndex.value = 0;
    correctAnswers.value = 0;
    incorrectAnswers.value = 0;
    results.clear();
    feedback.value = null;
    showFeedback.value = false;
    isProcessingAnswer.value = false;
    startTime.value = DateTime.now();
  }

  Exercise get currentQuestion => exercises[currentQuestionIndex.value];

  bool get isLastQuestion => currentQuestionIndex.value == exercises.length - 1;

  bool get isQuizComplete => currentQuestionIndex.value >= exercises.length;

  double get correctPercentage =>
      exercises.isEmpty ? 0 : (correctAnswers.value / exercises.length) * 100;

  double get incorrectPercentage =>
      exercises.isEmpty ? 0 : (incorrectAnswers.value / exercises.length) * 100;

  void checkAnswer(String userAnswer) {
    // Don't process if already processing an answer
    if (isProcessingAnswer.value) return;

    // Don't allow empty answers for auditory memory questions
    if (currentQuestion.type == ExerciseType.auditoryMemory &&
        userAnswer.trim().isEmpty) {
      return;
    }

    isProcessingAnswer.value = true;

    final question = currentQuestion;
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime.value!).inMilliseconds / 1000;

    final normalizedUser = userAnswer.replaceAll(RegExp(r'\s+'), '');
    final normalizedAnswer = question.answer.replaceAll(RegExp(r'\s+'), '');
    final isCorrect = normalizedUser == normalizedAnswer;

    if (isCorrect) {
      correctAnswers.value++;
      feedback.value = "✔️ إجابة صحيحة";
    } else {
      incorrectAnswers.value++;
      feedback.value = "❌ خطأ. الإجابة: ${question.answer}";
    }

    results.add(QuizResult(
      question: question.question,
      userAnswer: userAnswer,
      correctAnswer: question.answer,
      isCorrect: isCorrect,
      duration: duration,
    ));

    showFeedback.value = true;

    // Speak feedback without emojis and wait for completion
    String speechText =
        isCorrect ? "إجابة صحيحة" : "خطأ. الإجابة: ${question.answer}";

    TtsService.to.speak(
        text: speechText,
        screenName: 'TestScreen',
        language: 'ar-SA',
        onComplete: () {
          // Only proceed to next question after TTS is complete
          showFeedback.value = false;
          currentQuestionIndex.value++;
          startTime.value = DateTime.now();
          isProcessingAnswer.value = false;
        });
  }

  String getRiskLevel() {
    final score = correctAnswers.value / exercises.length;
    final totalDuration =
        results.fold<double>(0, (sum, result) => sum + result.duration);
    final avgTime = totalDuration / exercises.length;

    if (score >= 0.8 && avgTime < 10) {
      return "خطر منخفض";
    } else if (score >= 0.5 && avgTime < 15) {
      return "خطر متوسط";
    } else {
      return "خطر مرتفع";
    }
  }

  Color getRiskColor() {
    final riskLevel = getRiskLevel();
    if (riskLevel == "خطر منخفض") {
      return Colors.green;
    } else if (riskLevel == "خطر متوسط") {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getTotalTime() {
    final totalDuration =
        results.fold<double>(0, (sum, result) => sum + result.duration);
    final minutes = (totalDuration / 60).floor();
    final seconds = (totalDuration % 60).round();
    return "$minutes دقيقة و $seconds ثانية";
  }
}
