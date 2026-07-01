class SchemaCatalog {
  SchemaCatalog._(this.json)
    : catalogVersion = _requiredString(json, 'catalog_version'),
      sourceSchemaVersion = _requiredString(json, 'source_schema_version'),
      rootTables = List.unmodifiable(_stringList(json['root_tables'])),
      tables = List.unmodifiable(_mapList(json['tables'])),
      lookups = List.unmodifiable(_mapList(json['lookups'])),
      concepts = List.unmodifiable(_mapList(json['concepts'])),
      aggregationCandidates = List.unmodifiable(
        _mapList(json['aggregation_candidates']),
      ) {
    _tableByName = {
      for (final table in tables) _requiredString(table, 'name'): table,
    };
    _relationshipById = {
      for (final relationship in relationships)
        _requiredString(relationship, 'id'): relationship,
    };
    _conceptById = {
      for (final concept in concepts) _requiredString(concept, 'id'): concept,
    };
  }

  factory SchemaCatalog.fromJson(Map<String, Object?> json) =>
      SchemaCatalog._(Map.unmodifiable(json));

  final Map<String, Object?> json;
  final String catalogVersion;
  final String sourceSchemaVersion;
  final List<String> rootTables;
  final List<Map<String, Object?>> tables;
  final List<Map<String, Object?>> lookups;
  final List<Map<String, Object?>> concepts;
  final List<Map<String, Object?>> aggregationCandidates;

  late final Map<String, Map<String, Object?>> _tableByName;
  late final Map<String, Map<String, Object?>> _relationshipById;
  late final Map<String, Map<String, Object?>> _conceptById;

  List<Map<String, Object?>> get outgoingRelationships =>
      _relationshipList('outgoing');

  List<Map<String, Object?>> get incomingRelationships =>
      _relationshipList('incoming');

  List<Map<String, Object?>> get relationshipPaths {
    final relationships = json['relationships'];
    if (relationships is! Map) return const [];
    return List.unmodifiable(_mapList(relationships['paths']));
  }

  List<Map<String, Object?>> get relationships =>
      List.unmodifiable([...outgoingRelationships, ...incomingRelationships]);

  Map<String, Object?>? table(String name) => _tableByName[name];

  Map<String, Object?>? column(String tableName, String columnName) {
    final tableJson = table(tableName);
    if (tableJson == null) return null;
    for (final columnJson in _mapList(tableJson['columns'])) {
      if (columnJson['name'] == columnName) return columnJson;
    }
    return null;
  }

  Map<String, Object?>? relationship(String id) => _relationshipById[id];

  Map<String, Object?>? concept(String id) => _conceptById[id];

  bool hasTable(String name) => table(name) != null;

  bool hasColumn(String tableName, String columnName) =>
      column(tableName, columnName) != null;

  bool hasRelationship({
    required String fromTable,
    required String fromColumn,
    required String toTable,
    required String toColumn,
  }) {
    return relationships.any(
      (relationship) =>
          relationship['from_table'] == fromTable &&
          relationship['from_column'] == fromColumn &&
          relationship['to_table'] == toTable &&
          relationship['to_column'] == toColumn,
    );
  }

  List<String> synonymsForConcept(String conceptId) {
    final conceptJson = concept(conceptId);
    if (conceptJson == null) return const [];
    final synonyms = conceptJson['synonyms'];
    if (synonyms is! Map) return const [];
    return List.unmodifiable([
      ..._stringList(synonyms['en']),
      ..._stringList(synonyms['ar']),
    ]);
  }

  List<Map<String, Object?>> _relationshipList(String key) {
    final relationships = json['relationships'];
    if (relationships is! Map) return const [];
    return List.unmodifiable(_mapList(relationships[key]));
  }
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is String && value.isNotEmpty) return value;
  throw SchemaCatalogException('Missing required string: $key');
}

List<Map<String, Object?>> _mapList(Object? value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, Object?>.from(item))
      .toList();
}

List<String> _stringList(Object? value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).where((item) {
    return item.trim().isNotEmpty;
  }).toList();
}

class SchemaCatalogException implements Exception {
  const SchemaCatalogException(this.message);

  final String message;

  @override
  String toString() => 'SchemaCatalogException: $message';
}
