class BenchmarkResultRecord {
  const BenchmarkResultRecord({
    required this.questionId,
    required this.questionText,
    required this.schemaCharCount,
    required this.promptCharCount,
    required this.estimatedTokens,
    required this.rawOutput,
    required this.latencyMs,
  });

  final int questionId;
  final String questionText;
  final int schemaCharCount;
  final int promptCharCount;
  final int? estimatedTokens;
  final String rawOutput;
  final int latencyMs;
}
