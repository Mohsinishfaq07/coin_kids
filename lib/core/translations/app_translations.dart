import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'change_language': 'Change Language',
          'select_language': 'Select Language',
          'apply_changes': 'Apply Changes',
          // Add more translations here
        },
        'es_ES': {
          'change_language': 'Cambiar Idioma',
          'select_language': 'Seleccionar Idioma',
          'apply_changes': 'Aplicar Cambios',
          // Add more translations here
        },
        'ar_SA': {
          'change_language': 'تغيير اللغة',
          'select_language': 'اختر اللغة',
          'apply_changes': 'تطبيق التغييرات',
          // Add more translations here
        },
        'fr_FR': {
          'change_language': 'Changer de Langue',
          'select_language': 'Choisir la Langue',
          'apply_changes': 'Appliquer les Modifications',
          // Add more translations here
        },
        'de_DE': {
          'change_language': 'Sprache Ändern',
          'select_language': 'Sprache Auswählen',
          'apply_changes': 'Änderungen Übernehmen',
          // Add more translations here
        },
      };
}
