import 'dart:convert';

import 'package:project_management/features/ai_assistant/local_slm/model_installation_state.dart';

/// Minimal key/value persistence abstraction used only for **model state**.
///
/// A durable binding (Hive via `core_system`, or `shared_preferences`) is
/// injected at DI wiring time (M2/M3). The in-memory binding below is used for
/// unit tests and as the temporary default until the durable backend is wired.
///
/// IMPORTANT: this store persists model state ONLY. Chat history is never
/// stored here (phase-1 chat stays in-memory in the UI).
abstract class ModelStateStore {
  String? read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);

  /// All keys currently present (used to enumerate installed-model records).
  Iterable<String> keys();
}

/// Non-durable [ModelStateStore] for tests and pre-wiring default.
class InMemoryModelStateStore implements ModelStateStore {
  final Map<String, String> _data = {};

  @override
  String? read(String key) => _data[key];

  @override
  Future<void> write(String key, String value) async => _data[key] = value;

  @override
  Future<void> delete(String key) async => _data.remove(key);

  @override
  Iterable<String> keys() => _data.keys.toList(growable: false);
}

/// Persisted state for one installed model (model state only — no chat data).
class InstalledModelRecord {
  const InstalledModelRecord({
    required this.id,
    required this.version,
    required this.checksum,
    required this.localPath,
    required this.status,
  });

  final String id;
  final String version;
  final String checksum;
  final String localPath;
  final ModelInstallationState status;

  InstalledModelRecord copyWith({
    String? version,
    String? checksum,
    String? localPath,
    ModelInstallationState? status,
  }) {
    return InstalledModelRecord(
      id: id,
      version: version ?? this.version,
      checksum: checksum ?? this.checksum,
      localPath: localPath ?? this.localPath,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'version': version,
    'checksum': checksum,
    'localPath': localPath,
    'status': status.wireName,
  };

  factory InstalledModelRecord.fromJson(Map<String, dynamic> json) {
    return InstalledModelRecord(
      id: (json['id'] ?? '').toString(),
      version: (json['version'] ?? '').toString(),
      checksum: (json['checksum'] ?? '').toString(),
      localPath: (json['localPath'] ?? '').toString(),
      status: ModelInstallationStateX.fromWireName(json['status'] as String?),
    );
  }
}

/// Persists **model state only**: per-model [InstalledModelRecord]s plus the
/// active/last-selected model id. Backed by an injected [ModelStateStore].
///
/// Does NOT download anything and does NOT persist chat history.
class ActiveModelStore {
  ActiveModelStore({required ModelStateStore store}) : _store = store;

  final ModelStateStore _store;

  static const String _activeKey = 'ai_slm.active_model_id';
  static const String _recordPrefix = 'ai_slm.model.';

  String _recordKey(String id) => '$_recordPrefix$id';

  // ── Active model ──────────────────────────────────────────────────────────

  /// The active/last-selected model id, or null if none chosen yet.
  String? get activeModelId => _store.read(_activeKey);

  /// Sets the active model. Does not validate installation here (caller/
  /// ModelSelectionController validates before activating an installed model).
  Future<void> setActiveModel(String id) => _store.write(_activeKey, id);

  Future<void> clearActiveModel() => _store.delete(_activeKey);

  // ── Per-model records ───────────────────────────────────────────────────--

  InstalledModelRecord? recordOf(String id) {
    final raw = _store.read(_recordKey(id));
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw);
      if (map is Map<String, dynamic>) return InstalledModelRecord.fromJson(map);
      return null;
    } catch (_) {
      return null;
    }
  }

  ModelInstallationState statusOf(String id) =>
      recordOf(id)?.status ?? ModelInstallationState.notInstalled;

  bool isInstalled(String id) => statusOf(id).isUsable;

  /// All persisted records (any status).
  List<InstalledModelRecord> allRecords() {
    final out = <InstalledModelRecord>[];
    for (final key in _store.keys()) {
      if (!key.startsWith(_recordPrefix)) continue;
      final raw = _store.read(key);
      if (raw == null || raw.isEmpty) continue;
      try {
        final map = jsonDecode(raw);
        if (map is Map<String, dynamic>) {
          out.add(InstalledModelRecord.fromJson(map));
        }
      } catch (_) {
        // Skip corrupt entries.
      }
    }
    return out;
  }

  /// Only records currently marked installed.
  List<InstalledModelRecord> installedModels() =>
      allRecords().where((r) => r.status.isUsable).toList(growable: false);

  Future<void> _save(InstalledModelRecord record) =>
      _store.write(_recordKey(record.id), jsonEncode(record.toJson()));

  /// Marks a model installed with its verified version/checksum/path.
  Future<void> markInstalled({
    required String id,
    required String version,
    required String checksum,
    required String localPath,
  }) {
    return _save(
      InstalledModelRecord(
        id: id,
        version: version,
        checksum: checksum,
        localPath: localPath,
        status: ModelInstallationState.installed,
      ),
    );
  }

  /// Marks a model corrupt (checksum/version mismatch). Keeps known fields.
  Future<void> markCorrupt(String id) async {
    final existing = recordOf(id);
    final record =
        (existing ??
                InstalledModelRecord(
                  id: id,
                  version: '',
                  checksum: '',
                  localPath: '',
                  status: ModelInstallationState.corrupt,
                ))
            .copyWith(status: ModelInstallationState.corrupt);
    await _save(record);
  }

  /// Removes a model's persisted record (and clears active if it pointed here).
  Future<void> clear(String id) async {
    await _store.delete(_recordKey(id));
    if (activeModelId == id) await clearActiveModel();
  }
}
