import 'package:equatable/equatable.dart';

import '../../../blog/data/models/news_model.dart';
import '../../data/models/localized_text_model.dart';

/// Base interface for any object that can return a localized string.
abstract class Localizable {
  String getLocalized();
}

/// Generic Localized Text Entity
class LocalizedTextEntity extends Equatable implements Localizable {
  final String en;
  final String ar;

  const LocalizedTextEntity({required this.en, required this.ar});

  factory LocalizedTextEntity.fromJson(Map<String, dynamic> json) {
    return LocalizedTextEntity(
      en: json['en'] ?? '',
      ar: json['ar'] ?? '',
    );
  }

  @override
  List<Object?> get props => [en, ar];

  @override
  String getLocalized() => LocalizedText(en: en, ar: ar).text;

  Map<String, dynamic> toJson() => {'en': en, 'ar': ar};
}
