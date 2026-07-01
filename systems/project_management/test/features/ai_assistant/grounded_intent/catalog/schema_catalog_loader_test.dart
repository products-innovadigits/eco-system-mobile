import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/ai_assistant/grounded_intent/catalog/schema_catalog.dart';
import 'package:project_management/features/ai_assistant/grounded_intent/catalog/schema_catalog_loader.dart';
import 'package:project_management/features/ai_assistant/grounded_intent/catalog/schema_catalog_validator.dart';

void main() {
  group('SchemaCatalog v1', () {
    late SchemaCatalog catalog;
    late Map<String, Set<String>> sourceColumnsByTable;

    setUpAll(() {
      catalog = const SchemaCatalogLoader().parse(
        File('assets/ai/schema/schema_catalog.json').readAsStringSync(),
      );
      sourceColumnsByTable = _sourceColumnsByTable();
    });

    test('loads generated catalog metadata', () {
      expect(catalog.catalogVersion, '0.1.0');
      expect(catalog.sourceSchemaVersion, '0.1.0');
      expect(catalog.rootTables, contains('Projects'));
    });

    test('contains budget as a direct selectable and filterable column', () {
      final budget = catalog.column('Projects', 'Budget');

      expect(budget, isNotNull);
      expect(
        _stringList(budget!['roles']),
        containsAll(['selectable', 'filterable']),
      );
      expect(_stringList(budget['concept_tags']), contains('budget'));
      expect(_synonyms(budget), contains('budget'));
    });

    test('contains output count as a direct project column', () {
      final outputCount = catalog.column('Projects', 'OutputCount');

      expect(outputCount, isNotNull);
      expect(_stringList(outputCount!['roles']), contains('aggregatable'));
    });

    test('contains required outgoing project foreign keys', () {
      expect(
        catalog.hasRelationship(
          fromTable: 'Projects',
          fromColumn: 'PeriortyLevelId',
          toTable: 'PeriortyLevels',
          toColumn: 'Id',
        ),
        isTrue,
      );
      expect(
        catalog.hasRelationship(
          fromTable: 'Projects',
          fromColumn: 'RiskLevelId',
          toTable: 'RiskLevels',
          toColumn: 'Id',
        ),
        isTrue,
      );
      expect(
        catalog.hasRelationship(
          fromTable: 'Projects',
          fromColumn: 'ManagerId',
          toTable: 'AspNetUsers',
          toColumn: 'Id',
        ),
        isTrue,
      );
    });

    test('contains required incoming output relationship', () {
      expect(
        catalog.hasRelationship(
          fromTable: 'Projects',
          fromColumn: 'Id',
          toTable: 'ProjectOutPutModels',
          toColumn: 'ProjectId',
        ),
        isTrue,
      );
    });

    test('contains required lookup values', () {
      expect(
        _lookupValues(catalog, 'PeriortyLevels', 'Name'),
        contains('أولوية منخفضة'),
      );
      expect(
        _lookupValues(catalog, 'RiskLevels', 'Name'),
        contains('مخاطر عالية'),
      );
    });

    test('maps key synonyms to concept metadata', () {
      expect(
        catalog.synonymsForConcept('concept_priority'),
        contains('low priorities'),
      );
      expect(catalog.synonymsForConcept('concept_risk'), contains('high risk'));

      final budgetTarget = _targets(catalog, 'concept_budget').single;
      expect(budgetTarget['table'], 'Projects');
      expect(budgetTarget['column'], 'Budget');

      final outputTargets = _targets(catalog, 'concept_outputs');
      expect(
        outputTargets,
        anyElement(
          allOf(
            containsPair('type', 'column'),
            containsPair('table', 'Projects'),
            containsPair('column', 'OutputCount'),
          ),
        ),
      );
      expect(
        outputTargets,
        anyElement(
          allOf(
            containsPair('type', 'aggregation'),
            containsPair('table', 'ProjectOutPutModels'),
            containsPair('column', 'Id'),
          ),
        ),
      );
    });

    test('lookup reached_via always connects a root table to the lookup', () {
      final roots = catalog.rootTables.toSet();
      final relationshipById = {
        for (final relationship in catalog.relationships)
          relationship['id']: relationship,
      };

      for (final lookup in catalog.lookups) {
        final reachedVia = lookup['reached_via'];
        if (reachedVia == null) continue;
        final relationship = relationshipById[reachedVia];
        expect(
          relationship,
          isNotNull,
          reason: '${lookup['id']} -> $reachedVia',
        );
        expect(
          roots,
          contains(relationship!['from_table']),
          reason: '${lookup['id']} reached_via $reachedVia is not root-sourced',
        );
        expect(
          relationship['to_table'],
          lookup['table'],
          reason: '${lookup['id']} reached_via must target the lookup table',
        );
      }
    });

    test('keeps risk and priority grounded to separate lookup concepts', () {
      final riskTarget = _targets(catalog, 'concept_risk').single;
      final priorityTarget = _targets(catalog, 'concept_priority').single;

      expect(riskTarget['lookup_table'], 'RiskLevels');
      expect(riskTarget['lookup_column'], 'Name');
      expect(priorityTarget['lookup_table'], 'PeriortyLevels');
      expect(priorityTarget['lookup_column'], 'Name');
      expect(riskTarget['lookup_table'], isNot(priorityTarget['lookup_table']));
    });

    test('does not expose forbidden identity or security fields', () {
      for (final forbidden in ['UserName', 'NormalizedUserName']) {
        final column = catalog.column('AspNetUsers', forbidden);
        expect(column, isNotNull, reason: forbidden);
        expect(_stringList(column!['roles']), isEmpty, reason: forbidden);
        expect(_stringList(column['concept_tags']), isEmpty, reason: forbidden);
        expect(_synonyms(column), isEmpty, reason: forbidden);
      }
    });

    test('passes deterministic validator checks', () {
      final errors = const SchemaCatalogValidator().validate(catalog);

      expect(errors, isEmpty);
    });

    test('catalog references only source metadata tables and columns', () {
      for (final table in catalog.tables) {
        final tableName = table['name']!.toString();
        expect(sourceColumnsByTable.keys, contains(tableName));
        for (final column in _mapList(table['columns'])) {
          expect(
            sourceColumnsByTable[tableName],
            contains(column['name']),
            reason: '$tableName.${column['name']}',
          );
        }
      }
    });
  });
}

List<Map<String, Object?>> _targets(SchemaCatalog catalog, String conceptId) {
  final concept = catalog.concept(conceptId);
  expect(concept, isNotNull, reason: conceptId);
  return _mapList(concept!['targets']);
}

List<String> _lookupValues(SchemaCatalog catalog, String table, String column) {
  final lookup = catalog.lookups.firstWhere(
    (item) => item['table'] == table && item['column'] == column,
  );
  return _stringList(lookup['values']);
}

List<String> _synonyms(Map<String, Object?> json) {
  final synonyms = json['synonyms'];
  if (synonyms is! Map) return const [];
  return [..._stringList(synonyms['en']), ..._stringList(synonyms['ar'])];
}

Map<String, Set<String>> _sourceColumnsByTable() {
  final source =
      jsonDecode(
            File(
              'assets/ai/schema/projects_db_metadata_schema.json',
            ).readAsStringSync(),
          )
          as Map<String, Object?>;
  final metadata = source['schema_metadata'] as Map<String, Object?>;
  final tables = metadata['tables'] as List<Object?>;
  return {
    for (final table in tables.whereType<Map>())
      table['table_name'].toString(): {
        for (final column
            in (table['columns'] as List<Object?>).whereType<Map>())
          column['column_name'].toString(),
      },
  };
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
