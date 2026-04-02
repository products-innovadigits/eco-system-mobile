import 'package:strategy_system/bsc/model/bsc_model.dart';
import 'package:strategy_system/objectives/model/objectives_model.dart';
import 'package:strategy_system/okr/model/okr_model.dart';

import 'package:core_system/core/model/custom_field_model.dart';

/// Shared JSON-shaped maps for marketing prototype (no API).
Map<String, dynamic> prototypeBscBody() => {
      'succeeded': true,
      'warningErrors': null,
      'validationErrors': null,
      'data': {
        'id': 1,
        'title': 'Vision 2030 — Prototype',
        'description': 'Strategic direction for sustainable growth and digital excellence.',
        'isActive': true,
        'missions': [
          {'id': 1, 'name': 'Customer excellence', 'vesionId': 1},
          {'id': 2, 'name': 'Operational agility', 'vesionId': 1},
        ],
        'strategicAxises': [
          {
            'id': 1,
            'title': 'Growth',
            'description': 'Scale revenue and market presence',
            'colorCode': '#1565C0',
            'isShow': true,
            'typeAxisLookupId': 1,
          },
          {
            'id': 2,
            'title': 'Innovation',
            'description': 'Product and technology leadership',
            'colorCode': '#00897B',
            'isShow': true,
            'typeAxisLookupId': 2,
          },
        ],
        'manzors': [
          {
            'id': 1,
            'title': 'Q1 priorities',
            'objectActives': [
              {
                'id': 1,
                'title': 'Launch unified mobile experience',
                'description': 'End-to-end customer journey on mobile',
                'strategicAxisId': 1,
                'manzorId': 1,
                'releatedIds': [2, 3],
                'kpIs': [
                  {
                    'id': 1,
                    'title': 'NPS uplift',
                    'description': 'Target +12 pts',
                    'status': 'متقدم',
                    'percentage': '74',
                  },
                ],
                'initiatives': [
                  {
                    'id': 1,
                    'title': 'Beta program',
                    'description': 'Closed beta with key accounts',
                    'status': 'متقدم',
                    'percentage': '48',
                  },
                ],
              },
            ],
          },
        ],
        'values': [
          {'id': 1, 'name': 'Integrity', 'vesionId': 1},
          {'id': 2, 'name': 'Collaboration', 'vesionId': 1},
        ],
      },
    };

BscModel buildPrototypeBscModel() => BscModel.fromJson(prototypeBscBody());

OkrModel buildPrototypeOkrModel() => OkrModel.fromJson({
      'succeeded': true,
      'warningErrors': null,
      'validationErrors': null,
      'data': {
        'id': 1,
        'title': 'OKR — Prototype cycle',
        'description': 'Quarterly objectives and key results',
        'isActive': true,
        'objectActives': [
          {
            'id': 10,
            'title': 'Expand enterprise pipeline',
            'description': 'Grow qualified opportunities',
            'key_results': [
              {
                'id': 1,
                'title': 'ARR from new logos',
                'description': '\$2M target',
                'status': 'متقدم',
                'percentage': '71',
              },
              {
                'id': 2,
                'title': 'Win rate',
                'description': 'Maintain 35%+',
                'status': 'متأخر',
                'percentage': '39',
              },
            ],
          },
        ],
      },
    });

ObjectivesModel buildPrototypeObjectivesModel() {
  final items = <Map<String, dynamic>>[
    prototypeObjectiveItem(
      1,
      'Increase customer satisfaction',
      1,
      status: 'متقدم',
      strategicAxisType: 'تشغيلي',
      weight: 72.0,
    ),
    prototypeObjectiveItem(
      2,
      'Reduce time-to-market for releases',
      2,
      status: 'متأخر',
      strategicAxisType: 'خططى',
      weight: 41.0,
    ),
    prototypeObjectiveItem(
      3,
      'Build data-driven culture',
      1,
      status: 'مكتمل',
      strategicAxisType: 'تشغيلي',
      weight: 100.0,
    ),
  ];
  return ObjectivesModel.fromJson({
    'data': {'items': items},
    'status_code': 200,
    'message': 'OK',
    'meta': {
      'current_page': 1,
      'count': items.length,
      'total': items.length,
      'pages_count': 1,
      'last_page': 1,
      'limit': 20,
    },
  });
}

Map<String, dynamic> prototypeObjectiveItem(
  int id,
  String title,
  int axisId, {
  String status = 'متقدم',
  String strategicAxisType = 'تشغيلي',
  double weight = 65,
}) =>
    {
      'id': id,
      'title': title,
      'description':
          'Marketing prototype objective — aligned to strategic priorities.',
      'weightScaleLookUpId': 1,
      'weight': weight,
      'subObjectActives': <String>['Sub-goal A', 'Sub-goal B'],
      'startDate': '2025-01-01T00:00:00.000',
      'endDate': '2026-12-31T23:59:59.000',
      'strategicAxisId': axisId,
      'manzorId': 1,
      'visionId': 1,
      'isVisionActive': true,
      'createdBy': 'Strategy Office',
      'relatedCountAll': 3,
      'status': status,
      'strategicAxisType': strategicAxisType,
    };

CustomFieldsModel buildPrototypeStrategicAxisFilters() => CustomFieldsModel.fromJson({
      'message': 'OK',
      'status_code': 200,
      'data': [
        {'id': 1, 'name': 'All axes', 'desc': null, 'code': 'all'},
        {'id': 2, 'name': 'Growth', 'desc': null, 'code': 'growth'},
        {'id': 3, 'name': 'Innovation', 'desc': null, 'code': 'innovation'},
      ],
    });
