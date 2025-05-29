import 'package:eco_system/utility/export.dart';

class CandidateFilterModel {
  final List<DropListModel> selectedSkills;
  final List<DropListModel> selectedTags;
  final String? expectedSalaryFrom;
  final String? expectedSalaryTo;
  final String? currency;
  final String? experienceFrom;
  final String? experienceTo;
  final String? location;
  final String? applicationDate;
  final String? compatibilityRate;
  final bool expandTags;

  const CandidateFilterModel({
    this.selectedSkills = const [],
    this.selectedTags = const [],
    this.expectedSalaryFrom,
    this.expectedSalaryTo,
    this.currency,
    this.experienceFrom,
    this.experienceTo,
    this.location,
    this.applicationDate,
    this.compatibilityRate,
    this.expandTags = false,
  });

  CandidateFilterModel copyWith({
    List<DropListModel>? selectedSkills,
    List<DropListModel>? selectedTags,
    String? expectedSalaryFrom,
    String? expectedSalaryTo,
    String? currency,
    String? experienceFrom,
    String? experienceTo,
    String? location,
    String? applicationDate,
    String? compatibilityRate,
    bool? expandTags,
  }) {
    return CandidateFilterModel(
      selectedSkills: selectedSkills ?? this.selectedSkills,
      selectedTags: selectedTags ?? this.selectedTags,
      expectedSalaryFrom: expectedSalaryFrom ?? this.expectedSalaryFrom,
      expectedSalaryTo: expectedSalaryTo ?? this.expectedSalaryTo,
      currency: currency ?? this.currency,
      experienceFrom: experienceFrom ?? this.experienceFrom,
      experienceTo: experienceTo ?? this.experienceTo,
      location: location ?? this.location,
      applicationDate: applicationDate ?? this.applicationDate,
      compatibilityRate: compatibilityRate ?? this.compatibilityRate,
      expandTags: expandTags ?? this.expandTags,
    );
  }

  CandidateFilterModel reset() {
    return const CandidateFilterModel(
      selectedSkills: [],
      selectedTags: [],
      expectedSalaryFrom: null,
      expectedSalaryTo: null,
      currency: null,
      experienceFrom: null,
      experienceTo: null,
      location: null,
      applicationDate: null,
      compatibilityRate: null,
      expandTags: false,
    );
  }

  bool get isValidSalaryRange {
    if (expectedSalaryFrom == null && expectedSalaryTo == null) return true;
    final from = double.tryParse(expectedSalaryFrom ?? '0') ?? 0;
    final to = double.tryParse(expectedSalaryTo ?? '0') ?? 0;
    return from <= to;
  }

  bool get isValidCurrency {
    // Only validate currency if both salary fields are not null and not empty
    if (expectedSalaryFrom == null || expectedSalaryFrom!.isEmpty ||
        expectedSalaryTo == null || expectedSalaryTo!.isEmpty) {
      return true;
    }
    return currency != null && currency!.isNotEmpty;
  }

  bool get isValidExperienceRange {
    if (experienceFrom == null || experienceTo == null) return true;
    final from = double.tryParse(experienceFrom!) ?? 0;
    final to = double.tryParse(experienceTo!) ?? 0;
    return from <= to;
  }

  bool get hasActiveSkills => selectedSkills.isNotEmpty;

  bool get hasActiveTags => selectedTags.isNotEmpty;

  /// Checks if salary filter is active
  bool get hasActiveSalary =>
      expectedSalaryFrom != null ||
      expectedSalaryTo != null ||
      currency != null;

  /// Checks if experience filter is active
  bool get hasActiveExperience =>
      experienceFrom != null || experienceTo != null;

  /// Checks if location filter is active
  bool get hasActiveLocation => location != null;

  /// Checks if application date filter is active
  bool get hasActiveApplicationDate => applicationDate != null;

  /// Checks if compatibility rate filter is active
  bool get hasActiveCompatibilityRate => compatibilityRate != null;

  /// Validates all filter values
  /// Returns a list of validation error messages, empty if all valid
  List<String> validate() {
    final errors = <String>[];

    if (!isValidSalaryRange) {
      errors.add(allTranslations.text(LocaleKeys.salary_range_validation));
    }

    // Only validate currency if both salary fields are not null and not empty
    if (expectedSalaryFrom != null && expectedSalaryFrom!.isNotEmpty &&
        expectedSalaryTo != null && expectedSalaryTo!.isNotEmpty) {
      if (!isValidCurrency) {
        errors.add(allTranslations.text(LocaleKeys.currency_required));
      }
    }

    if (!isValidExperienceRange) {
      errors.add(allTranslations.text(LocaleKeys.experience_validation));
    }

    return errors;
  }

  bool get hasActiveFilters {
    return hasActiveSkills ||
        hasActiveTags ||
        (expectedSalaryFrom != null && expectedSalaryFrom!.isNotEmpty) ||
        (expectedSalaryTo != null && expectedSalaryTo!.isNotEmpty) ||
        (currency != null && currency!.isNotEmpty) ||
        (experienceFrom != null && experienceFrom!.isNotEmpty) ||
        (experienceTo != null && experienceTo!.isNotEmpty) ||
        (location != null && location!.isNotEmpty) ||
        (applicationDate != null && applicationDate!.isNotEmpty) ||
        (compatibilityRate != null && compatibilityRate!.isNotEmpty);
  }
}
