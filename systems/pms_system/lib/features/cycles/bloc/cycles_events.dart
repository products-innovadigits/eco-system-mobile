import 'package:pms_system/core/utility/pms_exports.dart';

abstract class CyclesEvent {
  const CyclesEvent();
}

class LoadCycles extends CyclesEvent {
  final SearchEngine searchEngine;

  const LoadCycles({required this.searchEngine});
}

class RefreshCycles extends CyclesEvent {
  const RefreshCycles();
}

class SearchChanged extends CyclesEvent {
  final String text;

  const SearchChanged(this.text);
}

class LoadMoreCycles extends CyclesEvent {
  const LoadMoreCycles();
}

class FilterCycles extends CyclesEvent {
  final String? status;

  const FilterCycles({this.status});
}
