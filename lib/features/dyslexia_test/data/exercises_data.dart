import '../models/exercise_model.dart';

class ExercisesData {
  static List<Exercise> getExercises() {
    return [
      // Visual Discrimination (6)
      Exercise(
        type: ExerciseType.visualDiscrimination,
        question: "اختر الحرف المختلف: س س س ش س س",
        choices: ["س", "ش", "ص"],
        answer: "ش",
      ),
      Exercise(
        type: ExerciseType.visualDiscrimination,
        question: "أي من هذه الحروف لا يتطابق مع الباقي: ر ز ر ر",
        choices: ["ر", "ز", "د"],
        answer: "ز",
      ),
      Exercise(
        type: ExerciseType.visualDiscrimination,
        question: "أي من الحروف التالية يختلف عن الآخرين: ج ج خ ج؟",
        choices: ["ج", "ح", "خ"],
        answer: "خ",
      ),
      Exercise(
        type: ExerciseType.visualDiscrimination,
        question: "أي من هذه الحروف لا يشبه الباقي؟ ن ن ب ن",
        choices: ["ن", "ت", "ب"],
        answer: "ب",
      ),
      Exercise(
        type: ExerciseType.visualDiscrimination,
        question: "أي من هذه الحروف لا يشبه الآخرين؟ ب ب ت ب",
        choices: ["ب", "ت", "ث"],
        answer: "ت",
      ),
      Exercise(
        type: ExerciseType.visualDiscrimination,
        question: "اختر الحرف المختلف في الشكل: ك ك ل ك",
        choices: ["ك", "ل", "ن"],
        answer: "ل",
      ),

      // Auditory Memory (5)
      Exercise(
        type: ExerciseType.auditoryMemory,
        question: "كرر كتابة هذا التسلسل: ب ت ث",
        sequence: "ب ت ث",
        answer: "ب ت ث",
      ),
      Exercise(
        type: ExerciseType.auditoryMemory,
        question: "كرر كتابة هذا التسلسل: د ر ز",
        sequence: "د ر ز",
        answer: "د ر ز",
      ),
      Exercise(
        type: ExerciseType.auditoryMemory,
        question: "كرر كتابة هذا التسلسل: س ش ص",
        sequence: "س ش ص",
        answer: "س ش ص",
      ),
      Exercise(
        type: ExerciseType.auditoryMemory,
        question: "كرر كتابة هذا التسلسل: ط ظ ض",
        sequence: "ط ظ ض",
        answer: "ط ظ ض",
      ),
      Exercise(
        type: ExerciseType.auditoryMemory,
        question: "كرر كتابة هذا التسلسل: ع غ ف",
        sequence: "ع غ ف",
        answer: "ع غ ف",
      ),

      // Phonological Awareness (6)
      Exercise(
        type: ExerciseType.phonologicalAwareness,
        question: "ما الصوت الأول في كلمة 'كتاب'؟",
        choices: ["ك", "ب", "ت"],
        answer: "ك",
      ),
      Exercise(
        type: ExerciseType.phonologicalAwareness,
        question: "أي كلمة تنتهي بنفس الصوت مثل كلمة 'بيت'؟",
        choices: ["ماء", "زيت", "قلم"],
        answer: "زيت",
      ),
      Exercise(
        type: ExerciseType.phonologicalAwareness,
        question: "ما الصوت المشترك بين كلمتي 'سيف' و'سور'؟",
        choices: ["س", "ف", "ر"],
        answer: "س",
      ),
      Exercise(
        type: ExerciseType.phonologicalAwareness,
        question: "ما الحرف الثاني في كلمة 'تفاح'؟",
        choices: ["ف", "ت", "ح"],
        answer: "ف",
      ),
      Exercise(
        type: ExerciseType.phonologicalAwareness,
        question: "أي كلمة تبدأ بنفس صوت كلمة 'باب'؟",
        choices: ["بيت", "ماء", "تاب"],
        answer: "بيت",
      ),
      Exercise(
        type: ExerciseType.phonologicalAwareness,
        question: "اختر الكلمة التي تحتوي على صوت (ق)",
        choices: ["قلم", "كوب", "جمل"],
        answer: "قلم",
      ),

      // Rapid Automatized Naming (4)
      Exercise(
        type: ExerciseType.rapidAutomatizedNaming,
        question: "ما اسم هذه الصورة؟",
        imageEmoji: "✏️",
        choices: ["قلم", "كتاب", "مقلمة"],
        answer: "قلم",
      ),
      Exercise(
        type: ExerciseType.rapidAutomatizedNaming,
        question: "ما اسم هذه الصورة؟",
        imageEmoji: "📘",
        choices: ["كرة", "كتاب", "كرسي"],
        answer: "كتاب",
      ),
      Exercise(
        type: ExerciseType.rapidAutomatizedNaming,
        question: "ما اسم هذه الصورة؟",
        imageEmoji: "🍎",
        choices: ["تفاحة", "موزة", "برتقالة"],
        answer: "تفاحة",
      ),
      Exercise(
        type: ExerciseType.rapidAutomatizedNaming,
        question: "ما اسم هذه الصورة؟",
        imageEmoji: "🐱",
        choices: ["كلب", "قطة", "قرد"],
        answer: "قطة",
      ),

      // Letter Knowledge (3)
      Exercise(
        type: ExerciseType.letterKnowledge,
        question: "اختر الحرف (ح) من بين الحروف التالية.",
        choices: ["ج", "ح", "خ"],
        answer: "ح",
      ),
      Exercise(
        type: ExerciseType.letterKnowledge,
        question: "أي من هذه الحروف هو (ذ)؟",
        choices: ["ز", "ذ", "ر"],
        answer: "ذ",
      ),
      Exercise(
        type: ExerciseType.letterKnowledge,
        question: "أي حرف يأتي بعد (س)؟",
        choices: ["ش", "ص", "س"],
        answer: "ش",
      ),
    ];
  }
}
