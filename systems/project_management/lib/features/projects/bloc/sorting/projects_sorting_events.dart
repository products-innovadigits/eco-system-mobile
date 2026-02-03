abstract class ProjectsSortingEvent {
  final Object? arguments;

  const ProjectsSortingEvent({this.arguments});
}

// Sorting-specific events
class LoadSortingOptions extends ProjectsSortingEvent {
  LoadSortingOptions({super.arguments});
}

class SelectSortingOption extends ProjectsSortingEvent {
  SelectSortingOption({super.arguments});
}

class ApplySortingOption extends ProjectsSortingEvent {
  ApplySortingOption({super.arguments});
}

class ResetSortingOption extends ProjectsSortingEvent {
  ResetSortingOption({super.arguments});
}

class ClearSortingSelection extends ProjectsSortingEvent {
  ClearSortingSelection({super.arguments});
}
