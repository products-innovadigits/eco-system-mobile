import 'package:core_system/core/model/search_engine.dart';
import 'package:core_system/core/network/network_layer.dart';
import 'package:project_management/features/latest_request/domain/repositories/latest_request_repo.dart';
import 'package:project_management/features/latest_request/model/latest_request_models.dart';

/// Prototype: simulated workflow requests — no API.
class LatestRequestRepoImpl implements LatestRequestRepo {
  final Network network;

  LatestRequestRepoImpl({required this.network});

  @override
  Future<LatestRequestModel> getLatestRequest(SearchEngine data) async {
    await Future.delayed(const Duration(milliseconds: 220));
    return LatestRequestModel.fromJson({
      'succeeded': true,
      'data': [
        {
          'id': 1,
          'processId': 501,
          'projectId': 1001,
          'isRuningWorkflow': true,
          'isCompletedWorkflow': false,
          'createdAt': '2026-03-01',
          'process': {
            'id': 501,
            'title': 'Budget approval',
            'description': 'Prototype workflow step',
          },
          'project': {
            'id': 1001,
            'name': 'Customer experience platform',
            'description': 'End-to-end CX modernization',
          },
        },
        {
          'id': 2,
          'processId': 502,
          'projectId': 1002,
          'isRuningWorkflow': false,
          'isCompletedWorkflow': false,
          'createdAt': '2026-02-20',
          'process': {'id': 502, 'title': 'Steering committee sign-off'},
          'project': {
            'id': 1002,
            'name': 'Data hub initiative',
          },
        },
      ],
    });
  }
}
