import 'package:flutter/material.dart';
import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_selection_controller.dart';

/// Model Selection screen (M2).
///
/// Shows the catalog as cards with installed/active state and a Download/Use/
/// Repair CTA. **No download, no inference, no navigation is performed here.**
/// Opening this screen never starts a download. Taps delegate to
/// [ModelSelectionController.onSelect] and the resulting planned action is
/// surfaced via optional callbacks (so a future step wires real routing) or a
/// placeholder SnackBar.
///
/// NOTE (deliberate, POC scope): uses standard Material theming and fixed
/// spacing (not the app's custom `context.color`/ScreenUtil extensions) so the
/// screen is self-contained and unit/widget-testable without app bootstrapping.
/// Localized AR/EN labels are a later polish task; strings here are literals.
class ModelSelectionView extends StatefulWidget {
  const ModelSelectionView({
    super.key,
    this.controller,
    this.onOpenChat,
    this.onDownloadRequired,
    this.onRepairRequired,
    this.showAppBar = true,
  });

  /// Defaults to the DI-registered controller when null.
  final ModelSelectionController? controller;

  /// Called when an installed model is selected and set active. If null, a
  /// placeholder SnackBar is shown (no navigation in M2).
  final void Function(String modelId)? onOpenChat;

  /// Called when a not-installed model is tapped. **Must not download in M2.**
  /// If null, a placeholder SnackBar is shown. M3 wires the real download.
  final void Function(String modelId)? onDownloadRequired;

  /// Called when a corrupt model is tapped (repair/redownload). If null, a
  /// placeholder SnackBar is shown.
  final void Function(String modelId)? onRepairRequired;

  /// Allows the selection cards to be embedded inside the real AI Assistant
  /// shell without creating a nested app bar.
  final bool showAppBar;

  @override
  State<ModelSelectionView> createState() => _ModelSelectionViewState();
}

class _ModelSelectionViewState extends State<ModelSelectionView> {
  late final ModelSelectionController _controller =
      widget.controller ?? projectManagementSl<ModelSelectionController>();

  Future<void> _onTapCard(String modelId) async {
    final action = await _controller.onSelect(modelId);
    if (!mounted) return;
    setState(() {}); // refresh active/CTA state
    switch (action) {
      case OpenChatRequested():
        if (widget.onOpenChat != null) {
          widget.onOpenChat!(action.modelId);
        } else {
          _snack('“${action.modelId}” is now the active model.');
        }
      case DownloadRequired():
        if (widget.onDownloadRequired != null) {
          widget.onDownloadRequired!(action.modelId);
        } else {
          _snack(
            'This model must be downloaded before offline chat can start. '
            'Download is not available yet because the model distribution URL/checksum is pending.',
          );
        }
      case RepairRequired():
        if (widget.onRepairRequired != null) {
          widget.onRepairRequired!(action.modelId);
        } else {
          _snack('“${action.modelId}” needs repair/redownload.');
        }
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final cards = _controller.buildCards();
    final body = ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cards.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _ModelCard(
        card: cards[index],
        onTap: () => _onTapCard(cards[index].id),
      ),
    );
    if (!widget.showAppBar) return body;
    return Scaffold(
      appBar: AppBar(title: const Text('Choose AI model')),
      body: body,
    );
  }
}

class _ModelCard extends StatelessWidget {
  const _ModelCard({required this.card, required this.onTap});

  final ModelCardViewModel card;
  final VoidCallback onTap;

  String get _ctaLabel => switch (card.cta) {
    ModelCtaType.download => 'Download',
    ModelCtaType.use => 'Use',
    ModelCtaType.repair => 'Repair',
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    card.displayName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (card.isInstalled)
                  Icon(Icons.check_circle, size: 18, color: scheme.primary),
                if (card.isActive)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: _Badge(label: 'Active', color: scheme.primary),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(card.estimatedSizeLabel, style: textTheme.labelMedium),
                const SizedBox(width: 8),
                if (card.recommendationLabel.isNotEmpty)
                  _Badge(
                    label: card.recommendationLabel,
                    color: scheme.secondary,
                  ),
                if (card.gated)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _Badge(label: 'Gated', color: scheme.error),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(card.shortDescription, style: textTheme.bodyMedium),
            if (card.isInstalled)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Installed',
                  style: textTheme.labelSmall?.copyWith(color: scheme.primary),
                ),
              ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(onPressed: onTap, child: Text(_ctaLabel)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
