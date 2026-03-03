import 'package:pms_system/features/cycles/model/cycles_model.dart';

abstract class CyclesState {
  const CyclesState();
}

class CyclesInitial extends CyclesState {
  const CyclesInitial();
}

class CyclesLoading extends CyclesState {
  const CyclesLoading();
}

class CyclesLoaded extends CyclesState {
  final List<CycleItemModel> cycles;
  final bool isLoadingMore;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const CyclesLoaded({
    required this.cycles,
    this.isLoadingMore = false,
    this.currentPage = 0,
    this.totalPages = 1,
    this.hasMore = false,
  });

  CyclesLoaded copyWith({
    List<CycleItemModel>? cycles,
    bool? isLoadingMore,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return CyclesLoaded(
      cycles: cycles ?? this.cycles,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class CyclesEmpty extends CyclesState {
  final bool isInitial;

  const CyclesEmpty({this.isInitial = false});
}

class CyclesFailure extends CyclesState {
  final String message;

  const CyclesFailure({required this.message});
}
