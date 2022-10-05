import 'package:test/test.dart';
import 'package:ubuntu_session/ubuntu_session.dart';

void main() {
  group('desktop environments', () {
    test('GNOME', () async {
      final session = UbuntuSession(env: {
        'XDG_CURRENT_DESKTOP': 'ubuntu:GNOME',
      });
      expect(session.desktop, UbuntuDesktop.gnome);
    });
  });
}
