import 'dart:io';

import 'package:meta/meta.dart';

import 'gnome_session_manager.dart';
import 'simple_session_manager.dart';
import 'systemd_session_manager.dart';

enum UbuntuDesktop {
  gnome,
  kde,
  lxde,
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
    } else {
      return UbuntuDesktop.unknown;
    }
  }

  UbuntuDesktop get desktop => _getDesktop(_env);
  Future<void> logout() => _manager.logout();
  Future<void> reboot() => _manager.reboot();
  Future<void> shutdown() => _manager.shutdown();
}
