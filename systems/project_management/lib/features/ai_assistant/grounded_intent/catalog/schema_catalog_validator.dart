import 'schema_catalog.dart';

class SchemaCatalogValidator {
  const SchemaCatalogValidator();

  List<SchemaCatalogValidationError> validate(SchemaCatalog catalog) {
    final errors = <SchemaCatalogValidationError>[];

    _validateTables(catalog, errors);
    _validateRelationships(catalog, errors);
    _validateRelationshipPaths(catalog, errors);
    _validateLookups(catalog, errors);
    _validateAggregationCandidates(catalog, errors);
    _validateConcepts(catalog, errors);
    _validateNoRawSql(catalog.json, errors);

    return errors;
  }

  void _validateTables(
    SchemaCatalog catalog,
    List<SchemaCatalogValidationError> errors,
  ) {
    for (final rootTable in catalog.rootTables) {
      if (rootTable.trim().isEmpty) {
        errors.add(const SchemaCatalogValidationError('empty_root_table'));
      } else if (!catalog.hasTable(rootTable)) {
        errors.add(
          SchemaCatalogValidationError(
            'unknown_root_table',
            reference: rootTable,
          ),
        );
      }
    }

    for (final table in catalog.tables) {
      final tableName = table['name']?.toString() ?? '';
      if (tableName.trim().isEmpty) {
        errors.add(const SchemaCatalogValidationError('empty_table'));
      }
      for (final column in _mapList(table['columns'])) {
        final columnName = column['name']?.toString() ?? '';
        if (columnName.trim().isEmpty) {
          errors.add(
            SchemaCatalogValidationError('empty_column', reference: tableName),
          );
        }
      }
    }
  }

  void _validateRelationships(
    SchemaCatalog catalog,
    List<SchemaCatalogValidationError> errors,
  ) {
    for (final relationship in catalog.relationships) {
      final id = relationship['id']?.toString() ?? '';
      final fromTable = relationship['from_table']?.toString() ?? '';
      final fromColumn = relationship['from_column']?.toString() ?? '';
      final toTable = relationship['to_table']?.toString() ?? '';
      final toColumn = relationship['to_column']?.toString() ?? '';
      if ([id, fromTable, fromColumn, toTable, toColumn].any(_isBlank)) {
        errors.add(
          SchemaCatalogValidationError(
            'empty_relationship_reference',
            reference: id,
          ),
        );
        continue;
      }
      _expectColumn(catalog, fromTable, fromColumn, errors, id);
      _expectColumn(catalog, toTable, toColumn, errors, id);
    }
  }

  void _validateRelationshipPaths(
    SchemaCatalog catalog,
    List<SchemaCatalogValidationError> errors,
  ) {
    for (final path in catalog.relationshipPaths) {
      final id = path['id']?.toString() ?? '';
      final fromTable = path['from_table']?.toString() ?? '';
      final toTable = path['to_table']?.toString() ?? '';
      if ([id, fromTable, toTable].any(_isBlank)) {
        errors.add(
          SchemaCatalogValidationError(
            'empty_relationship_path_reference',
            reference: id,
          ),
        );
      }
      if (fromTable.isNotEmpty && !catalog.hasTable(fromTable)) {
        errors.add(
          SchemaCatalogValidationError(
            'unknown_path_from_table',
            reference: '$id:$fromTable',
          ),
        );
      }
      if (toTable.isNotEmpty && !catalog.hasTable(toTable)) {
        errors.add(
          SchemaCatalogValidationError(
            'unknown_path_to_table',
            reference: '$id:$toTable',
          ),
        );
      }
      for (final hop in _mapList(path['hops'])) {
        final relationshipId = hop['relationship_id']?.toString() ?? '';
        if (relationshipId.isEmpty ||
            catalog.relationship(relationshipId) == null) {
          errors.add(
            SchemaCatalogValidationError(
              'unknown_path_relationship',
              reference: '$id:$relationshipId',
            ),
          );
        }
      }
    }
  }

  void _validateLookups(
    SchemaCatalog catalog,
    List<SchemaCatalogValidationError> errors,
  ) {
    for (final lookup in catalog.lookups) {
      final id = lookup['id']?.toString() ?? '';
      final table = lookup['table']?.toString() ?? '';
      final column = lookup['column']?.toString() ?? '';
      if ([id, table, column].any(_isBlank)) {
        errors.add(
          SchemaCatalogValidationError('empty_lookup_reference', reference: id),
        );
        continue;
      }
      _expectColumn(catalog, table, column, errors, id);
      final reachedVia = lookup['reached_via']?.toString();
      if (reachedVia != null &&
          reachedVia.isNotEmpty &&
          catalog.relationship(reachedVia) == null) {
        errors.add(
          SchemaCatalogValidationError(
            'unknown_lookup_relationship',
            reference: '$id:$reachedVia',
          ),
        );
      }
      for (final value in _stringList(lookup['values'])) {
        if (value.trim().isEmpty) {
          errors.add(
            SchemaCatalogValidationError('empty_lookup_value', reference: id),
          );
        }
      }
    }
  }

