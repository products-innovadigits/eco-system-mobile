import 'package:core_package/core/utility/export.dart';

class CandidateFilterModel {
  final List<DropListModel> selectedSkills;
  final List<DropListModel> selectedTags;
  final String? salaryMin;
  final String? salaryMax;
  final String? currency;
  final String? experienceFrom;
  final String? experienceTo;
  final String? location;
  final String? gender;
  final String? applicationDate;
  final String? compatibilityRate;
  final bool expandTags;

  const CandidateFilterModel({
    this.selectedSkills = const [],
    this.selectedTags = const [],
    this.salaryMin,
    this.salaryMax,
    this.currency,
    this.experienceFrom,
    this.experienceTo,
    this.location,
    this.gender,
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
    String? gender,
    String? applicationDate,
    String? compatibilityRate,
    bool? expandTags,
  }) {
    return CandidateFilterModel(
      selectedSkills: selectedSkills ?? this.selectedSkills,
      selectedTags: selectedTags ?? this.selectedTags,
      salaryMin: expectedSalaryFrom ?? this.salaryMin,
      salaryMax: expectedSalaryTo ?? this.salaryMax,
      currency: currency ?? this.currency,
      experienceFrom: experienceFrom ?? this.experienceFrom,
      experienceTo: experienceTo ?? this.experienceTo,
      location: location ?? this.location,
      gender: gender ?? this.gender,
      applicationDate: applicationDate ?? this.applicationDate,
      compatibilityRate: compatibilityRate ?? this.compatibilityRate,
      expandTags: expandTags ?? this.expandTags,
    );
  }

  CandidateFilterModel reset() {
    return const CandidateFilterModel(
      selectedSkills: [],
      selectedTags: [],
      salaryMin: null,
      salaryMax: null,
      currency: null,
      experienceFrom: null,
      experienceTo: null,
      location: null,
      gender: null,
      applicationDate: null,
      compatibilityRate: null,
      expandTags: false,
    );
  }

  bool get isValidSalaryRange {
    if (salaryMin == null && salaryMax == null) return true;
    final from = double.tryParse(salaryMin ?? '0') ?? 0;
    final to = double.tryParse(salaryMax ?? '0') ?? 0;
    return from <= to;
  }

  bool get isValidCurrency {
    // Only validate currency if both salary fields are not null and not empty
    if (salaryMin == null || salaryMin!.isEmpty ||
        salaryMax == null || salaryMax!.isEmpty) {
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
      salaryMin != null ||
      salaryMax != null ||
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
    if (salaryMin != null && salaryMin!.isNotEmpty &&
        salaryMax != null && salaryMax!.isNotEmpty) {
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
        (salaryMin != null && salaryMin!.isNotEmpty) ||
        (salaryMax != null && salaryMax!.isNotEmpty) ||
        (currency != null && currency!.isNotEmpty) ||
        (experienceFrom != null && experienceFrom!.isNotEmpty) ||
        (experienceTo != null && experienceTo!.isNotEmpty) ||
        (location != null && location!.isNotEmpty) ||
        (gender != null && gender!.isNotEmpty) ||
        (applicationDate != null && applicationDate!.isNotEmpty) ||
        (compatibilityRate != null && compatibilityRate!.isNotEmpty);
  }
}
