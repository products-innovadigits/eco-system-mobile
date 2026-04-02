import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_learning_details/domain/employee_learning_details_repo.dart';
import 'package:pms_system/features/employee_learning_details/model/employee_learning_details_model.dart';

/// Prototype: simulated learning / review cycles — no API.
class EmployeeLearningDetailsRepoImpl implements EmployeeLearningDetailsRepo {
  final Network network;

  EmployeeLearningDetailsRepoImpl({required this.network});

  @override
  Future<ReviewCyclesModel> getReviewCycles({required int userId}) async {
    await Future.delayed(const Duration(milliseconds: 220));
    return ReviewCyclesModel.fromJson({
      'data': [
        {
          'id': 10,
          'name': 'H1 2026 competency review',
          'start_date': '2026-01-01',
          'closed_date': '2026-06-30',
          'is_learning_assignment_sent': true,
          'report': {
            'final_score': 4.3,
            'weakest_area': {'avg': 3.1, 'name': 'Stakeholder management'},
            'strongest_area': {'avg': 4.8, 'name': 'Execution'},
            'weakest_factor': {'avg': 3.4, 'name': 'Communication'},
            'strongest_factor': {'avg': 4.6, 'name': 'Ownership'},
          },
        },
        {
          'id': 11,
          'name': 'H2 2025 review',
          'start_date': '2025-07-01',
          'closed_date': '2025-12-20',
          'is_learning_assignment_sent': false,
        },
      ],
    });
  }

  @override
  Future<LastReviewCycleReportModel> getLastReviewCycleReport({
    required int userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return LastReviewCycleReportModel.fromJson({
      'id': 99,
      'created_at': '2026-02-01',
      'name': 'Latest summary',
      'report_data': {
        'final_score': 4.4,
        'weakest_area': {'avg': 3.5, 'name': 'Strategic thinking'},
        'strongest_area': {'avg': 4.7, 'name': 'Delivery'},
        'weakest_factor': {'avg': 3.6, 'name': 'Planning'},
        'strongest_factor': {'avg': 4.5, 'name': 'Collaboration'},
      },
    });
  }
}
