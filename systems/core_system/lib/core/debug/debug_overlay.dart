import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/app_config.dart';
import 'debug_log_store.dart';

/// Floating bug button, shown above every route, that opens a panel listing the
/// network requests captured by [DebugInterceptor].
///
/// Visibility is tied to `AppConfig.enableDebugOverlay`; when that is off this
/// returns [child] untouched, and because the flag is a compile-time constant
/// the whole panel is tree-shaken out of a release build.
///
/// Mounted once, in the `builder` of the app's [MaterialApp].
class DebugOverlay extends StatelessWidget {
  final Widget child;

  const DebugOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.enableDebugOverlay) return child;
    return _DebugOverlayBody(child: child);
  }
}

class _DebugOverlayBody extends StatefulWidget {
  final Widget child;

  const _DebugOverlayBody({required this.child});

  @override
  State<_DebugOverlayBody> createState() => _DebugOverlayBodyState();
}

class _DebugOverlayBodyState extends State<_DebugOverlayBody> {
  static const double _buttonSize = 48;

  Offset _offset = const Offset(16, 120);
  bool _panelOpen = false;
  DebugNetworkLog? _selectedLog;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // The panel is a dev tool: keep it left-to-right even in Arabic, where
        // mirrored JSON and URLs are unreadable.
        Directionality(
          textDirection: TextDirection.ltr,
          child: _panelOpen ? _buildPanel() : _buildFloatingButton(context),
        ),
      ],
    );
  }

  Widget _buildFloatingButton(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);

    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _offset = Offset(
              (_offset.dx + details.delta.dx)
                  .clamp(0.0, size.width - _buttonSize),
              (_offset.dy + details.delta.dy).clamp(
                padding.top,
                size.height - padding.bottom - _buttonSize,
              ),
            );
          });
        },
        onTap: () => setState(() => _panelOpen = true),
        child: Container(
          width: _buttonSize,
          height: _buttonSize,
          decoration: BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListenableBuilder(
            listenable: DebugLogStore.instance,
            builder: (context, _) {
              final count = DebugLogStore.instance.logs.length;
              return Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.bug_report,
                    color: Colors.greenAccent,
                    size: 24,
                  ),
                  if (count > 0)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return _DismissibleSheet(
      onDismiss: _closePanel,
      child: _selectedLog != null
          ? _NetworkLogDetail(
              log: _selectedLog!,
              onBack: () => setState(() => _selectedLog = null),
            )
          : _DebugPanel(
              onClose: _closePanel,
              onSelectLog: (log) => setState(() => _selectedLog = log),
            ),
    );
  }

  void _closePanel() {
    setState(() {
      _panelOpen = false;
      _selectedLog = null;
    });
  }
}

// ---------------------------------------------------------------------------
// Dismissible bottom sheet (tap outside or drag down to close)
// ---------------------------------------------------------------------------

class _DismissibleSheet extends StatelessWidget {
  final VoidCallback onDismiss;
  final Widget child;

