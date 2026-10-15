import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_management/features/projects/model/projects_filters_model.dart';
import 'package:project_management/shared/filters/project_filters_selection.dart';

class _Filters with ProjectFiltersSelection {
  @override
  final pickedStartCtrl = TextEditingController();
  @override
  final pickedEndCtrl = TextEditingController();
}

void main() {
  final options = ProjectsFiltersData.fromJson({
    'categories': [
      {'id': 1, 'name': 'Strategic'},
    ],
    'priorities': [
      {'id': 2, 'name': 'High'},
    ],
    'risks': [
      {'id': 3, 'name': 'Low'},
    ],
    'statuses': [
      {'item1': 'متأخر', 'item2': 'Delayed', 'item3': 'Delayed'},
    ],
  });

  test('fills every option list from the filter options', () {
    final filters = _Filters()..setFilterOptions(options);

    expect(filters.hasFilterOptions, isTrue);
    expect(filters.categoriesList.single.name, 'Strategic');
    expect(filters.priorityList.single.id, 2);
    expect(filters.riskList.single.name, 'Low');
    expect(filters.statusList.single.key, 'Delayed');
  });

  test('builds the query from the selection and clears it', () {
    final filters = _Filters()..setFilterOptions(options);
    expect(filters.hasNoFilterSelected, isTrue);

    filters
      ..selectedStatus = filters.statusList.single
      ..selectedCategory = filters.categoriesList.single
      ..pickedStartCtrl.text = '2026-01-01';

    expect(filters.hasNoFilterSelected, isFalse);
    expect(filters.filterQuery, {
      'status': 'Delayed',
      'projectCategoryId': 1,
      'riskLevelId': '',
      'periortyLevelId': '',
      'startDate': '2026-01-01',
      'endDate': '',
    });

    filters.clearSelection();
    expect(filters.hasNoFilterSelected, isTrue);
  });
}
