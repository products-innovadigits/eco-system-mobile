import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:project_management/features/workflow_process_details/widgets/tabs/stage_docs_tab/html_content/html_css_parser.dart';

void main() {
  dom.Element el(String html) => html_parser.parseFragment(html).children.first;

  group('parseColor', () {
    test('parses hex, rgb and rgba', () {
      expect(HtmlCssParser.parseColor('#ff0000'), const Color(0xFFFF0000));
      expect(HtmlCssParser.parseColor('#80ff0000'), const Color(0x80FF0000));
      expect(
        HtmlCssParser.parseColor('rgb(0, 128, 255)'),
        const Color.fromARGB(255, 0, 128, 255),
      );
      expect(
        HtmlCssParser.parseColor('rgba(0,0,0,0.5)'),
        const Color.fromARGB(128, 0, 0, 0),
      );
    });

    test('uses the first token of multi-token values', () {
      expect(
        HtmlCssParser.parseColor('#00ff00 center'),
        const Color(0xFF00FF00),
      );
    });

    test('returns null for transparent, none and malformed values', () {
      expect(HtmlCssParser.parseColor(null), isNull);
      expect(HtmlCssParser.parseColor('transparent'), isNull);
      expect(HtmlCssParser.parseColor('none'), isNull);
      expect(HtmlCssParser.parseColor('#zzzzzz'), isNull);
      expect(HtmlCssParser.parseColor('rgba(0,0,0,1.2.3)'), isNull);
    });
  });

  test('background prefers bgcolor over style', () {
    expect(
      HtmlCssParser.background(
        el('<div bgcolor="#ff0000" style="background-color: #00ff00"></div>'),
      ),
      const Color(0xFFFF0000),
    );
    expect(
      HtmlCssParser.background(el('<div style="background: #00ff00"></div>')),
      const Color(0xFF00FF00),
    );
  });

  test('padding supports 1, 2 and 4 values', () {
    expect(
      HtmlCssParser.padding(el('<div style="padding: 4px"></div>')),
      const EdgeInsets.all(4),
    );
    expect(
      HtmlCssParser.padding(el('<div style="padding: 4px 8px"></div>')),
      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    );
    expect(
      HtmlCssParser.padding(el('<div style="padding: 1px 2px 3px 4px"></div>')),
      const EdgeInsets.only(top: 1, right: 2, bottom: 3, left: 4),
    );
    expect(
      HtmlCssParser.padding(el('<div style="padding: 1px 2px 3px"></div>')),
      EdgeInsets.zero,
    );
  });

  group('tableBorder', () {
    test('draws vertical lines only from the border shorthand', () {
      final border = HtmlCssParser.tableBorder(
        el('<table style="border: 2px solid #0000ff"></table>'),
      )!;
      const side = BorderSide(color: Color(0xFF0000FF), width: 2);
      expect(border.left, side);
      expect(border.verticalInside, side);
      expect(border.top, BorderSide.none);
      expect(border.horizontalInside, BorderSide.none);
    });

    test('uses the border attribute width with a styled color', () {
      final border = HtmlCssParser.tableBorder(
        el('<table border="1" style="border-color: #0000ff"></table>'),
      );
      expect(border?.left.width, 1);
    });

    test('returns null without a color from the response', () {
      expect(
        HtmlCssParser.tableBorder(el('<table border="1"></table>')),
        isNull,
      );
    });
  });
}
