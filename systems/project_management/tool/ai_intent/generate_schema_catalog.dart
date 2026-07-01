import 'dart:convert';
import 'dart:io';

const _defaultSchemaPath = 'assets/ai/schema/projects_db_metadata_schema.json';
const _defaultEnrichmentPath = 'assets/ai/schema/schema_enrichment.json';
const _defaultOutPath = 'assets/ai/schema/schema_catalog.json';

void main(List<String> args) {
  final options = _Options.parse(args);
  final schema = _readJson(options.schemaPath);
  final enrichment = _readJson(options.enrichmentPath);

  final catalog = SchemaCatalogGenerator(
    schema: schema,
    enrichment: enrichment,
  ).generate();

  final outFile = File(options.outPath);
  outFile.parent.createSync(recursive: true);
  const encoder = JsonEncoder.withIndent('  ');
  outFile.writeAsStringSync('${encoder.convert(catalog)}\n');
  stdout.writeln('Generated ${options.outPath}');
}

Map<String, dynamic> _readJson(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw StateError('Missing input file: $path');
  }
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map<String, dynamic>) {
    throw StateError('Expected JSON object in $path');
  }
  return decoded;
}

class _Options {
  const _Options({
    required this.schemaPath,
    required this.enrichmentPath,
    required this.outPath,
  });

  final String schemaPath;
  final String enrichmentPath;
  final String outPath;

  static _Options parse(List<String> args) {
    var schemaPath = _defaultSchemaPath;
    var enrichmentPath = _defaultEnrichmentPath;
    var outPath = _defaultOutPath;

    for (var i = 0; i < args.length; i++) {
      final arg = args[i];
      if (arg == '--schema' && i + 1 < args.length) {
        schemaPath = args[++i];
      } else if (arg == '--enrichment' && i + 1 < args.length) {
        enrichmentPath = args[++i];
      } else if (arg == '--out' && i + 1 < args.length) {
        outPath = args[++i];
      } else {
        throw ArgumentError('Unknown or incomplete argument: $arg');
      }
    }

    return _Options(
      schemaPath: schemaPath,
      enrichmentPath: enrichmentPath,
      outPath: outPath,
    );
  }
}

class SchemaCatalogGenerator {
  SchemaCatalogGenerator({required this.schema, required this.enrichment});

  final Map<String, dynamic> schema;
  final Map<String, dynamic> enrichment;

  final Map<String, _TableInfo> _tables = {};
  final Map<String, List<Map<String, dynamic>>> _columnOverrides = {};
  final List<Map<String, dynamic>> _allRelationships = [];

  Map<String, dynamic> generate() {
    _indexEnrichment();
    _indexTables();

    final rootTables = _stringList(
      enrichment['root_tables'],
      fallback: [schema['root_table']?.toString() ?? 'Projects'],
    );
    final excludedTables = _stringList(
      (enrichment['exclusions'] as Map?)?['tables'],
    ).toSet();
    final excludedColumns = _stringList(
      (enrichment['exclusions'] as Map?)?['columns'],
    ).toSet();
    final exclusionReasons = Map<String, dynamic>.from(
      (enrichment['exclusions'] as Map?)?['reasons'] as Map? ?? {},
    );

    final relationships = _deriveRelationships(rootTables, excludedTables);
    final lookups = _deriveLookups(relationships, rootTables);
    final concepts = _deriveConcepts(relationships, lookups);
    final aggregationCandidates = _deriveAggregationCandidates(relationships);

    final tables =
        _tables.values
            .where((table) => !excludedTables.contains(table.name))
            .map(
              (table) => _tableToCatalog(
                table,
                rootTables: rootTables,
                excludedColumns: excludedColumns,
                exclusionReasons: exclusionReasons,
              ),
            )
            .toList()
          ..sort(
            (a, b) => (a['name'] as String).compareTo(b['name'] as String),
          );

    final relationshipEdges = <Map<String, dynamic>>[
      ...relationships.outgoing,
      ...relationships.incoming,
    ];

    return {
      'catalog_version': '0.1.0',
      'source_schema_version': schema['schema_version'] ?? '0.1.0',
      'source_metadata_reference': _defaultSchemaPath,
      'generated_at': DateTime.utc(2026, 7, 1).toIso8601String(),
      'lookup_value_cap': _lookupValueCap,
      'root_tables': rootTables,
      'tables': tables,
      'relationships': {
        'outgoing': relationships.outgoing,
        'incoming': relationships.incoming,
        'paths': relationships.paths,
      },
      'relationship_edges': relationshipEdges,
      'lookups': lookups,
      'concepts': concepts,
      'aggregation_candidates': aggregationCandidates,
      'exclusions': {
        'tables': excludedTables.toList()..sort(),
        'columns': excludedColumns.toList()..sort(),
        'reasons': exclusionReasons,
      },
    };
  }

