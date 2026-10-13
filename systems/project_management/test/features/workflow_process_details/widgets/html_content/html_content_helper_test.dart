import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/workflow_process_details/model/current_step_document_model.dart';
import 'package:project_management/features/workflow_process_details/widgets/tabs/stage_docs_tab/html_content/html_content_helper.dart';

void main() {
  group('field accessors', () {
    test('read value and placeholder from a raw JSON map', () {
      final field = {
        'meta': {'value': 42, 'placeholder': 'Amount'},
      };
      expect(HtmlContentHelper.readFieldValue(field), '42');
      expect(HtmlContentHelper.readFieldPlaceholder(field), 'Amount');
    });

    test('read value and placeholder from a FieldDefinition', () {
      final field = FieldDefinition(
        meta: FieldMeta(value: 'Acme', placeholder: 'Owner'),
      );
      expect(HtmlContentHelper.readFieldValue(field), 'Acme');
      expect(HtmlContentHelper.readFieldPlaceholder(field), 'Owner');
    });

    test('return empty strings when meta or the key is missing', () {
      for (final field in [
        null,
        'not a field',
        <String, dynamic>{},
        {'meta': null},
        {'meta': 'oops'},
        {'meta': <String, dynamic>{}},
        FieldDefinition(),
      ]) {
        expect(HtmlContentHelper.readFieldValue(field), '', reason: '$field');
        expect(
          HtmlContentHelper.readFieldPlaceholder(field),
          '',
          reason: '$field',
        );
      }
    });
  });

  test('cleanText replaces non-breaking spaces', () {
    expect(HtmlContentHelper.cleanText('a b'), 'a b');
  });
}
