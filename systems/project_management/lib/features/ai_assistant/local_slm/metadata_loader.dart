import 'dart:convert';

import 'package:flutter/services.dart';

/// Loads and validates mobile-safe prompt metadata for phase-1 local replies.
///
/// Metadata is context only. It must stay small, generic, and free of secrets,
/// raw production records, access rules, or implementation details.
class MetadataLoader {
  const MetadataLoader({
    AssetBundle? assetBundle,
    this.assetPath = defaultAssetPath,
  }) : _assetBundle = assetBundle;

  static const String defaultAssetPath = 'assets/ai/metadata.sample.json';

  final AssetBundle? _assetBundle;
  final String assetPath;

  Future<MetadataBundle?> load() async {
    final bundle = _assetBundle ?? rootBundle;
    // The asset is declared in the `project_management` package, so in a host
    // app it is bundled under `packages/<name>/`. Try the bare path (works when
    // this package is the app/test root) then the package-prefixed path.
    final candidates = <String>[
      assetPath,
      'packages/project_management/$assetPath',
    ];
    String? text;
    for (final path in candidates) {
      try {
        text = await bundle.loadString(path);
        break;
      } catch (_) {
        // try next candidate
      }
    }
    if (text == null) return null; // asset absent → optional context skipped
    try {
      return parse(text);
    } on MetadataValidationException {
      rethrow;
    } on FormatException catch (e) {
      throw MetadataValidationException('Malformed metadata: ${e.message}');
    }
  }

  MetadataBundle parse(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, Object?>) {
      throw const MetadataValidationException(
        'Metadata root must be an object.',
      );
    }
    return MetadataBundle.fromJson(decoded);
  }

  MetadataBundle? tryParse(String source) {
    try {
      return parse(source);
    } on MetadataValidationException {
      return null;
    } on FormatException {
      return null;
    }
  }
}

class MetadataValidationException implements Exception {
  const MetadataValidationException(this.message);
  final String message;

  @override
  String toString() => 'MetadataValidationException: $message';
}

class MetadataBundle {
  MetadataBundle({
    required this.version,
    required this.generatedAt,
    required Map<String, MetadataDomain> domains,
  }) : domains = Map.unmodifiable(domains);

  factory MetadataBundle.fromJson(Map<String, Object?> json) {
    _rejectForbiddenKeys(json);

    final version = _requiredString(json, 'version');
    final generatedAtText = _requiredString(json, 'generated_at');
    final generatedAt = DateTime.tryParse(generatedAtText);
    if (generatedAt == null) {
      throw const MetadataValidationException(
        'metadata.generated_at must be an ISO-8601 date.',
      );
    }

    final rawDomains = json['domains'];
    if (rawDomains is! Map<String, Object?>) {
      throw const MetadataValidationException(
        'metadata.domains must be an object.',
      );
    }
    final domains = <String, MetadataDomain>{};
    for (final entry in rawDomains.entries) {
      final domainJson = entry.value;
      if (domainJson is! Map<String, Object?>) {
        throw MetadataValidationException(
          'metadata.domains.${entry.key} must be an object.',
        );
      }
      domains[entry.key] = MetadataDomain.fromJson(entry.key, domainJson);
    }

    return MetadataBundle(
      version: version,
      generatedAt: generatedAt,
      domains: domains,
    );
  }

  final String version;
  final DateTime generatedAt;
  final Map<String, MetadataDomain> domains;

  bool get isEmpty => domains.isEmpty;

  String compactText({Iterable<String>? domainIds, int maxChars = 900}) {
    if (maxChars <= 0 || domains.isEmpty) return '';

    final selectedIds = domainIds == null ? domains.keys : domainIds;
    final selected = <MetadataDomain>[];
    for (final id in selectedIds) {
      final domain = domains[id];
      if (domain != null) selected.add(domain);
    }
    if (selected.isEmpty) return '';

    final lines = <String>[
      'Safe context metadata v$version (${generatedAt.toIso8601String()})',
    ];
    for (final domain in selected) {
      lines.add(domain.compactText());
    }

    final text = lines.where((line) => line.trim().isNotEmpty).join('\n');
    return text.length <= maxChars ? text : '';
  }
}

class MetadataDomain {
  MetadataDomain({
    required this.id,
    required this.label,
    required List<MetadataTerm> terms,
    required List<MetadataConcept> concepts,
    required List<MetadataEnum> enums,
  }) : terms = List.unmodifiable(terms),
       concepts = List.unmodifiable(concepts),
       enums = List.unmodifiable(enums);

  factory MetadataDomain.fromJson(String id, Map<String, Object?> json) {
    return MetadataDomain(
      id: id,
      label: LocalizedLabel.fromJson(_requiredMap(json, 'label')),
      terms: _listOfMaps(
        json,
        'terms',
      ).map((item) => MetadataTerm.fromJson(item)).toList(),
      concepts: _listOfMaps(
        json,
        'concepts',
      ).map((item) => MetadataConcept.fromJson(item)).toList(),
      enums: _listOfMaps(
        json,
        'enums',
      ).map((item) => MetadataEnum.fromJson(item)).toList(),
    );
  }

  final String id;
  final LocalizedLabel label;
  final List<MetadataTerm> terms;
  final List<MetadataConcept> concepts;
  final List<MetadataEnum> enums;

