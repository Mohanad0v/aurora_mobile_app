const arabicToEnglishMap = {
  // Cities
  'حلب': 'Aleppo',
  'دمشق': 'Damascus',
  'اللاذقية': 'Latakia',
  'طرطوس': 'Tartus',
  'حمص': 'Homs',
  'حماة': 'Hama',
  'درعا': 'Daraa',
  'دير الزور': 'Deir ez-Zor',
  'الرقة': 'Raqqa',
  'السويداء': 'As-Suwayda',
  'القنيطرة': 'Quneitra',
  'إدلب': 'Idlib',

  // Property Types
  'شقة': 'Apartment',
  'فيلا': 'Villa',
  'منزل': 'House',
  'استوديو': 'Studio',
  'بنتهاوس': 'Penthouse',
  'دوبلكس': 'Duplex',
  'تاون هاوس': 'Townhouse',
  'أرض': 'Land',
  'مكتب': 'Office',
  'محل تجاري': 'Shop',
  'مستودع': 'Warehouse',

  // Availability
  'إيجار': 'rent',
  'شراء': 'buy',
  'بيع': 'buy',
  'للإيجار': 'rent',
  'للبيع': 'buy'
};

String translateToBackend(String value) {
  return arabicToEnglishMap[value] ?? value;
}
