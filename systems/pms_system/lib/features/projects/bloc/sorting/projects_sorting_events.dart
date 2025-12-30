abstract class ProjectSortingEvent {
  final Object? arguments;

  const ProjectSortingEvent({this.arguments});
}

// Sorting-specific events
class LoadSortingOptions extends ProjectSortingEvent {
  LoadSortingOptions({super.arguments});
}

class SelectSortingOption extends ProjectSortingEvent {
  SelectSortingOption({super.arguments});
}

class ApplySortingOption extends ProjectSortingEvent {
  ApplySortingOption({super.arguments});
}

class ResetSortingOption extends ProjectSortingEvent {
  ResetSortingOption({super.arguments});
}

class ClearSortingSelection extends ProjectSortingEvent {
  ClearSortingSelection({super.arguments});
}