  const _DismissibleSheet({required this.onDismiss, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onDismiss,
        child: Material(
          color: Colors.black54,
          child: GestureDetector(
            // Absorbs taps on the sheet so they do not close it.
            onTap: () {},
            child: DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.3,
              maxChildSize: 0.95,
              snap: true,
              snapSizes: const [0.3, 0.85],
              builder: (context, scrollController) {
                return NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    if (notification.extent <= 0.3) onDismiss();
                    return false;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: Column(
                      children: [
                        // Drag handle — also the surface the sheet scrolls by.
                        SingleChildScrollView(
                          controller: scrollController,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 8, bottom: 4),
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade600,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Panel: actions + log list
// ---------------------------------------------------------------------------

class _DebugPanel extends StatelessWidget {
  final VoidCallback onClose;
  final ValueChanged<DebugNetworkLog> onSelectLog;

  const _DebugPanel({required this.onClose, required this.onSelectLog});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return ListenableBuilder(
      listenable: DebugLogStore.instance,
      builder: (context, _) {
        final logs = DebugLogStore.instance.logs;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.bug_report,
                    color: Colors.greenAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Debug Tools',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${logs.length} requests',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onClose,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _ActionChip(
                    icon: Icons.delete_sweep,
                    label: 'Clear Logs',
                    color: Colors.orangeAccent,
                    onTap: DebugLogStore.instance.clear,
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade800, height: 1),
            Expanded(
              child: logs.isEmpty
                  ? Center(
                      child: Text(
                        'No network requests yet',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                        top: 4,
                        bottom: bottomPadding + 4,
                      ),
                      itemCount: logs.length,
                      separatorBuilder: (_, _) =>
                          Divider(color: Colors.grey.shade800, height: 1),
                      itemBuilder: (context, index) => _NetworkLogTile(
                        log: logs[index],
                        onTap: () => onSelectLog(logs[index]),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single log row
// ---------------------------------------------------------------------------

class _NetworkLogTile extends StatelessWidget {
  final DebugNetworkLog log;
  final VoidCallback onTap;

  const _NetworkLogTile({required this.log, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor(log),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _methodColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                log.method,
                style: TextStyle(
                  color: _methodColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _shortUrl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _subtitle,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (log.isPending)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey,
                ),
              )
            else
              Text(
                '${log.statusCode ?? 'ERR'}',
                style: TextStyle(
                  color: statusColor(log),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Color statusColor(DebugNetworkLog log) {
    if (log.isPending) return Colors.grey;
    return log.isSuccess ? Colors.greenAccent : Colors.redAccent;
  }

  Color get _methodColor {
    switch (log.method.toUpperCase()) {
      case 'GET':
        return Colors.blue;
      case 'POST':
        return Colors.green;
      case 'PUT':
      case 'PATCH':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Drops the scheme and host so the endpoint itself fits on one line.
  String get _shortUrl {
    final uri = Uri.tryParse(log.url);
    if (uri == null) return log.url;
    final path = uri.path.isEmpty ? log.url : uri.path;
    return uri.hasQuery ? '$path?${uri.query}' : path;
  }

  String get _subtitle {
    final parts = <String>[];
    if (log.duration != null) parts.add('${log.duration!.inMilliseconds}ms');
    parts.add(
      '${_two(log.timestamp.hour)}:${_two(log.timestamp.minute)}:'
      '${_two(log.timestamp.second)}',
    );
    return parts.join(' · ');
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}

// ---------------------------------------------------------------------------
// Detail view
// ---------------------------------------------------------------------------

class _NetworkLogDetail extends StatelessWidget {
  final DebugNetworkLog log;
  final VoidCallback onBack;

  const _NetworkLogDetail({required this.log, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white70,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              _Pill(text: log.method, color: Colors.blue),
              if (!log.isPending) ...[
                const SizedBox(width: 8),
                _Pill(
                  text: '${log.statusCode ?? 'ERR'}',
                  color: _NetworkLogTile.statusColor(log),
                ),
              ],
              const Spacer(),
              GestureDetector(
                onTap: () => _copy(context, log.toClipboardText()),
                child: const Icon(Icons.copy, color: Colors.white70, size: 20),
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey.shade800, height: 1),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding + 16),
            children: [
              const _SectionHeader(title: 'URL'),
              _CodeBlock(text: log.url),
              const SizedBox(height: 16),
              if (log.duration != null) ...[
                const _SectionHeader(title: 'Duration'),
                _CodeBlock(text: '${log.duration!.inMilliseconds}ms'),
                const SizedBox(height: 16),
              ],
              ..._jsonSection(context, 'Request Headers', log.requestHeaders),
              if (log.queryParameters != null)
                ..._jsonSection(
                  context,
                  'Query Parameters',
                  log.queryParameters,
                ),
              if (log.requestBody != null)
                ..._jsonSection(context, 'Request Body', log.requestBody),
              if (log.responseHeaders != null)
                ..._jsonSection(
                  context,
                  'Response Headers',
                  log.responseHeaders,
                ),
              if (log.responseBody != null)
                ..._jsonSection(context, 'Response Body', log.responseBody),
              if (log.error != null) ...[
                const _SectionHeader(title: 'Error'),
                _CodeBlock(text: log.error!, isError: true),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _jsonSection(BuildContext context, String title, dynamic data) {
    final text = DebugNetworkLog.prettyJson(data);
    return [
      _SectionHeader(title: title, onCopy: () => _copy(context, text)),
      _CodeBlock(text: text),
      const SizedBox(height: 16),
    ];
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared bits
// ---------------------------------------------------------------------------

class _Pill extends StatelessWidget {
  final String text;
  final Color color;

  const _Pill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onCopy;

  const _SectionHeader({required this.title, this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          if (onCopy != null) ...[
            const Spacer(),
            GestureDetector(
              onTap: onCopy,
              child: const Icon(Icons.copy, color: Colors.white38, size: 14),
            ),
          ],
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String text;
  final bool isError;

  const _CodeBlock({required this.text, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError
            ? Colors.redAccent.withValues(alpha: 0.1)
            : const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError
              ? Colors.redAccent.withValues(alpha: 0.3)
              : Colors.grey.shade800,
        ),
      ),
      child: SelectableText(
        text,
        style: TextStyle(
          color: isError ? Colors.redAccent : Colors.grey.shade300,
          fontSize: 12,
          fontFamily: 'monospace',
          height: 1.4,
        ),
      ),
    );
  }
}