  void _indexEnrichment() {
    for (final item in _mapList(enrichment['field_overrides'])) {
      final table = item['table']?.toString();
      final column = item['column']?.toString();
      if (table == null || column == null) continue;
      _columnOverrides.putIfAbsent('$table.$column', () => []).add(item);
    }
  }

  void _indexTables() {
    final metadata = schema['schema_metadata'];
    final tables = metadata is Map ? metadata['tables'] : null;
    for (final tableJson in _mapList(tables)) {
      final name = (tableJson['table_name'] ?? tableJson['name'])?.toString();
      if (name == null || name.isEmpty) continue;
      final table = _TableInfo(
        schemaName: (tableJson['table_schema'] ?? tableJson['schema'] ?? 'dbo')
            .toString(),
        name: name,
        depth: tableJson['depth'] is int ? tableJson['depth'] as int : null,
      );
      for (final columnJson in _mapList(tableJson['columns'])) {
        final columnName = (columnJson['column_name'] ?? columnJson['name'])
            ?.toString();
        if (columnName == null || columnName.isEmpty) continue;
        table.columns[columnName] = _ColumnInfo(
          name: columnName,
          dataType: (columnJson['data_type'] ?? 'unknown').toString(),
          nullable:
              columnJson['is_nullable'] == true ||
              columnJson['nullable'] == true,
          isPrimaryKey: columnJson['is_primary_key'] == true,
          isForeignKey: columnJson['is_foreign_key'] == true,
        );
      }
      for (final fkJson in _mapList(tableJson['foreign_keys'])) {
        final fk = _ForeignKeyInfo.fromJson(fkJson);
        if (fk != null) {
          table.foreignKeys.add(fk);
          _allRelationships.add(fk.toJson());
        }
      }
      _tables[name] = table;
    }
  }

  _RelationshipBundle _deriveRelationships(
    List<String> rootTables,
    Set<String> excludedTables,
  ) {
    final outgoing = <Map<String, dynamic>>[];
    final incoming = <Map<String, dynamic>>[];
    final paths = <Map<String, dynamic>>[];

    final seenOutgoing = <String>{};
    final seenIncoming = <String>{};

    for (final fk in _foreignKeys()) {
      if (excludedTables.contains(fk.fromTable) ||
          excludedTables.contains(fk.toTable)) {
        continue;
      }
      if (!_hasColumn(fk.fromTable, fk.fromColumn) ||
          !_hasColumn(fk.toTable, fk.toColumn)) {
        continue;
      }
      final outgoingRel = _relationshipJson(
        id: _relationshipId(fk.fromTable, fk.fromColumn, fk.toTable),
        direction: 'outgoing',
        fromTable: fk.fromTable,
        fromColumn: fk.fromColumn,
        toTable: fk.toTable,
        toColumn: fk.toColumn,
        fkName: fk.name,
      );
      if (seenOutgoing.add(outgoingRel['id'] as String)) {
        outgoing.add(outgoingRel);
      }

      if (rootTables.contains(fk.toTable)) {
        final incomingRel = _relationshipJson(
          id: _relationshipId(fk.toTable, fk.toColumn, fk.fromTable),
          direction: 'incoming',
          fromTable: fk.toTable,
          fromColumn: fk.toColumn,
          toTable: fk.fromTable,
          toColumn: fk.fromColumn,
          fkName: fk.name,
        );
        if (seenIncoming.add(incomingRel['id'] as String)) {
          incoming.add(incomingRel);
        }
      }
    }

    for (final relationship in [...outgoing, ...incoming]) {
      final fromTable = relationship['from_table'] as String;
      final toTable = relationship['to_table'] as String;
      if (!rootTables.contains(fromTable)) continue;
      paths.add({
        'id': 'P_${_idPart(fromTable)}_${_idPart(toTable)}',
        'from_table': fromTable,
        'to_table': toTable,
        'hops': [
          {'relationship_id': relationship['id']},
        ],
      });
    }

    outgoing.sort(_byId);
    incoming.sort(_byId);
    paths.sort(_byId);

    return _RelationshipBundle(
      outgoing: outgoing,
      incoming: incoming,
      paths: paths,
    );
  }

