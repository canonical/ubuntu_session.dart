# ubuntu_session.dart
Native Dart client library to access the GNOME Session Manager (+ more to come)

[![CI](https://github.com/canonical/ubuntu_session.dart/workflows/Tests/badge.svg)](https://github.com/canonical/ubuntu_session.dart/actions/workflows/tests.yaml)
[![codecov](https://codecov.io/gh/canonical/ubuntu_session.dart/branch/main/graph/badge.svg)](https://codecov.io/gh/canonical/ubuntu_session.dart)

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

## Implemented so far:
### `org.gnome.SessionManager`
#### Methods
- `Shutdown()`
- `Reboot()`
- `CanShutdown()`
- `IsSessionRunning()`
#### Properties
- `SessionName`
- `SessionIsActive`

Please refer to the [GNOME Session Documentation](https://lira.no-ip.org:8443/doc/gnome-session/dbus/gnome-session.html) for further details.

## Contributing to ubuntu_session.dart

We welcome contributions! See the [contribution guide](CONTRIBUTING.md) for more details.