import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/features/ai_assistant/m0_probe/m0_probe_controller.dart';

/// Dev-only **M0 measurement probe** screen.
///
/// The tester types ONLY a natural-language question and taps Run. The harness
/// internally loads the fixed prompt template, injects the question into the
/// `{{USER_QUESTION}}` placeholder, calls the existing `LocalSlmService`, and
/// shows the raw output + latency. No automatic pass/fail; the manual-check
/// fields are for the human to record their judgement.
///
/// Self-contained Material UI (like `ModelSelectionView`) so it needs no app
/// bootstrapping. Reachable only behind the `kM0ProbeEnabled` build flag.
class M0ProbeView extends StatefulWidget {
  const M0ProbeView({super.key, this.controller});

  /// Defaults to the DI-registered controller when null.
  final M0ProbeController? controller;

  @override
  State<M0ProbeView> createState() => _M0ProbeViewState();
}

class _M0ProbeViewState extends State<M0ProbeView> {
  late final M0ProbeController _controller =
      widget.controller ?? projectManagementSl<M0ProbeController>();

  final TextEditingController _question = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  M0PromptVariant _variant = M0PromptVariant.depth2;
  bool _running = false;
  M0ProbeResult? _result;

  // Manual human checks (no automatic scoring).
  String _validJson = 'manual';
  String _schemaGrounded = 'manual';
  String _hallucinated = 'manual';

  @override
  void dispose() {
    _question.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    if (_running) return;
    setState(() {
      _running = true;
      _result = null;
    });
    final result = await _controller.run(
      question: _question.text,
      variant: _variant,
    );
    if (!mounted) return;
    setState(() {
      _running = false;
      _result = result;
    });
  }

  Future<void> _copyOutput() async {
    final text = _result?.rawOutput;
    if (text == null) return;
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Raw output copied')));
  }

  @override
  Widget build(BuildContext context) {
    final r = _result;
    return Scaffold(
      appBar: AppBar(title: const Text('M0 Probe (dev)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'M0 measurement harness — enter only the question. The prompt is '
              'assembled internally. Not the Intent pipeline.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _question,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'User question (AR / EN / mixed)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Schema slice: '),
                const SizedBox(width: 8),
                SegmentedButton<M0PromptVariant>(
                  segments: const [
                    ButtonSegment(
                      value: M0PromptVariant.depth2,
                      label: Text('depth-2'),
                    ),
                    ButtonSegment(
                      value: M0PromptVariant.depth1,
                      label: Text('depth-1 fallback'),
                    ),
                  ],
                  selected: {_variant},
                  onSelectionChanged: _running
                      ? null
                      : (s) => setState(() => _variant = s.first),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _running ? null : _run,
              icon: _running
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(_running ? 'Running…' : 'Run'),
            ),
            const SizedBox(height: 16),
            if (r != null) ...[
              Row(
                children: [
                  Text('Variant: ${r.variant.label}'),
                  const Spacer(),
                  Text(
                    r.latencyMs != null ? 'Latency: ${r.latencyMs} ms' : '—',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                'Prompt: ${r.promptChars} chars (~${r.approxPromptTokens} tokens)',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              if (r.error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: const Color(0x33FF0000),
                  child: Text('Error: ${r.error}'),
                ),
              if (r.rawOutput != null) ...[
                Row(
                  children: [
                    const Text(
                      'Raw model output',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _copyOutput,
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy'),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxHeight: 280),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0x11000000),
                    border: Border.all(color: const Color(0x33000000)),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      r.rawOutput!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Text(
                'Manual checks (you decide — no auto pass/fail)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _tristate(
                'Valid JSON',
                _validJson,
                (v) => setState(() => _validJson = v),
              ),
              _tristate(
                'Schema-grounded',
                _schemaGrounded,
                (v) => setState(() => _schemaGrounded = v),
              ),
              _tristate(
                'Hallucinated table/column',
                _hallucinated,
                (v) => setState(() => _hallucinated = v),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notes,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Record these in result_recording_template.md. G-M0 stays pending '
                'until a human reviews all results.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tristate(String label, String value, ValueChanged<String> onChanged) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        DropdownButton<String>(
          value: value,
          onChanged: (v) => v == null ? null : onChanged(v),
          items: const [
            DropdownMenuItem(value: 'yes', child: Text('Yes')),
            DropdownMenuItem(value: 'no', child: Text('No')),
            DropdownMenuItem(value: 'manual', child: Text('—')),
          ],
        ),
      ],
    );
  }
}