  List<Map<String, dynamic>> _deriveLookups(
    _RelationshipBundle relationships,
    List<String> rootTables,
  ) {
    final lookupValues = _mapList(schema['lookup_values']);
    final rootSet = rootTables.toSet();
    // Only relationships whose source endpoint is a root table can "reach" a
    // lookup table. Both outgoing (root -> lookup) and incoming (root -> child)
    // relationships are stored with the root table as `from_table`, so a valid
    // reach is always `from_table in roots && to_table == lookup table`.
    // Matching on `from_table == lookup table` would incorrectly pick the lookup
    // table's own outgoing FKs. Outgoing is preferred (natural lookup direction),
    // then incoming; deterministic because each list is id-sorted.
    final rootConnected = [
      ...relationships.outgoing,
      ...relationships.incoming,
    ].where((r) => rootSet.contains(r['from_table'])).toList();
    final lookups = <Map<String, dynamic>>[];

    for (final lookupJson in lookupValues) {
      final table = (lookupJson['table_name'] ?? lookupJson['table'])
          ?.toString();
      final column = (lookupJson['column_name'] ?? lookupJson['column'])
          ?.toString();
      if (table == null || column == null || !_tables.containsKey(table))
        continue;
      final rel = rootConnected.cast<Map<String, dynamic>?>().firstWhere(
        (r) => r?['to_table'] == table,
        orElse: () => null,
      );
      lookups.add({
        'id': 'LK_${_idPart(table)}_${_idPart(column)}',
        'table': table,
        'column': column,
        'reached_via': rel?['id'],
        'values': _safeLookupValues(lookupJson['values']),
      });
    }

    lookups.sort(_byId);
    return lookups;
  }

  List<Map<String, dynamic>> _deriveConcepts(
    _RelationshipBundle relationships,
    List<Map<String, dynamic>> lookups,
  ) {
    final relationshipByEndpoint = {
      for (final rel in [...relationships.outgoing, ...relationships.incoming])
        _endpointKey(
          rel['from_table'] as String,
          rel['from_column'] as String,
          rel['to_table'] as String,
          rel['to_column'] as String,
        ): rel,
    };
    final lookupByEndpoint = {
      for (final lookup in lookups)
        '${lookup['table']}.${lookup['column']}': lookup,
    };

    return _mapList(enrichment['concepts']).map((concept) {
      final targets = _mapList(concept['targets']).map((target) {
        final out = Map<String, dynamic>.from(target);
        final relationship = target['relationship'];
        if (relationship is Map) {
          final rel =
              relationshipByEndpoint[_endpointKey(
                relationship['from_table'].toString(),
                relationship['from_column'].toString(),
                relationship['to_table'].toString(),
                relationship['to_column'].toString(),
              )];
          if (rel != null) out['relationship_id'] = rel['id'];
        }
        if (target['type'] == 'lookup_filter') {
          final lookup =
              lookupByEndpoint['${target['lookup_table']}.${target['lookup_column']}'];
          if (lookup != null) out['lookup_id'] = lookup['id'];
        }
        return out;
      }).toList();
      return {
        'id': concept['id'],
        'labels': concept['labels'] ?? {},
        'synonyms': concept['synonyms'] ?? {'ar': [], 'en': []},
        'targets': targets,
        'conflicts_with': _stringList(concept['conflicts_with']),
        'capabilities': _stringList(concept['capabilities']),
      };
    }).toList()..sort(_byId);
  }

