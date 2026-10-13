import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/shared/model/default_response_model.dart';

DefaultResponseModel parse(Map<String, dynamic> json) =>
    DefaultResponseModel().fromJson(json) as DefaultResponseModel;

void main() {
  test('parses data sent as the message itself (ProjectStepComment)', () {
    final res = parse({
      'succeeded': true,
      'data': 'تمت العملية بنجاح',
      'warningErrors': null,
      'validationErrors': [],
    });

    expect(res.succeeded, isTrue);
    expect(res.data?.message, 'تمت العملية بنجاح');
    expect(res.data?.messageEn, isNull);
    expect(res.warningErrors, isNull);
    expect(res.validationErrors, isEmpty);
  });

  test('parses data sent as {message, messageEn}', () {
    final res = parse({
      'succeeded': false,
      'data': {'message': 'فشل', 'messageEn': 'Failed'},
    });

    expect(res.succeeded, isFalse);
    expect(res.data?.message, 'فشل');
    expect(res.data?.messageEn, 'Failed');
  });

  test('ignores data of any other shape', () {
    for (final data in [null, 42, true, <dynamic>[]]) {
      expect(
        parse({'succeeded': true, 'data': data}).data,
        isNull,
        reason: '$data',
      );
    }
  });
}
