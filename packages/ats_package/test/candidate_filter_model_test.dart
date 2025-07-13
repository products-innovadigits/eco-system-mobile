import 'dart:ui';

import 'package:ats_package/talent_pool/model/candidate_filter_model.dart';
import 'package:core_package/core/helpers/translation/all_translation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTranslations implements  GlobalTranslations {
  @override
  String text(String key) => key;

  @override
  var locale;

  @override
  // TODO: implement currentLanguage
  get currentLanguage => throw UnimplementedError();

  @override
  getPreferredLanguage() {
    // TODO: implement getPreferredLanguage
    throw UnimplementedError();
  }

  @override
  Future<void> init([String? language]) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<void> setNewLanguage([String? newLanguage, bool saveInPrefs = true, BuildContext? context]) {
    // TODO: implement setNewLanguage
    throw UnimplementedError();
  }

  @override
  setPreferredLanguage(String lang) {
    // TODO: implement setPreferredLanguage
    throw UnimplementedError();
  }

  @override
  Iterable<Locale> supportedLocales() {
    // TODO: implement supportedLocales
    throw UnimplementedError();
  }

  @override
  set onLocaleChangedCallback(VoidCallback callback) {
    // TODO: implement onLocaleChangedCallback
  }
}

void main() {
  setUp(() {
    allTranslations = FakeTranslations();
  });

  group('CandidateFilterModel.validate', () {
    test('returns salary_range_validation when salaryMin > salaryMax', () {
      final model = CandidateFilterModel(salaryMin: '100', salaryMax: '50');
      final errors = model.validate();
      expect(errors, contains('salary_range_validation'));
    });

    test('returns currency_required when currency is missing', () {
      final model = CandidateFilterModel(salaryMin: '50', salaryMax: '100');
      final errors = model.validate();
      expect(errors, contains('currency_required'));
    });

    test('returns experience_validation when experienceFrom > experienceTo', () {
      final model = CandidateFilterModel(experienceFrom: '3', experienceTo: '2');
      final errors = model.validate();
      expect(errors, contains('experience_validation'));
    });
  });
}