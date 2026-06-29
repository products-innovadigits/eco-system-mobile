import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/features/ai_assistant/local_slm/ai_inference_controller.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_install_event.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_manager.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_selection_controller.dart';
import 'package:project_management/features/ai_assistant/local_slm/model_selection_view.dart';

class AiAssistantView extends StatefulWidget {
  const AiAssistantView({
    super.key,
    this.modelSelectionController,
    this.inferenceController,
    this.modelManager,
    this.initiallyShowChat = false,
  });

  final ModelSelectionController? modelSelectionController;
  final AiInferenceController? inferenceController;
  final ModelManager? modelManager;
  final bool initiallyShowChat;

  @override
  State<AiAssistantView> createState() => _AiAssistantViewState();
}

class _AiAssistantViewState extends State<AiAssistantView> {
  final GlobalKey<AiAssistantBodyState> _chatBodyKey =
      GlobalKey<AiAssistantBodyState>();
  late bool _showChat = widget.initiallyShowChat;
  String? _selectionNotice;

  // POC_DEMO_REAL_CHAT: live download state for the Download CTA.
  StreamSubscription<ModelInstallEvent>? _downloadSub;
  bool _downloading = false;
  double _downloadProgress = 0;
  String? _downloadModelId;

  ModelManager get _modelManager =>
      widget.modelManager ?? projectManagementSl<ModelManager>();

  @override
  void dispose() {
    _downloadSub?.cancel();
    super.dispose();
  }

  /// Starts a user-initiated download for [modelId] and opens chat on success.
  void _startDownload(String modelId) {
    _downloadSub?.cancel();
    setState(() {
      _selectionNotice = null;
      _downloading = true;
      _downloadProgress = 0;
      _downloadModelId = modelId;
    });
    _downloadSub = _modelManager.downloadSelectedModel(modelId).listen((event) {
      if (!mounted) return;
      switch (event.phase) {
        case ModelInstallPhase.downloading:
          setState(() => _downloadProgress = event.progress);
        case ModelInstallPhase.installed:
          setState(() {
            _downloading = false;
            _showChat = true; // model is now active → enter chat
          });
        case ModelInstallPhase.pendingDistribution:
          setState(() {
            _downloading = false;
            _selectionNotice = event.message ??
                'Download is not available for this model yet.';
          });
        case ModelInstallPhase.failed:
          setState(() {
            _downloading = false;
            _selectionNotice =
                'Download failed (${event.failure?.name ?? 'error'}). '
                '${event.message ?? ''}'.trim();
          });
        case ModelInstallPhase.preflight:
        case ModelInstallPhase.verifying:
          break;
      }
    }, onError: (Object e) {
      if (!mounted) return;
      setState(() {
        _downloading = false;
        _selectionNotice = 'Download error: $e';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.color.primary;
    final onPrimary = context.color.onPrimary;
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: primary,
        foregroundColor: onPrimary,
        iconTheme: IconThemeData(color: onPrimary),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        title: Text(
          allTranslations.text(LocaleKeys.ai_assistant),
          style: context.textTheme.titleLarge?.copyWith(
            color: onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_showChat) ...[
            IconButton(
              tooltip: allTranslations.text(
                LocaleKeys.ai_assistant_reset_context_next,
              ),
              onPressed: () =>
                  _chatBodyKey.currentState?.queueResetContextForNextMessage(),
              icon: Icon(Icons.layers_clear_outlined, color: onPrimary),
            ),
            IconButton(
              tooltip: allTranslations.text(LocaleKeys.ai_assistant_new_chat),
              onPressed: () => _chatBodyKey.currentState?.startNewChat(),
              icon: Icon(Icons.chat_outlined, color: onPrimary),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: _showChat
            ? _buildChat()
            : _downloading
            ? _buildDownloadProgress()
            : _buildModelSelection(),
      ),
    );
  }

  Widget _buildDownloadProgress() {
    final pct = (_downloadProgress * 100).clamp(0, 100).toStringAsFixed(0);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Downloading model… $pct%',
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.color.onPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            LinearProgressIndicator(
              value: _downloadProgress > 0 ? _downloadProgress : null,
            ),
            SizedBox(height: 12.h),
            Text(
              _downloadModelId ?? '',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.color.onPrimary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChat() {
    return AiAssistantBody(
      key: _chatBodyKey,
      useLocalSlm: true,
      inferenceController: widget.inferenceController,
    );
  }

  Widget _buildModelSelection() {
    return Column(
      children: [
        if (_selectionNotice != null)
          _SelectionNotice(message: _selectionNotice!),
        Expanded(
          child: ModelSelectionView(
            controller: widget.modelSelectionController,
            showAppBar: false,
            onOpenChat: (_) {
              setState(() {
                _selectionNotice = null;
                _showChat = true;
              });
            },
            onDownloadRequired: _startDownload,
            onRepairRequired: _startDownload,
          ),
        ),
      ],
    );
  }
}

class _SelectionNotice extends StatelessWidget {
  const _SelectionNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.color.surface,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: context.color.onSurface.withValues(alpha: 0.12),
            ),
          ),
        ),
        child: Text(
          message,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.color.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
