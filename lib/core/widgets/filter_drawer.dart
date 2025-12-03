// lib/features/listings_screen/widgets/filter_drawer.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../features/listings_screen/widgets/property_filters.dart';
import '../../../../../core/config/theme/src/colors.dart';

class FilterDrawer extends StatefulWidget {
  final PropertyFilters currentFilters;
  final ValueChanged<PropertyFilters> onApplyFilters;
  final VoidCallback onResetFilters;

  const FilterDrawer({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
    required this.onResetFilters,
  });

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  late PropertyFilters _filters;
  late RangeValues _priceRange;

  final List<Map<String, String?>> cityOptions = const [
    {'label': 'جميع المدن', 'value': null},
    {'label': 'دمشق', 'value': 'damascus'},
    {'label': 'اللاذقية', 'value': 'latakia'},
    {'label': 'حلب', 'value': 'aleppo'},
    {'label': 'السويداء', 'value': 'as_suwayda'},
    {'label': 'درعا', 'value': 'daraa'},
    {'label': 'دير الزور', 'value': 'deir_ez_zor'},
    {'label': 'حماة', 'value': 'hama'},
    {'label': 'الحسكة', 'value': 'al_hasakah'},
    {'label': 'حمص', 'value': 'homs'},
    {'label': 'طرطوس', 'value': 'tartus'},
    {'label': 'إدلب', 'value': 'idlib'},
    {'label': 'القنيطرة', 'value': 'quneitra'},
    {'label': 'ريف دمشق', 'value': 'rif_dimashq'},
  ];

  final List<Map<String, String>> availabilityOptions = [
    {'label': 'إيجار', 'value': 'rent'},
    {'label': 'شراء', 'value': 'buy'},
  ];

  final List<Map<String, String>> propertyTypeOptions = [
    {'label': 'شقة', 'value': 'apartment'},
    {'label': 'فيلا', 'value': 'villa'},
    {'label': 'أرض', 'value': 'land'},
    {'label': 'مكتب', 'value': 'office'},
    {'label': 'مستودع', 'value': 'warehouse'},
    {'label': 'متجر', 'value': 'store'},
  ];

  final List<String> bedsOptions = ['0', '1', '2', '3', '4', '5+'];
  final List<String> bathsOptions = ['0', '1', '2', '3', '4+'];

  final List<Map<String, String>> amenitiesOptions = [
    {'label': 'إطلالة على البحيرة', 'value': 'Lake View'},
    {'label': 'موقد', 'value': 'Fireplace'},
    {'label': 'التدفئة المركزية وتكييف الهواء', 'value': 'Central heating and air conditioning'},
    {'label': 'رصيف', 'value': 'Dock'},
    {'label': 'حديقة', 'value': 'Garden'},
  ];

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters.copyWith();
    _priceRange = RangeValues(
      _filters.minPrice ?? 300,
      _filters.maxPrice ?? 1000000.0,
    );
  }

  void _applyFilters() {
    widget.onApplyFilters(_filters.copyWith(
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      availability: _filters.availability,
      propertyType: _filters.propertyType,
      city: _filters.city,
      bedrooms: _filters.bedrooms,
      bathrooms: _filters.bathrooms,
      amenities: _filters.amenities,
    ));
  }

  void _resetFilters() {
    widget.onResetFilters();
    setState(() {
      _filters = const PropertyFilters();
      _priceRange = const RangeValues(0, 5000000);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _applyFilters();
                  Scaffold.of(context).closeEndDrawer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.auroraBluePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('تطبيق كل الفلاتر', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('نوع الإعلان'),
                  _buildChoiceSection(
                    options: availabilityOptions,
                    selected: _filters.availability,
                    onSelected: (v) => setState(() => _filters = _filters.copyWith(availability: v)),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader('نوع العقار'),
                  _buildChoiceSection(
                    options: propertyTypeOptions,
                    selected: _filters.propertyType,
                    onSelected: (v) => setState(() => _filters = _filters.copyWith(propertyType: v)),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader('المدينة'),
                  _buildCityDropdown(),
                  const SizedBox(height: 20),
                  _buildSectionHeader('نطاق السعر'),
                  _buildPriceRange(),
                  const SizedBox(height: 20),
                  _buildSectionHeader('غرف النوم'),
                  _buildCountSection(
                    count: _filters.bedrooms,
                    options: bedsOptions,
                    onSelected: (v) => setState(() => _filters = _filters.copyWith(bedrooms: v)),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader('الحمامات'),
                  _buildCountSection(
                    count: _filters.bathrooms,
                    options: bathsOptions,
                    onSelected: (v) => setState(() => _filters = _filters.copyWith(bathrooms: v)),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader('وسائل الراحة'),
                  _buildAmenitiesSection(),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: _buildFooterButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'الفلاتر',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.auroraBluePrimary,
            ),
          ),
          TextButton(
            onPressed: () {
              _resetFilters();
              Scaffold.of(context).closeEndDrawer();
            },
            child: Text(
              'إعادة تعيين الكل',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.auroraBluePrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.house, color: AppColors.auroraBluePrimary),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceSection({
    required List<Map<String, String>> options,
    String? selected,
    required ValueChanged<String?> onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final value = option['value']!;
        final isSelected = selected == value;
        return InkWell(
          onTap: () => onSelected(isSelected ? null : value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.auroraBluePrimary : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              option['label']!.tr(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCityDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      value: _filters.city,
      hint: const Text('جميع المدن'),
      items: cityOptions.map((city) {
        return DropdownMenuItem(
          child: Text(city['label']!),
          value: city['value'],
        );
      }).toList(),
      onChanged: (value) => setState(() => _filters = _filters.copyWith(city: value)),
    );
  }

  Widget _buildPriceRange() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('الأدنى: ${_priceRange.start.round()}'),
            Text('الأعلى: ${_priceRange.end.round()}'),
          ],
        ),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 5000000,
          activeColor: AppColors.auroraBluePrimary,
          inactiveColor: AppColors.white,
          divisions: 100,
          onChanged: (values) => setState(() {
            _priceRange = values;
            _filters = _filters.copyWith(
              minPrice: values.start,
              maxPrice: values.end,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCountSection({
    required int? count,
    required List<String> options,
    required ValueChanged<int?> onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final value = int.tryParse(opt.replaceAll('+', ''));
        final isSelected = (value != null && count == value) || (opt.contains('+') && count != null && count >= value!);
        return InkWell(
          onTap: () => onSelected(isSelected ? null : value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.auroraBluePrimary : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              opt,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: amenitiesOptions.map((option) {
        final value = option['value']!;
        final isSelected = _filters.amenities.contains(value);
        return CheckboxListTile(
          title: Text(option['label']!),
          value: isSelected,
          onChanged: (bool? isChecked) {
            setState(() {
              final newAmenities = Set<String>.from(_filters.amenities);
              if (isChecked == true) {
                newAmenities.add(value);
              } else {
                newAmenities.remove(value);
              }
              _filters = _filters.copyWith(amenities: newAmenities);
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }

  Widget _buildFooterButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _applyFilters();
            Scaffold.of(context).closeEndDrawer();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.auroraBluePrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('تطبيق الفلاتر', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
