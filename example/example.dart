import 'package:dbus/dbus.dart';
import 'package:session_manager/src/session_manager.dart';

void main() async {
  final manager = SessionManager();
  await manager.connect();
  try {
    await manager.reboot();
  } on DBusMethodResponseException catch (e) {
    print('Error: $e');
  }
  await manager.close();
}
