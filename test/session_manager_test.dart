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

  test('reboot', () async {
    final object = createMockRemoteObject();
    final manager = SessionManager(object: object);
    await manager.reboot();
    verify(object.callMethod(kBus, 'Reboot', [],
            replySignature: DBusSignature('')))
        .called(1);
  });

  test('shutdown', () async {
    final object = createMockRemoteObject();
    final manager = SessionManager(object: object);
    await manager.shutdown();
    verify(object.callMethod(kBus, 'Shutdown', [],
            replySignature: DBusSignature('')))
        .called(1);
  });

  test('can shutdown', () async {
    final object = createMockRemoteObject(canShutdown: true);
    final manager = SessionManager(object: object);
    final canShutdown = await manager.canShutdown();
    verify(object.callMethod(kBus, 'CanShutdown', [],
            replySignature: DBusSignature('b')))
        .called(1);
    expect(canShutdown, true);
  });

  test('is session running', () async {
    final object = createMockRemoteObject(isSessionRunning: true);
    final manager = SessionManager(object: object);
    final isSessionRunning = await manager.isSessionRunning();
    verify(object.callMethod(kBus, 'IsSessionRunning', [],
            replySignature: DBusSignature('b')))
        .called(1);
    expect(isSessionRunning, true);
  });
}

MockDBusRemoteObject createMockRemoteObject({
  Stream<DBusPropertiesChangedSignal>? propertiesChanged,
  Map<String, DBusValue>? properties,
  bool canShutdown = false,
  bool isSessionRunning = false,
}) {
  final dbus = MockDBusClient();
  final object = MockDBusRemoteObject();
  when(object.client).thenReturn(dbus);
  when(object.propertiesChanged)
      .thenAnswer((_) => propertiesChanged ?? const Stream.empty());
  when(object.getAllProperties(kBus)).thenAnswer((_) async => properties ?? {});
  when(object.callMethod(kBus, 'Reboot', [], replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(kBus, 'Shutdown', [],
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(kBus, 'CanShutdown', [],
          replySignature: DBusSignature('b')))
      .thenAnswer(
          (_) async => DBusMethodSuccessResponse([DBusBoolean(canShutdown)]));
  when(object.callMethod(kBus, 'IsSessionRunning', [],
          replySignature: DBusSignature('b')))
      .thenAnswer((_) async =>
          DBusMethodSuccessResponse([DBusBoolean(isSessionRunning)]));
  return object;
}