  List<Map<String, dynamic>> _deriveAggregationCandidates(
    _RelationshipBundle relationships,
  ) {
    final relationshipByEndpoint = {
      for (final rel in relationships.incoming)
        _endpointKey(
          rel['from_table'] as String,
          rel['from_column'] as String,
          rel['to_table'] as String,
          rel['to_column'] as String,
        ): rel,
    };
    final candidates = <Map<String, dynamic>>[];
    for (final concept in _mapList(enrichment['concepts'])) {
      for (final target in _mapList(concept['targets'])) {
        if (target['type'] != 'aggregation') continue;
        final relationship = target['relationship'];
        Map<String, dynamic>? rel;
        if (relationship is Map) {
          rel =
              relationshipByEndpoint[_endpointKey(
                relationship['from_table'].toString(),
                relationship['from_column'].toString(),
                relationship['to_table'].toString(),
                relationship['to_column'].toString(),
              )];
        }
        candidates.add({
          'id':
              'AGG_${_idPart(concept['id'].toString())}_${_idPart(target['alias'].toString())}',
          'concept_id': concept['id'],
          'function': target['function'],
          'table': target['table'],
          'column': target['column'],
          'alias': target['alias'],
          'relationship_id': rel?['id'],
          'description':
              '${target['function']}(${target['table']}.${target['column']}) as ${target['alias']}',
        });
      }
    }
    return candidates..sort(_byId);
  }

  Map<String, dynamic> _tableToCatalog(
    _TableInfo table, {
    required List<String> rootTables,
    required Set<String> excludedColumns,
    required Map<String, dynamic> exclusionReasons,
  }) {
    final columns =
        table.columns.values.map((column) {
          final override = _mergeOverrides(
            _columnOverrides['${table.name}.${column.name}'] ?? const [],
          );
          final roles = _stringList(override['roles']);
          final qualified = '${table.name}.${column.name}';
          final excluded = excludedColumns.contains(qualified);
          final exposure = excluded
              ? 'excluded'
              : (roles.contains('safe') ? 'safe' : 'private');
          final references = _foreignKeys().cast<_ForeignKeyInfo?>().firstWhere(
            (fk) =>
                fk?.fromTable == table.name && fk?.fromColumn == column.name,
            orElse: () => null,
          );
          return {
            'name': column.name,
            'data_type': column.dataType,
            'nullable': column.nullable,
            'is_primary_key': column.isPrimaryKey,
            'is_foreign_key': column.isForeignKey,
            if (references != null)
              'references': {
                'table': references.toTable,
                'column': references.toColumn,
              },
            'roles': excluded ? <String>[] : roles,
            'exposure': exposure,
            if (excluded) 'exclusion_reason': exclusionReasons[qualified],
            'concept_tags': excluded
                ? <String>[]
                : _stringList(override['concept_tags']),
            'synonyms': excluded
                ? {'ar': <String>[], 'en': <String>[]}
                : (override['synonyms'] ??
                      {'ar': <String>[], 'en': <String>[]}),
          };
        }).toList()..sort(
          (a, b) => (a['name'] as String).compareTo(b['name'] as String),
        );

    return {
      'name': table.name,
      'schema': table.schemaName,
      'is_root': rootTables.contains(table.name),
      'primary_key': table.columns.values
          .where((column) => column.isPrimaryKey)
          .map((column) => column.name)
          .toList(),
      'depth': table.depth,
      'columns': columns,
    };
  }

  List<_ForeignKeyInfo> _foreignKeys() {
    final fks = <_ForeignKeyInfo>[];
    for (final table in _tables.values) {
      fks.addAll(table.foreignKeys);
    }
    return fks;
  }

  bool _hasColumn(String table, String column) {
    return _tables[table]?.columns.containsKey(column) ?? false;
  }

  static Map<String, dynamic> _mergeOverrides(
    List<Map<String, dynamic>> overrides,
  ) {
    final roles = <String>{};
    final tags = <String>{};
    final ar = <String>{};
    final en = <String>{};
    for (final override in overrides) {
      roles.addAll(_stringList(override['roles']));
      tags.addAll(_stringList(override['concept_tags']));
      final synonyms = override['synonyms'];
      if (synonyms is Map) {
        ar.addAll(_stringList(synonyms['ar']));
        en.addAll(_stringList(synonyms['en']));
      }
    }
    return {
      'roles': roles.toList()..sort(),
      'concept_tags': tags.toList()..sort(),
      'synonyms': {'ar': ar.toList()..sort(), 'en': en.toList()..sort()},
    };
  }

