import 'package:easy_localization/easy_localization.dart';
import 'package:aurora_app/core/navigation/navigation_service.dart';
import 'package:aurora_app/core/injection/injection.dart';

class LocalizedText {
  final String en;
  final String ar;

  LocalizedText({required this.en, required this.ar});

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(
      en: json['en'] ?? '',
      ar: json['ar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'en': en,
    'ar': ar,
  };

  String get currentLanguage {
    final context = locator<NavigationService>().context;

    // If no context or localization available, fallback to 'en'
    if (context == null) return 'en';

    final locale = EasyLocalization.of(context)?.currentLocale;
    return locale?.languageCode ?? 'en';
  }

  String get text => currentLanguage == 'ar' ? ar : en;
}