  void _validateAggregationCandidates(
    SchemaCatalog catalog,
    List<SchemaCatalogValidationError> errors,
  ) {
    for (final candidate in catalog.aggregationCandidates) {
      final id = candidate['id']?.toString() ?? '';
      final table = candidate['table']?.toString() ?? '';
      final column = candidate['column']?.toString() ?? '';
      if ([id, table, column].any(_isBlank)) {
        errors.add(
          SchemaCatalogValidationError(
            'empty_aggregation_reference',
            reference: id,
          ),
        );
        continue;
      }
      _expectColumn(catalog, table, column, errors, id);
      final relationshipId = candidate['relationship_id']?.toString() ?? '';
      if (relationshipId.isEmpty ||
          catalog.relationship(relationshipId) == null) {
        errors.add(
          SchemaCatalogValidationError(
            'unknown_aggregation_relationship',
            reference: '$id:$relationshipId',
          ),
        );
      }
    }
  }

  void _validateConcepts(
    SchemaCatalog catalog,
    List<SchemaCatalogValidationError> errors,
  ) {
    for (final concept in catalog.concepts) {
      final id = concept['id']?.toString() ?? '';
      if (id.trim().isEmpty) {
        errors.add(const SchemaCatalogValidationError('empty_concept_id'));
      }
      for (final target in _mapList(concept['targets'])) {
        final type = target['type']?.toString() ?? '';
        if (type.isEmpty) {
          errors.add(
            SchemaCatalogValidationError(
              'empty_concept_target_type',
              reference: id,
            ),
          );
        }
        if (target.containsKey('table') || target.containsKey('column')) {
          final table = target['table']?.toString() ?? '';
          final column = target['column']?.toString() ?? '';
          _expectColumn(catalog, table, column, errors, '$id:$type');
        }
        if (target.containsKey('lookup_table') ||
            target.containsKey('lookup_column')) {
          final table = target['lookup_table']?.toString() ?? '';
          final column = target['lookup_column']?.toString() ?? '';
          _expectColumn(catalog, table, column, errors, '$id:$type');
        }
        final relationshipId = target['relationship_id']?.toString();
        if (relationshipId != null &&
            relationshipId.isNotEmpty &&
            catalog.relationship(relationshipId) == null) {
          errors.add(
            SchemaCatalogValidationError(
              'unknown_concept_relationship',
              reference: '$id:$relationshipId',
            ),
          );
        }
        final lookupId = target['lookup_id']?.toString();
        if (lookupId != null &&
            lookupId.isNotEmpty &&
            !catalog.lookups.any((lookup) => lookup['id'] == lookupId)) {
          errors.add(
            SchemaCatalogValidationError(
              'unknown_concept_lookup',
              reference: '$id:$lookupId',
            ),
          );
        }
      }
    }
  }

  void _expectColumn(
    SchemaCatalog catalog,
    String table,
    String column,
    List<SchemaCatalogValidationError> errors,
    String reference,
  ) {
    if (table.trim().isEmpty || column.trim().isEmpty) {
      errors.add(
        SchemaCatalogValidationError(
          'empty_column_reference',
          reference: reference,
        ),
      );
      return;
    }
    if (!catalog.hasTable(table)) {
      errors.add(
        SchemaCatalogValidationError(
          'unknown_table',
          reference: '$reference:$table',
        ),
      );
      return;
    }
    if (!catalog.hasColumn(table, column)) {
      errors.add(
        SchemaCatalogValidationError(
          'unknown_column',
          reference: '$reference:$table.$column',
        ),
      );
    }
  }

  void _validateNoRawSql(
    Object? value,
    List<SchemaCatalogValidationError> errors, [
    String path = r'$',
  ]) {
    if (value is Map) {
      for (final entry in value.entries) {
        _validateNoRawSql(entry.value, errors, '$path.${entry.key}');
      }
      return;
    }
    if (value is List) {
      for (var i = 0; i < value.length; i++) {
        _validateNoRawSql(value[i], errors, '$path[$i]');
      }
      return;
    }
    if (value is! String) return;
    final normalized = value.toLowerCase();
    if (_rawSqlPattern.hasMatch(normalized)) {
      errors.add(
        SchemaCatalogValidationError('raw_sql_fragment', reference: path),
      );
    }
  }

  static final RegExp _rawSqlPattern = RegExp(
    r'(/\*|\*/|;|\bselect\b.+\bfrom\b|\binsert\s+into\b|\bupdate\b.+\bset\b|\bdelete\s+from\b|\bdrop\s+(table|view|database)\b|\bunion\s+select\b)',
    caseSensitive: false,
  );
}

class SchemaCatalogValidationError {
  const SchemaCatalogValidationError(this.code, {this.reference});

  final String code;
  final String? reference;

  @override
  String toString() {
    final ref = reference;
    return ref == null || ref.isEmpty ? code : '$code($ref)';
  }
}

bool _isBlank(String value) => value.trim().isEmpty;

List<Map<String, Object?>> _mapList(Object? value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, Object?>.from(item))
      .toList();
}

List<String> _stringList(Object? value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList();
}
