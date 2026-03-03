import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycle_review/domain/cycle_review_repo.dart';
import 'package:pms_system/features/cycle_review/model/cycle_review_model.dart';

class CycleReviewRepoImpl implements CycleReviewRepo {
  final Network network;

  CycleReviewRepoImpl({required this.network});

  @override
  Future<CycleDetailModel> getCycleDetail(int cycleId) async {
    // TODO: Replace with real API call when endpoint is available
    // return await network.requestOrThrow(
    //   ApiNames.cycleDetail(cycleId),
    //   method: ServerMethods.GET,
    //   model: CycleDetailModel(),
    // ) as CycleDetailModel;

    await Future.delayed(const Duration(milliseconds: 800));
    return _simulatedData(cycleId);
  }

  CycleDetailModel _simulatedData(int cycleId) {
    final dataMap = <int, CycleDetailDataModel>{
      1: CycleDetailDataModel(
        id: 1,
        title: 'Bi-Annual Review',
        subtitle: 'H1 Performance Cycle 2024',
        status: 'Active',
        overallProgress: 60,
        completedCount: 6,
        totalCount: 10,
        totalScore: 87,
        revieweesCount: 13,
        reviewees: [
          CycleRevieweeModel(
            id: 1,
            name: 'Mohamed Khaled',
            jobTitle: 'Senior Product Designer',
            completedReviews: 2,
            totalReviews: 4,
            overallPercentage: 44,
            reviews: [
              CycleReviewTypeModel(
                type: 'Manager Review',
                percentage: 18,
                completedCount: 1,
                totalCount: 2,
                reviewers: [
                  CycleReviewerInfoModel(
                    id: 10,
                    name: 'Hassan Aziz',
                    status: 'Completed',
                  ),
                ],
              ),
              CycleReviewTypeModel(
                type: 'Direct Report',
                percentage: 67,
                completedCount: 0,
                totalCount: 2,
                reviewers: [
                  CycleReviewerInfoModel(
                    id: 11,
                    name: 'Amira Ahmed',
                    status: 'Not Started',
                  ),
                  CycleReviewerInfoModel(
                    id: 12,
                    name: 'Donia Ali',
                    status: 'Overdue',
                  ),
                ],
              ),
              CycleReviewTypeModel(
                type: 'Peer Review',
                percentage: 78,
                completedCount: 1,
                totalCount: 1,
                reviewers: [
                  CycleReviewerInfoModel(
                    id: 10,
                    name: 'Hassan Aziz',
                    status: 'Completed',
                  ),
                ],
              ),
            ],
          ),
          CycleRevieweeModel(
            id: 2,
            name: 'Rawan Adel',
            jobTitle: 'UX Researcher',
            completedReviews: 2,
            totalReviews: 4,
            overallPercentage: 44,
            reviews: [
              CycleReviewTypeModel(
                type: 'Manager Review',
                percentage: 55,
                completedCount: 1,
                totalCount: 1,
                reviewers: [
                  CycleReviewerInfoModel(
                    id: 13,
                    name: 'Faris Jamal',
                    status: 'Completed',
                  ),
                ],
              ),
              CycleReviewTypeModel(
                type: 'Direct Report',
                percentage: 30,
                completedCount: 1,
                totalCount: 2,
                reviewers: [
                  CycleReviewerInfoModel(
                    id: 14,
                    name: 'Nora Abdullah',
                    status: 'Completed',
                  ),
                  CycleReviewerInfoModel(
                    id: 15,
                    name: 'Layla Mansour',
                    status: 'Not Started',
                  ),
                ],
              ),
              CycleReviewTypeModel(
                type: 'Peer Review',
                percentage: 40,
                completedCount: 0,
                totalCount: 1,
                reviewers: [
                  CycleReviewerInfoModel(
                    id: 16,
                    name: 'Tariq Nasser',
                    status: 'Not Started',
                  ),
                ],
              ),
            ],
          ),
        ],
        roleGroups: [
          CycleRoleGroupModel(
            role: 'Managers',
            count: 3,
            dueDate: 'FEB 5, 2025',
            isCompleted: false,
          ),
          CycleRoleGroupModel(
            role: 'Direct Reports',
            count: 2,
            dueDate: 'FEB 10, 2025',
            isCompleted: false,
          ),
          CycleRoleGroupModel(
            role: 'Peers',
            count: 5,
            dueDate: 'FEB 15, 2025',
            isCompleted: false,
          ),
        ],
      ),
      2: CycleDetailDataModel(
        id: 2,
        title: 'Annual Performance Cycle',
        subtitle: 'Full Year Review 2024',
        status: 'Active',
        overallProgress: 45,
        completedCount: 9,
        totalCount: 20,
        totalScore: 72,
        revieweesCount: 8,
        reviewees: [
          CycleRevieweeModel(
            id: 3,
            name: 'Khalid Saeed',
            jobTitle: 'Software Engineer',
            completedReviews: 1,
            totalReviews: 3,
            overallPercentage: 33,
            reviews: [
              CycleReviewTypeModel(
                type: 'Manager Review',
                percentage: 80,
                completedCount: 1,
                totalCount: 1,
                reviewers: [
                  CycleReviewerInfoModel(
                    id: 17,
                    name: 'Ahmed Ali',
                    status: 'Completed',
                  ),
                ],
              ),
              CycleReviewTypeModel(
                type: 'Peer Review',
                percentage: 0,
                completedCount: 0,
                totalCount: 2,
                reviewers: [
                  CycleReviewerInfoModel(
                    id: 18,
                    name: 'Sara Hassan',
                    status: 'Not Started',
                  ),
                  CycleReviewerInfoModel(
                    id: 19,
                    name: 'Omar Faisal',
                    status: 'Not Started',
                  ),
                ],
              ),
            ],
          ),
        ],
        roleGroups: [
          CycleRoleGroupModel(
            role: 'Managers',
            count: 4,
            dueDate: 'MAR 15, 2025',
            isCompleted: false,
          ),
          CycleRoleGroupModel(
            role: 'Peers',
            count: 8,
            dueDate: 'MAR 20, 2025',
            isCompleted: false,
          ),
        ],
      ),
    };

    final data = dataMap[cycleId] ?? dataMap[1]!;

    return CycleDetailModel(succeeded: true, data: data);
  }
}
