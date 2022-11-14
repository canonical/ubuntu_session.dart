# ubuntu_session.dart
Native Dart client library to access Ubuntu desktop session managers

[![CI](https://github.com/canonical/ubuntu_session.dart/workflows/Tests/badge.svg)](https://github.com/canonical/ubuntu_session.dart/actions/workflows/tests.yaml)
[![codecov](https://codecov.io/gh/canonical/ubuntu_session.dart/branch/main/graph/badge.svg)](https://codecov.io/gh/canonical/ubuntu_session.dart)


## Simplified API
The simplified API provides a small set of methods common among different Ubuntu desktop managers.
It will try to detect the current desktop environment and invoke the methods provided by the respective session manager.

Currently provided methods:
- `logout()`
- `reboot()`
- `shutdown()`

If the desktop environment is unknwon (or the API is not implemented yet..) it will use `systemd-logind` as a fallback. **Warning** - the fallback API will not show a confirmation dialog for `logout()`, `reboot()` or `shutdown()`.
You can use `fallback: false` to disable the fallback.
```dart
import 'package:ubuntu_session/ubuntu_session.dart';

void main() {
  final session = UbuntuSession();
  print('Detected desktop environment: ${session.desktop}');
  session.reboot();
}

```

## GNOME Session Manager
```dart
import 'package:dbus/dbus.dart';
import 'package:ubuntu_session/ubuntu_session.dart';

void main() async {
  final manager = GnomeSessionManager();
  await manager.connect();
  try {
    await manager.reboot();
  } on DBusMethodResponseException catch (e) {
    print('Error: $e');
  }
  await manager.close();
}
```

### Implemented so far:
### `org.gnome.SessionManager`
#### Methods
- `Shutdown()`
- `Reboot()`
- `CanShutdown()`
- `IsSessionRunning()`
- `Logout()`
#### Properties
- `SessionName`
- `SessionIsActive`

Please refer to the [GNOME Session documentation](https://lira.no-ip.org:8443/doc/gnome-session/dbus/gnome-session.html) for further details.

## MATE Session Manager
```dart
import 'package:dbus/dbus.dart';
import 'package:ubuntu_session/ubuntu_session.dart';

void main() async {
  final manager = MateSessionManager();
  await manager.connect();
  try {
    await manager.shutdown();
  } on DBusMethodResponseException catch (e) {
    print('Error: $e');
  }
  await manager.close();
}
```

### Implemented so far:
### `org.gnome.SessionManager`
#### Methods
- `Shutdown()`
- `CanShutdown()`
- `IsSessionRunning()`
- `Logout()`
#### Properties
- `Renderer`

Please refer to the [GNOME Session documentation](https://lira.no-ip.org:8443/doc/gnome-session/dbus/gnome-session.html) for further details.
Note that the MATE session manager only implements a [subset](https://github.com/mate-desktop/mate-session-manager/blob/master/mate-session/org.gnome.SessionManager.xml) of the `org.gnome.SessionManager` interface

## systemd-logind

```dart
import 'package:ubuntu_session/ubuntu_session.dart';

void main() async {
  final manager = SystemdSessionManager();
  await manager.connect();
  await manager.reboot(true);
  await manager.close();
}
```

### Implemented so far:
### `org.freedesktop.login1.Manager`
#### Methods
- `Halt()`
- `Hibernate()`
- `PowerOff()`
- `Reboot()`
- `Suspend()`
- `CanHalt()`
- `CanHibernate()`
- `CanPowerOff()`
- `CanReboot()`
- `CanSuspend()`
- `ListSessions()`
#### Properties
- `OnExternalPower`

### org.freedesktop.login1.Session
#### Methods
- `Lock()`
- `Terminate()`
#### Properties
- `Id`
- `Active`

Please refer to the [systemd-logind documentation](https://www.freedesktop.org/software/systemd/man/org.freedesktop.login1.html) for further details.

## Contributing to ubuntu_session.dart

We welcome contributions! See the [contribution guide](CONTRIBUTING.md) for more details.