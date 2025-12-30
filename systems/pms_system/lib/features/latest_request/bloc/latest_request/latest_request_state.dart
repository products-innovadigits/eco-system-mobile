import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/latest_request/model/latest_request_models.dart';

/// Base state for LatestRequestBloc
abstract class LatestRequestState {
  const LatestRequestState();
}

/// Initial state
class LatestRequestInitial extends LatestRequestState {
  const LatestRequestInitial();
}

/// Loading latest request data
class LatestRequestLoading extends LatestRequestState {
  const LatestRequestLoading();
}

/// Successfully loaded latest requests
class LatestRequestLoaded extends LatestRequestState {
  final List<LatestRequestItem> requests;
  final bool isLoadingMore;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const LatestRequestLoaded({
    required this.requests,
    this.isLoadingMore = false,
    this.currentPage = 0,
    this.totalPages = 1,
    this.hasMore = true,
  });

  LatestRequestLoaded copyWith({
    List<LatestRequestItem>? requests,
    bool? isLoadingMore,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return LatestRequestLoaded(
      requests: requests ?? this.requests,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// No requests found (empty result)
class LatestRequestEmpty extends LatestRequestState {
  final bool isInitial;

  const LatestRequestEmpty({this.isInitial = false});
}

/// Error loading latest requests
class LatestRequestFailure extends LatestRequestState {
  final String message;

  const LatestRequestFailure({required this.message});
}

