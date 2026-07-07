import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/benchmark/benchmark_questions.dart';

void main() {
  group('benchmarkQuestions', () {
    test('contains exactly six verbatim questions in order', () {
      expect(benchmarkQuestions.map((question) => question.id).toList(), [
        1,
        2,
        3,
        4,
        5,
        6,
      ]);
      expect(benchmarkQuestions.map((question) => question.text).toList(), [
        'مشاريع عالية الخطورة',
        'give me low priorities projects',
        'what is the budget of أتمتة العقود والقوانين',
        'من المسؤول عن مشروع مختبر التميز المؤسسي',
        'اكثر المشاريع تقدما من حيث المخرجات',
        'ما وصف اجتماع لجنة المتابعة',
      ]);
    });
  });
}