  String compactText() {
    final chunks = <String>['$id: ${label.compact}'];
    if (terms.isNotEmpty) {
      chunks.add('terms=${terms.map((term) => term.compact).join(', ')}');
    }
    if (concepts.isNotEmpty) {
      chunks.add(
        'concepts=${concepts.map((concept) => concept.compact).join(', ')}',
      );
    }
    if (enums.isNotEmpty) {
      chunks.add('values=${enums.map((item) => item.compact).join(', ')}');
    }
    return chunks.join(' | ');
  }
}

class MetadataTerm {
  const MetadataTerm({required this.key, required this.label});

  factory MetadataTerm.fromJson(Map<String, Object?> json) => MetadataTerm(
    key: _requiredString(json, 'key'),
    label: LocalizedLabel.fromJson(_requiredMap(json, 'label')),
  );

  final String key;
  final LocalizedLabel label;

  String get compact => '$key (${label.compact})';
}

class MetadataConcept {
  const MetadataConcept({
    required this.key,
    required this.label,
    this.description,
  });

  factory MetadataConcept.fromJson(Map<String, Object?> json) {
    final rawDescription = json['description'];
    return MetadataConcept(
      key: _requiredString(json, 'key'),
      label: LocalizedLabel.fromJson(_requiredMap(json, 'label')),
      description: rawDescription is Map<String, Object?>
          ? LocalizedLabel.fromJson(rawDescription)
          : null,
    );
  }

  final String key;
  final LocalizedLabel label;
  final LocalizedLabel? description;

  String get compact {
    final desc = description?.compact;
    return desc == null
        ? '$key (${label.compact})'
        : '$key (${label.compact}: $desc)';
  }
}

class MetadataEnum {
  MetadataEnum({required this.key, required List<MetadataTerm> values})
    : values = List.unmodifiable(values);

  factory MetadataEnum.fromJson(Map<String, Object?> json) => MetadataEnum(
    key: _requiredString(json, 'key'),
    values: _listOfMaps(
      json,
      'values',
    ).map((item) => MetadataTerm.fromJson(item)).toList(),
  );

  final String key;
  final List<MetadataTerm> values;

  String get compact =>
      '$key=[${values.map((value) => value.compact).join(', ')}]';
}

class LocalizedLabel {
  const LocalizedLabel({required this.en, required this.ar});

  factory LocalizedLabel.fromJson(Map<String, Object?> json) => LocalizedLabel(
    en: _requiredString(json, 'en'),
    ar: _requiredString(json, 'ar'),
  );

  final String en;
  final String ar;

  String get compact => '$en / $ar';
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is String && value.trim().isNotEmpty) return value.trim();
  throw MetadataValidationException(
    'metadata.$key must be a non-empty string.',
  );
}

Map<String, Object?> _requiredMap(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is Map<String, Object?>) return value;
  throw MetadataValidationException('metadata.$key must be an object.');
}

List<Map<String, Object?>> _listOfMaps(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) return const [];
  if (value is! List) {
    throw MetadataValidationException('metadata.$key must be a list.');
  }
  return value.map((item) {
    if (item is Map<String, Object?>) return item;
    throw MetadataValidationException(
      'metadata.$key contains a non-object item.',
    );
  }).toList();
}

void _rejectForbiddenKeys(Object? value, [String path = 'metadata']) {
  if (value is Map) {
    for (final entry in value.entries) {
      final key = entry.key.toString();
      if (_isForbiddenKey(key)) {
        throw MetadataValidationException(
          'Forbidden metadata key "$key" at $path.',
        );
      }
      _rejectForbiddenKeys(entry.value, '$path.$key');
    }
  } else if (value is List) {
    for (var i = 0; i < value.length; i++) {
      _rejectForbiddenKeys(value[i], '$path[$i]');
    }
  }
}

/// Forbidden as **whole tokens** (after splitting camelCase / snake_case /
/// kebab-case / spaces / punctuation). Token matching avoids substring false
/// positives — e.g. `feedback` ("db"), `borrow` ("row"), `tablet` ("table").
const Set<String> _forbiddenKeyTokens = {
  'sql',
  'database',
  'db',
  'dsn',
  'credential',
  'credentials',
  'password',
  'secret',
  'secrets',
  'token',
  'tokens',
  'apikey',
  'accesstoken', // "access_token" → tokens {access, token}; also full-join guard
  'refreshtoken',
  'tenantsecret',
  'permission',
  'permissions',
  'table',
  'tables',
  'column',
  'columns',
  'row',
  'rows',
  'schema',
  'connection',
  'connectionstring',
  'realdata',
};

bool _isForbiddenKey(String key) {
  final tokens = _tokenizeKey(key);
  // Direct token hit (handles `access_token` → {access, token} via 'token').
  if (tokens.any(_forbiddenKeyTokens.contains)) return true;
  // Also guard the fully-joined form (e.g. "connectionstring", "accesstoken")
  // for keys written without separators.
  final joined = tokens.join();
  return _forbiddenKeyTokens.contains(joined);
}

/// Splits a key into lowercase tokens across camelCase, snake_case, kebab-case,
/// spaces and other punctuation. `accessToken` → {access, token};
/// `connection_string` → {connection, string}; `feedback` → {feedback}.
List<String> _tokenizeKey(String key) {
  final withBoundaries = key.replaceAllMapped(
    RegExp(r'([a-z0-9])([A-Z])'),
    (m) => '${m[1]} ${m[2]}',
  );
  return withBoundaries
      .toLowerCase()
      .split(RegExp(r'[^a-z0-9]+'))
      .where((t) => t.isNotEmpty)
      .toList();
}
