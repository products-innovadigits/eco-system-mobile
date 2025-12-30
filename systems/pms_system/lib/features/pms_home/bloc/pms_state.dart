import 'package:pms_system/core/utility/pms_exports.dart';

/// Base state for PmsCubit
abstract class PmsState {
  const PmsState();
}

/// Initial state
class PmsInitial extends PmsState {
  const PmsInitial();
}
