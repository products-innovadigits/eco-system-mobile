import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/cycles/domain/cycles_repo.dart';
import 'package:pms_system/features/cycles/model/cycles_model.dart';

class CyclesRepoImpl implements CyclesRepo {
  final Network network;

  CyclesRepoImpl({required this.network});

  @override
  Future<CyclesModel> getCycles(SearchEngine data) async {
    // TODO: Replace with real API call when endpoint is available
    // return await network.requestOrThrow(
    //   ApiNames.cycles,
    //   query: data.query,
    //   method: ServerMethods.POST,
    //   model: CyclesModel(),
    // ) as CyclesModel;

    await Future.delayed(const Duration(milliseconds: 800));
    return _simulatedCyclesData(data);
  }

  CyclesModel _simulatedCyclesData(SearchEngine data) {
    final allCycles = <CycleItemModel>[
      CycleItemModel(
        id: 1,
        title: 'Bi-Annual Review',
        status: 'Active',
        dueDate: 'Feb 15, 2025',
        assignees: [
          CycleAssigneeModel(id: 1, name: 'Ahmed Ali'),
          CycleAssigneeModel(id: 2, name: 'Sara Hassan'),
          CycleAssigneeModel(id: 3, name: 'Mohamed Khaled'),
          CycleAssigneeModel(id: 4, name: 'Fatima Omar'),
        ],
        reviews: [
          CycleReviewModel(name: 'Manager Review', percentage: 50),
          CycleReviewModel(name: 'Direct Report Review', percentage: 30),
          CycleReviewModel(name: 'Peer Review', percentage: 60),
        ],
      ),
      CycleItemModel(
        id: 2,
        title: 'Annual Performance Cycle',
        status: 'Active',
        dueDate: 'Mar 30, 2025',
        assignees: [
          CycleAssigneeModel(id: 5, name: 'Khalid Saeed'),
          CycleAssigneeModel(id: 6, name: 'Nora Abdullah'),
          CycleAssigneeModel(id: 7, name: 'Youssef Ibrahim'),
        ],
        reviews: [
          CycleReviewModel(name: 'Manager Review', percentage: 75),
          CycleReviewModel(name: 'Direct Report Review', percentage: 45),
          CycleReviewModel(name: 'Peer Review', percentage: 80),
        ],
      ),
      CycleItemModel(
        id: 3,
        title: 'Q1 Review Cycle',
        status: 'Completed',
        dueDate: 'Jan 15, 2025',
        assignees: [
          CycleAssigneeModel(id: 8, name: 'Layla Mansour'),
          CycleAssigneeModel(id: 9, name: 'Omar Faisal'),
        ],
        reviews: [
          CycleReviewModel(name: 'Manager Review', percentage: 100),
          CycleReviewModel(name: 'Direct Report Review', percentage: 100),
          CycleReviewModel(name: 'Peer Review', percentage: 100),
        ],
      ),
      CycleItemModel(
        id: 4,
        title: 'Probation Review',
        status: 'Overdue',
        dueDate: 'Dec 20, 2024',
        assignees: [
          CycleAssigneeModel(id: 10, name: 'Hassan Ali'),
          CycleAssigneeModel(id: 11, name: 'Amina Saleh'),
          CycleAssigneeModel(id: 12, name: 'Tariq Nasser'),
          CycleAssigneeModel(id: 13, name: 'Reem Adel'),
          CycleAssigneeModel(id: 14, name: 'Sami Younis'),
        ],
        reviews: [
          CycleReviewModel(name: 'Manager Review', percentage: 20),
          CycleReviewModel(name: 'Direct Report Review', percentage: 10),
          CycleReviewModel(name: 'Peer Review', percentage: 15),
        ],
      ),
      CycleItemModel(
        id: 5,
        title: 'Mid-Year Assessment',
        status: 'Active',
        dueDate: 'Jun 30, 2025',
        assignees: [
          CycleAssigneeModel(id: 15, name: 'Dana Walid'),
          CycleAssigneeModel(id: 16, name: 'Faris Jamal'),
          CycleAssigneeModel(id: 17, name: 'Huda Majid'),
        ],
        reviews: [
          CycleReviewModel(name: 'Manager Review', percentage: 40),
          CycleReviewModel(name: 'Direct Report Review', percentage: 55),
          CycleReviewModel(name: 'Peer Review', percentage: 35),
        ],
      ),
      CycleItemModel(
        id: 6,
        title: 'Leadership 360 Review',
        status: 'Active',
        dueDate: 'Apr 15, 2025',
        assignees: [
          CycleAssigneeModel(id: 18, name: 'Rania Hossam'),
          CycleAssigneeModel(id: 19, name: 'Ziad Kamal'),
        ],
        reviews: [
          CycleReviewModel(name: 'Manager Review', percentage: 65),
          CycleReviewModel(name: 'Direct Report Review', percentage: 70),
          CycleReviewModel(name: 'Peer Review', percentage: 50),
        ],
      ),
    ];

    final keyword =
        (data.query as Map<String, dynamic>?)?['searchKeyword'] as String?;
    final filtered = keyword != null && keyword.isNotEmpty
        ? allCycles
              .where(
                (c) => c.title!.toLowerCase().contains(keyword.toLowerCase()),
              )
              .toList()
        : allCycles;

    final pageIndex =
        ((data.query as Map<String, dynamic>?)?['pageIndex'] as int?) ?? 1;
    final pageSize = data.limit;
    final start = (pageIndex - 1) * pageSize;
    final end = start + pageSize > filtered.length
        ? filtered.length
        : start + pageSize;
    final pageItems = start < filtered.length
        ? filtered.sublist(start, end)
        : <CycleItemModel>[];
    final totalPages = (filtered.length / pageSize).ceil();

    return CyclesModel(
      succeeded: true,
      data: CyclesDataModel(
        items: pageItems,
        currentPage: pageIndex,
        pageSize: pageSize,
        totalPages: totalPages > 0 ? totalPages : 1,
        totalCount: filtered.length,
        isLastPage: pageIndex >= totalPages,
      ),
    );
  }
}
