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
