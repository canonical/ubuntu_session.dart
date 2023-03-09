import 'package:dbus/dbus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:ubuntu_session/ubuntu_session.dart';

import 'mate_session_manager_test.mocks.dart';

@GenerateMocks([DBusClient, DBusRemoteObject, MateSessionManager])
void main() {
  group('DBus API', () {
    final managerName = MateSessionManager.managerName;

    test('connect and disconnect', () async {
      final object = createMockRemoteObject();
      final bus = object.client as MockDBusClient;

      final manager = MateSessionManager(object: object);
      await manager.connect();
      verify(object.getAllProperties(managerName)).called(1);

      await manager.close();
      verify(bus.close()).called(1);
    });

    test('read properties', () async {
      final object = createMockRemoteObject(properties: {
        'Renderer': const DBusString('test renderer'),
      });

      final manager = MateSessionManager(object: object);
      await manager.connect();
      final renderer = manager.renderer;
      expect(renderer, 'test renderer');
      await manager.close();
    });

    test('Logout', () async {
      final object = createMockRemoteObject();
      final manager = MateSessionManager(object: object);
      await manager.logout(mode: MateLogoutMode.force);
      verify(object.callMethod(
        managerName,
        'Logout',
        [DBusUint32(MateLogoutMode.force.index)],
        replySignature: DBusSignature(''),
      )).called(1);
    });

    test('shutdown', () async {
      final object = createMockRemoteObject();
      final manager = MateSessionManager(object: object);
      await manager.shutdown();
      verify(object.callMethod(managerName, 'Shutdown', [],
              replySignature: DBusSignature('')))
          .called(1);
    });

    test('CanShutdown', () async {
      final object = createMockRemoteObject(canShutdown: true);
      final manager = MateSessionManager(object: object);
      final canShutdown = await manager.canShutdown();
      verify(object.callMethod(managerName, 'CanShutdown', [],
              replySignature: DBusSignature('b')))
          .called(1);
      expect(canShutdown, true);
    });

    test('IsSessionRunning', () async {
      final object = createMockRemoteObject(isSessionRunning: true);
      final manager = MateSessionManager(object: object);
      final isSessionRunning = await manager.isSessionRunning();
      verify(object.callMethod(managerName, 'IsSessionRunning', [],
              replySignature: DBusSignature('b')))
          .called(1);
      expect(isSessionRunning, true);
    });
  });

  group('simple API', () {
    test('logout', () async {
      final dbusManager = MockMateSessionManager();
      final simpleManager = MateSimpleSessionManager(manager: dbusManager);
      await simpleManager.logout();
      verifyInOrder([
        dbusManager.connect(),
        dbusManager.logout(),
        dbusManager.close(),
      ]);
    });
    test('reboot', () async {
      final dbusManager = MockMateSessionManager();
      final simpleManager = MateSimpleSessionManager(manager: dbusManager);
      await simpleManager.reboot();
      verifyInOrder([
        dbusManager.connect(),
        dbusManager.shutdown(),
        dbusManager.close(),
      ]);
    });
    test('shutdown', () async {
      final dbusManager = MockMateSessionManager();
      final simpleManager = MateSimpleSessionManager(manager: dbusManager);
      await simpleManager.shutdown();
      verifyInOrder([
        dbusManager.connect(),
        dbusManager.shutdown(),
        dbusManager.close(),
      ]);
    });
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
  final managerName = MateSessionManager.managerName;
  when(object.client).thenReturn(dbus);
  when(object.propertiesChanged)
      .thenAnswer((_) => propertiesChanged ?? const Stream.empty());
  when(object.getAllProperties(managerName))
      .thenAnswer((_) async => properties ?? {});
  when(object.callMethod(managerName, 'Logout', any,
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(managerName, 'Shutdown', [],
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(managerName, 'CanShutdown', [],
          replySignature: DBusSignature('b')))
      .thenAnswer(
          (_) async => DBusMethodSuccessResponse([DBusBoolean(canShutdown)]));
  when(object.callMethod(managerName, 'IsSessionRunning', [],
          replySignature: DBusSignature('b')))
      .thenAnswer((_) async =>
          DBusMethodSuccessResponse([DBusBoolean(isSessionRunning)]));
  return object;
}
