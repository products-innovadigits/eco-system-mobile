import 'package:core_system/core/core/app_strings/locale_keys.dart';
import 'package:core_system/core/core/enums.dart';
import 'package:core_system/core/helpers/shared_helper.dart';
import 'package:core_system/core/helpers/translation/all_translation.dart';
import 'package:core_system/core/modules/system_module.dart';

/// Single owner of "which system are we in?".
///
/// Two questions live here, and they are deliberately not the same field:
///
///  * [signedInTo] — the system whose credentials this session holds. It picks
///    the API the network layer talks to, so it must never be null and it has
///    to survive a restart.
///  * [viewing] — the system whose screens the user is browsing right now.
///    `null` means the combined "all systems" home. In-memory only; logging in
///    or restarting resets it to the signed-in system.
///
/// Everything else (base URLs, home sections, the switcher UI) reads from here
/// instead of keeping its own copy.
abstract class ActiveSystem {
  static List<SystemModule> _modules = const [];
  static ActiveSystemEnum? _signedInTo;
  static ActiveSystemEnum? _viewing;

  /// Registered once at startup by the app shell, which is the only layer that
  /// knows the concrete modules. Order decides the login dropdown order.
  static void registerModules(List<SystemModule> modules) {
    _modules = List.unmodifiable(modules);
  }

  static List<SystemModule> get modules => _modules;

  /// The systems this build was compiled with.
  static List<ActiveSystemEnum> get available =>
      _modules.map((m) => m.system).toList();

  /// The system this session is authenticated against.
  /// Falls back to the first enabled module before anyone has signed in.
  static ActiveSystemEnum get signedInTo =>
      _signedInTo ??
      (_modules.isNotEmpty
          ? _modules.first.system
          : ActiveSystemEnum.projectManagement);

  /// The system being browsed, or `null` for the combined home.
  static ActiveSystemEnum? get viewing => _viewing;

  static SystemModule? moduleFor(ActiveSystemEnum system) {
    for (final module in _modules) {
      if (module.system == system) return module;
    }
    return null;
  }

  static SystemModule? moduleById(String id) {
    for (final module in _modules) {
      if (module.id == id) return module;
    }
    return null;
  }

  /// Display name for a system, or the "all systems" label for `null`.
  static String nameOf(ActiveSystemEnum? system) {
    if (system == null) return allTranslations.text(LocaleKeys.all_systems);
    return moduleFor(system)?.name ?? system.value;
  }

  /// Whether [system]'s home content belongs on screen right now — true while
  /// browsing that system, and true on the combined home where every enabled
  /// system gets a turn.
  static bool showsContentFor(ActiveSystemEnum system) =>
      _viewing == null || _viewing == system;

  /// Records the system the user just logged into and makes it the one being
  /// browsed. Persisted so [restore] can pick it up after a cold start.
  static Future<void> signIn(ActiveSystemEnum system) async {
    _signedInTo = system;
    _viewing = system;
    await SharedHelper.sharedHelper!.writeData(
      CachingKey.chosenSystem,
      system.value,
    );
  }

  /// Reinstates the system chosen at login after a restart.
  static Future<void> restore() async {
    final helper = SharedHelper.sharedHelper!;
    var stored = await helper.readString(CachingKey.chosenSystem);

    /// Builds before the system state was unified persisted the module id
    /// (`pms_system`) under its own key, so installs upgrading in place still
    /// come back to the right system instead of silently falling back.
    if (stored.isEmpty) {
      stored = await helper.readString(CachingKey.legacyChosenSystemModuleId);
    }

    final system =
        ActiveSystemEnum.tryFromString(stored) ?? moduleById(stored)?.system;

    _signedInTo = system ?? (_modules.isNotEmpty ? _modules.first.system : null);
    _viewing = _signedInTo;
  }

  /// Switches which system's screens are being browsed. `null` shows the
  /// combined home. Does not touch [signedInTo] — the session's credentials
  /// are unchanged by looking at another system.
  static void view(ActiveSystemEnum? system) => _viewing = system;

  /// Drops all system state. Called on logout, alongside clearing storage.
  static void reset() {
    _signedInTo = null;
    _viewing = null;
  }
}
