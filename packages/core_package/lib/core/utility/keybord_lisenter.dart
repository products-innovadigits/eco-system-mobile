import 'package:core_package/core/utility/export.dart';

class KeyBordBloc extends Bloc<AppEvent, AppState> {
  KeyBordBloc() : super(Start());

  final BehaviorSubject<bool> isKeyboardOpen =
      BehaviorSubject<bool>.seeded(false);

  Function(bool) get changeKeyBoardState => isKeyboardOpen.add;

  Stream<bool> get currentKayboardState => isKeyboardOpen.stream;

  @override
  Future<void> close() {
    isKeyboardOpen.close();
    return super.close();
  }
}

KeyBordBloc get keyboard =>
    BlocProvider.of(CustomNavigator.navigatorState.currentContext!);
