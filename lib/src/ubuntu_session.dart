import 'dart:io';

import 'package:meta/meta.dart';

import 'gnome_session_manager.dart';
import 'mate_session_manager.dart';
import 'simple_session_manager.dart';
import 'systemd_session_manager.dart';

enum UbuntuDesktop {
  gnome,
  kde,
  lxde,
  mate,
  unknown,
}

class UbuntuSessionException implements Exception {
  const UbuntuSessionException([this.message]);
  final dynamic message;

  @override
  String toString() => '$runtimeType: $message';
}

class UbuntuSessionUnknownDesktopException extends UbuntuSessionException {
  UbuntuSessionUnknownDesktopException([super.message]);
}

/// Provides a simplified interface to the DBus API of the current desktop
/// environment.
///
/// If [fallback] is true systemd-logind will be used as fallback.
class UbuntuSession {
  UbuntuSession({
    bool fallback = true,
    @visibleForTesting Map<String, String>? env,
  })  : _env = env ?? Platform.environment,
        _manager = _getManager(fallback, env ?? Platform.environment);

  final Map<String, String> _env;
  final SimpleSessionManager _manager;

  static SimpleSessionManager _getManager(
      bool fallback, Map<String, String> env) {
    switch (_getDesktop(env)) {
      case UbuntuDesktop.gnome:
        return GnomeSimpleSessionManager();
      case UbuntuDesktop.mate:
        return MateSimpleSessionManager();
      default:
        if (fallback) return SystemdSimpleSessionManager();
    }
    throw UbuntuSessionUnknownDesktopException();
  }

  static UbuntuDesktop _getDesktop(Map<String, String> env) {
    final xdgCurrentDesktop = env['XDG_CURRENT_DESKTOP']?.toLowerCase() ?? '';
    if (xdgCurrentDesktop.contains('gnome')) {
      return UbuntuDesktop.gnome;
    } else if (xdgCurrentDesktop.contains('kde')) {
      return UbuntuDesktop.kde;
    } else if (xdgCurrentDesktop.contains('lxde')) {
      return UbuntuDesktop.lxde;
    } else if (xdgCurrentDesktop.contains('mate')) {
      return UbuntuDesktop.mate;
    } else {
      return UbuntuDesktop.unknown;
    }
  }

  /// The current desktop environment.
  UbuntuDesktop get desktop => _getDesktop(_env);

  /// Log out of the active session.
  Future<void> logout() => _manager.logout();

  /// Reboot the system.
  Future<void> reboot() => _manager.reboot();

  /// Shutdown the system.
  Future<void> shutdown() => _manager.shutdown();
}
