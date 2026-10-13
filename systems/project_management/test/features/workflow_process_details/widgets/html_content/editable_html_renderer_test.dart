import 'package:core_system/core/config/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/workflow_process_details/widgets/tabs/stage_docs_tab/html_content/editable_html_renderer.dart';

void main() {
  const html = '''
<p>Owner: <span class="builder-shortcode-container" data-id="owner"></span></p>
<table style="border: 1px solid #cccccc">
  <tr><th>Item</th><th>Qty</th></tr>
  <tr><td>Bolts</td><td><span class="builder-shortcode-container" data-id="qty"></span></td></tr>
  <tr><td>Nuts</td></tr>
</table>
''';

  final fields = <String, dynamic>{
    'owner': {
      'meta': {'value': 'Acme', 'placeholder': 'Owner name'},
    },
    'qty': {
      'meta': {'value': '12', 'placeholder': 'Quantity'},
    },
  };

  Future<void> pumpRenderer(
    WidgetTester tester,
    String content, {
    ThemeData? theme,
  }) {
    return tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          theme: theme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: EditableHtmlRenderer(htmlContent: content, fields: fields),
            ),
          ),
        ),
      ),
    );
  }

  final themes = {'default theme': null, 'app theme': buildLightTheme()};

  themes.forEach((name, theme) {
    testWidgets('renders text, fields and tables without overflow ($name)', (
      tester,
    ) async {
      await pumpRenderer(tester, html, theme: theme);

      expect(tester.takeException(), isNull);
      expect(find.text('Owner: '), findsOneWidget);
      expect(find.text('Acme'), findsOneWidget);
      expect(find.byType(DataTable), findsOneWidget);
      expect(find.text('Item'), findsOneWidget);
      expect(find.text('Bolts'), findsOneWidget);
      // A field inside a table cell renders fully.
      expect(find.text('12'), findsOneWidget);
      // The short row is padded to the header's column count.
      expect(find.text('Nuts'), findsOneWidget);
    });
  });

  testWidgets('re-renders when the HTML content changes', (tester) async {
    await pumpRenderer(tester, '<p>First</p>');
    expect(find.text('First'), findsOneWidget);

    await pumpRenderer(tester, '<p>Second</p>');
    expect(find.text('First'), findsNothing);
    expect(find.text('Second'), findsOneWidget);
  });
}