  static Map<String, dynamic> _relationshipJson({
    required String id,
    required String direction,
    required String fromTable,
    required String fromColumn,
    required String toTable,
    required String toColumn,
    required String fkName,
  }) {
    return {
      'id': id,
      'direction': direction,
      'from_table': fromTable,
      'from_column': fromColumn,
      'to_table': toTable,
      'to_column': toColumn,
      'fk_name': fkName,
    };
  }

  static String _relationshipId(
    String fromTable,
    String fromColumn,
    String toTable,
  ) {
    return 'R_${_idPart(fromTable)}_${_idPart(fromColumn)}_${_idPart(toTable)}';
  }

  static String _endpointKey(
    String fromTable,
    String fromColumn,
    String toTable,
    String toColumn,
  ) {
    return '$fromTable.$fromColumn->$toTable.$toColumn';
  }

  static String _idPart(String value) {
    return value
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '')
        .toUpperCase();
  }

  static int _byId(Map<String, dynamic> a, Map<String, dynamic> b) {
    return (a['id'] as String).compareTo(b['id'] as String);
  }

  static List<String> _safeLookupValues(Object? value) {
    return _stringList(value)
        .where((item) => !_rawSqlPattern.hasMatch(item))
        .take(_lookupValueCap)
        .toList();
  }

  static const int _lookupValueCap = 50;

  static final RegExp _rawSqlPattern = RegExp(
    r'(/\*|\*/|;|\bselect\b.+\bfrom\b|\binsert\s+into\b|\bupdate\b.+\bset\b|\bdelete\s+from\b|\bdrop\s+(table|view|database)\b|\bunion\s+select\b)',
    caseSensitive: false,
  );
}

class _RelationshipBundle {
  const _RelationshipBundle({
    required this.outgoing,
    required this.incoming,
    required this.paths,
  });

  final List<Map<String, dynamic>> outgoing;
  final List<Map<String, dynamic>> incoming;
  final List<Map<String, dynamic>> paths;
}

class _TableInfo {
  _TableInfo({
    required this.schemaName,
    required this.name,
    required this.depth,
  });

  final String schemaName;
  final String name;
  final int? depth;
  final Map<String, _ColumnInfo> columns = {};
  final List<_ForeignKeyInfo> foreignKeys = [];
}

class _ColumnInfo {
  const _ColumnInfo({
    required this.name,
    required this.dataType,
    required this.nullable,
    required this.isPrimaryKey,
    required this.isForeignKey,
  });

  final String name;
  final String dataType;
  final bool nullable;
  final bool isPrimaryKey;
  final bool isForeignKey;
}

class _ForeignKeyInfo {
  const _ForeignKeyInfo({
    required this.name,
    required this.fromTable,
    required this.fromColumn,
    required this.toTable,
    required this.toColumn,
  });

  final String name;
  final String fromTable;
  final String fromColumn;
  final String toTable;
  final String toColumn;

  static _ForeignKeyInfo? fromJson(Map<String, dynamic> json) {
    final name = json['fk_name']?.toString();
    final fromTable = json['from_table']?.toString();
    final fromColumn =
        (json['from_column'] ??
                (json['from_columns'] is List &&
                        (json['from_columns'] as List).isNotEmpty
                    ? (json['from_columns'] as List).first
                    : null))
            ?.toString();
    final toTable = (json['to_table'] ?? json['referenced_table'])?.toString();
    final toColumn =
        (json['to_column'] ??
                (json['to_columns'] is List &&
                        (json['to_columns'] as List).isNotEmpty
                    ? (json['to_columns'] as List).first
                    : null))
            ?.toString();
    if ([
      name,
      fromTable,
      fromColumn,
      toTable,
      toColumn,
    ].any((v) => v == null || v.isEmpty)) {
      return null;
    }
    return _ForeignKeyInfo(
      name: name!,
      fromTable: fromTable!,
      fromColumn: fromColumn!,
      toTable: toTable!,
      toColumn: toColumn!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fk_name': name,
      'from_table': fromTable,
      'from_column': fromColumn,
      'to_table': toTable,
      'to_column': toColumn,
    };
  }
}

List<Map<String, dynamic>> _mapList(Object? value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

List<String> _stringList(Object? value, {List<String> fallback = const []}) {
  if (value is! List) return List<String>.from(fallback);
  return value
      .map((item) => item.toString())
      .where((item) => item.isNotEmpty)
      .toList();
}
