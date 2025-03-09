import '../../../core/constants/assets.dart';

class OnboardingData {
  final String image;
  final String title;
  final String subtitle;

  OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

final List<OnboardingData> onboardingPages = [
  OnboardingData(
    image: Assets.assetsImagesOnboarding1,
    title: '! أهلاً بك \n Dsylexia Mate',
    subtitle: '.رحلتك نحو القراءة والتعلم بشكل أسهل تبدأ هنا',
  ),
  OnboardingData(
    image: Assets.assetsImagesOnboarding2,
    title: 'أدوات مساعدة تعمل \n بالذكاء الاصطناعي',
    subtitle: '.تلقى مساعدة مخصصة في القراءة والكتابة والتهجئة',
  ),
  OnboardingData(
    image: Assets.assetsImagesOnboarding3,
    title: '! تعلم من خلال ألعاب ممتعة ',
    subtitle: '.ألعاب تفاعلية لتحسين القراءة والتهجئة والفهم',
  ),
  OnboardingData(
    image: Assets.assetsImagesOnboarding4,
    title: '!أنت جاهز للبدء',
    subtitle: '!ابدأ رحلتك نحو تعلم أفضل',
  ),
];
