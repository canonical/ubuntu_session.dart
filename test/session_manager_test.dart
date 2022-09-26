import 'package:dbus/dbus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:session_manager/src/constants.dart';
import 'package:session_manager/src/session_manager.dart';
import 'package:test/test.dart';

import 'session_manager_test.mocks.dart';

@GenerateMocks([DBusClient, DBusRemoteObject])
void main() {
  test('connect and disconnect', () async {
    final object = createMockRemoteObject();
    final bus = object.client as MockDBusClient;

    final manager = SessionManager(object: object);
    await manager.connect();
    verify(object.getAllProperties(kBus)).called(1);

    await manager.close();
    verify(bus.close()).called(1);
  });

  test('read properties', () async {
    final object = createMockRemoteObject(properties: {
      'SessionIsActive': const DBusBoolean(true),
      'SessionName': const DBusString('ubuntu'),
    });

    final manager = SessionManager(object: object);
    await manager.connect();
    final sessionName = manager.sessionName;
    final sessionIsActive = manager.sessionIsActive;
    expect(sessionName, 'ubuntu');
    expect(sessionIsActive, true);
    await manager.close();
  });
}

MockDBusRemoteObject createMockRemoteObject({
  Stream<DBusPropertiesChangedSignal>? propertiesChanged,
  Map<String, DBusValue>? properties,
}) {
  final dbus = MockDBusClient();
  final object = MockDBusRemoteObject();
  when(object.client).thenReturn(dbus);
  when(object.propertiesChanged)
      .thenAnswer((_) => propertiesChanged ?? const Stream.empty());
  when(object.getAllProperties(kBus)).thenAnswer((_) async => properties ?? {});
  return object;
}
