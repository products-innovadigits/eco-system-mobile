// import 'package:flutter_test/flutter_test.dart';
// import 'package:project_management/features/project_details/model/general_progress_chart_model.dart';
// import '../../../helpers/json_fixtures.dart';
//
// void main() {
//   group('GeneralProgressChartModel', () {
//     test('fromJson parses minimal valid JSON without throwing', () {
//       final json = JsonFixtures.minimalMap();
//       expect(() => GeneralProgressChartModel().fromJson(json), returnsNormally);
//     });
//
//     test('fromJson returns correct type', () {
//       final json = JsonFixtures.minimalMap();
//       final res = GeneralProgressChartModel().fromJson(json);
//       expect(res, isA<GeneralProgressChartModel>());
//     });
//
//     test('toJson returns Map without throwing', () {
//       final model = GeneralProgressChartModel();
//       final json = model.toJson();
//       expect(json, isA<Map<String, dynamic>>());
//     });
//
//     test('round-trip does not throw', () {
//       final json = JsonFixtures.minimalMap();
//       final m = GeneralProgressChartModel().fromJson(json) as GeneralProgressChartModel;
//       expect(() => m.toJson(), returnsNormally);
//     });
//   });
//
//   group('ProgressSeriesItem', () {
//     test('fromJson parses minimal valid JSON without throwing', () {
//       final json = JsonFixtures.minimalMap();
//       expect(() => ProgressSeriesItem.fromJson(json), returnsNormally);
//     });
//
//     test('fromJson returns correct type', () {
//       final json = JsonFixtures.minimalMap();
//       final res = ProgressSeriesItem.fromJson(json);
//       expect(res, isA<ProgressSeriesItem>());
//     });
//
//     test('toJson returns Map without throwing', () {
//       final model = ProgressSeriesItem();
//       final json = model.toJson();
//       expect(json, isA<Map<String, dynamic>>());
//     });
//
//     test('round-trip does not throw', () {
//       final json = JsonFixtures.minimalMap();
//       final m = ProgressSeriesItem.fromJson(json);
//       expect(() => m.toJson(), returnsNormally);
//     });
//   });
// }
