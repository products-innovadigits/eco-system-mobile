import 'package:core_system/core/core/app_event.dart';

// Sorting-specific events
class LoadSortingOptions extends AppEvent {
  LoadSortingOptions({Object? arguments}) : super(arguments);
}

class SelectSortingOption extends AppEvent {
  SelectSortingOption({Object? arguments}) : super(arguments);
}

class ApplySortingOption extends AppEvent {
  ApplySortingOption({Object? arguments}) : super(arguments);
}

class ResetSortingOption extends AppEvent {
  ResetSortingOption({Object? arguments}) : super(arguments);
}

class ClearSortingSelection extends AppEvent {
  ClearSortingSelection({Object? arguments}) : super(arguments);
}
