class JsonFixtures {
  static Map<String, dynamic> wrapperResponse({
    dynamic data,
    bool succeeded = true,
    dynamic warningErrors,
    List<dynamic>? validationErrors,
  }) {
    final Map<String, dynamic> result = <String, dynamic>{
      'succeeded': succeeded,
      'warningErrors': warningErrors,
      'validationErrors': validationErrors,
    };

    if (data == null) {
      result['data'] = <String, dynamic>{};
    } else if (data is Map) {
      result['data'] = Map<String, dynamic>.from(data);
    } else if (data is List) {
      result['data'] = List<dynamic>.from(data);
    } else {
      result['data'] = data;
    }

    return result;
  }

  static Map<String, dynamic> minimalMap() => <String, dynamic>{};
}
