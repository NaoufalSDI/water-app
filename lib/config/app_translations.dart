import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'maaya': 'Maaya',
      'home': 'Home',
      'skip': 'Skip',
      'next': 'Next',
      'start': 'Start',
      'onboarding_first_title': 'Track your daily water intake with us',
      'onboarding_second_title': 'Smart reminders tailored to You',
    },
    'fr_FR': {
      'maaya': 'Maaya',
      'home': 'Local',
      'skip': 'Passer',
      'next': 'Suivant',
      'start': 'Commencer',
      'onboarding_first_title':
          'Suivez votre consommation d\'eau quotidienne avec nous',
      'onboarding_second_title': 'Rappels intelligents adaptés à vous',
    },
    'ar_MA': {
      'maaya': 'ميّا',
      'home': 'التالي',
      'skip': 'تجاوز',
      'next': 'التالي',
      'start': 'ابدأ',
      'onboarding_first_title': 'تتبع شربك اليومي للماء معنا',
      'onboarding_second_title': 'تذكيرات ذكية مخصصة لك',
    },
  };
}
