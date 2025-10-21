import 'package:core_system/core/core/app_state.dart';
import 'package:pms_system/shared/pms_exports.dart';

// Sorting-specific states
class SortingInitial extends AppState {
  @override
  Map<String, dynamic> toJson() => {"state": "SortingInitial"};
}

class SortingLoading extends AppState {
  @override
  Map<String, dynamic> toJson() => {"state": "SortingLoading"};
}

class SortingOptionsLoaded extends AppState {
  @override
  Map<String, dynamic> toJson() => {"state": "SortingOptionsLoaded"};
}

class SortingOptionSelected extends AppState {
  @override
  Map<String, dynamic> toJson() => {"state": "SortingOptionSelected"};
}

class SortingApplied extends AppState {
  @override
  Map<String, dynamic> toJson() => {"state": "SortingApplied"};
}

class SortingReset extends AppState {
  @override
  Map<String, dynamic> toJson() => {"state": "SortingReset"};
}

class SortingError extends AppState {
  @override
  Map<String, dynamic> toJson() => {"state": "SortingError"};
}
