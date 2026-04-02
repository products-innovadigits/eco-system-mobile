import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';
import 'package:pms_system/features/cycles/model/cycles_model.dart';

/// Shared prototype payloads for PMS (marketing demo — no API).

Map<String, dynamic> prototypeCyclesBody() => {
      'succeeded': true,
      'status': 200,
      'data': {
        'items': [
          {
            'id': 1,
            'title': 'FY2026 H1 Review',
            'status': 'active',
            'dueDate': '2026-06-30',
            'manager_progress': 85,
            'direct_report_progress': 62,
            'peer_progress': 48,
            'assignees': [
              {'id': 1, 'name': 'Sara Ali', 'jobTitle': 'HR Partner'},
            ],
          },
          {
            'id': 2,
            'title': 'Mid-year check-in',
            'status': 'not started',
            'dueDate': '2026-04-15',
            'manager_progress': 0,
            'direct_report_progress': 0,
            'peer_progress': 0,
          },
        ],
        'currentPage': 1,
        'pageSize': 20,
        'totalPages': 1,
        'nextPage': null,
        'previousPage': null,
        'isLastPage': true,
        'totalCount': 2,
      },
    };

CyclesModel buildPrototypeCyclesModel() => CyclesModel.fromJson(prototypeCyclesBody());

Map<String, dynamic> prototypeCycleDetailBody(int cycleId) => {
      'succeeded': true,
      'data': {
        'id': cycleId,
        'title': 'FY2026 H1 Review',
        'subtitle': 'Organization-wide performance cycle',
        'status': 'Active',
        'overallProgress': 72.0,
        'completedCount': 18,
        'totalCount': 25,
        'totalScore': 4.2,
        'revieweesCount': 25,
        'reviewees': [
          {
            'id': 101,
            'name': 'Omar Khalil',
            'jobTitle': 'Engineering Manager',
            'completedReviews': 2,
            'totalReviews': 3,
            'overallPercentage': 78.0,
            'reviews': [
              {
                'type': 'Manager',
                'percentage': 90.0,
                'completedCount': 1,
                'totalCount': 1,
                'reviewers': [
                  {'id': 1, 'name': 'Director', 'status': 'Completed'},
                ],
              },
            ],
          },
        ],
        'roleGroups': [
          {'role': 'Managers', 'count': 12, 'dueDate': '2026-05-01', 'isCompleted': false},
        ],
      },
    };

CycleDetailModel buildPrototypeCycleDetail(int cycleId) =>
    CycleDetailModel.fromJson(prototypeCycleDetailBody(cycleId));

CycleSummaryResponseModel buildPrototypeCycleSummary(int cycleId) =>
    CycleSummaryResponseModel.fromJson({
      'status': 200,
      'message': 'OK',
      'data': {
        'id': cycleId,
        'name': 'FY2026 H1 Review',
        'state': 'active',
        'overall_progress': 72,
        'completed_count': 18,
        'total_count': 25,
        'reviewers_count': 40,
        'managers': {'count': 12, 'deadline': 10, 'deadline_date': '2026-05-01'},
        'direct_reports': {'count': 8, 'deadline': 8, 'deadline_date': '2026-05-08'},
        'peers': {'count': 20, 'deadline': 15, 'deadline_date': '2026-05-15'},
      },
    });

RevieweeStatusResponseModel buildPrototypeRevieweeStatus() =>
    RevieweeStatusResponseModel.fromJson({
      'data': [
        {
          'id': 201,
          'name': 'Nour Hassan',
          'job_title': 'Product Designer',
          'avatar': null,
          'overall_progress': 65,
          'completed_count': 2,
          'total_count': 3,
          'types': [
            {
              'name': 'Peer',
              'progress': 50,
              'completed_count': 1,
              'total_count': 2,
              'reviewers': [
                {'id': 3, 'name': 'Alex', 'status': 'completed', 'overdue': false},
              ],
            },
          ],
        },
        {
          'id': 202,
          'name': 'Faisal Nasser',
          'job_title': 'Backend Developer',
          'overall_progress': 40,
          'completed_count': 1,
          'total_count': 3,
          'types': [],
        },
      ],
      'current_page': 1,
      'last_page': 1,
      'total': 2,
      'per_page': 20,
    });
