class BenchmarkQuestion {
  const BenchmarkQuestion({required this.id, required this.text});

  final int id;
  final String text;
}

const benchmarkQuestions = <BenchmarkQuestion>[
  BenchmarkQuestion(id: 1, text: 'مشاريع عالية الخطورة'),
  BenchmarkQuestion(id: 2, text: 'give me low priorities projects'),
  BenchmarkQuestion(
    id: 3,
    text: 'what is the budget of أتمتة العقود والقوانين',
  ),
  BenchmarkQuestion(id: 4, text: 'من المسؤول عن مشروع مختبر التميز المؤسسي'),
  BenchmarkQuestion(id: 5, text: 'اكثر المشاريع تقدما من حيث المخرجات'),
  BenchmarkQuestion(id: 6, text: 'ما وصف اجتماع لجنة المتابعة'),
];
