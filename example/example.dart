import 'package:ubuntu_session/ubuntu_session.dart';

void main() {
  final session = UbuntuSession();
  print(session.desktop);
  session.reboot();
}
