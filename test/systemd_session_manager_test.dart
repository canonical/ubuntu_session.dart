import 'package:dbus/dbus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:ubuntu_session/ubuntu_session.dart';

import 'systemd_session_manager_test.mocks.dart';

@GenerateMocks([
  DBusClient,
  DBusRemoteObject,
  SystemdSessionManager,
  SystemdSession,
])
void main() {
  group('DBus API', () {
    final managerName = SystemdSessionManager.managerName;

    test('connect and disconnect', () async {
      final object = createMockRemoteObject();
      final bus = object.client as MockDBusClient;

      final manager = SystemdSessionManager(object: object);
      await manager.connect();
      verify(object.getAllProperties(managerName)).called(1);

      await manager.close();
      verify(bus.close()).called(1);
    });

    test('read properties', () async {
      final object = createMockRemoteObject(properties: {
        'OnExternalPower': const DBusBoolean(true),
      });

      final manager = SystemdSessionManager(object: object);
      await manager.connect();
      final onExternalPower = manager.onExternalPower;
      expect(onExternalPower, true);
      await manager.close();
    });

    test('Halt', () async {
      final object = createMockRemoteObject();
      final manager = SystemdSessionManager(object: object);
      await manager.halt(true);
      verify(object.callMethod(managerName, 'Halt', [const DBusBoolean(true)],
              replySignature: DBusSignature('')))
          .called(1);
    });

    test('Hibernate', () async {
      final object = createMockRemoteObject();
      final manager = SystemdSessionManager(object: object);
      await manager.hibernate(true);
      verify(object.callMethod(
              managerName, 'Hibernate', [const DBusBoolean(true)],
              replySignature: DBusSignature('')))
          .called(1);
    });

    test('PowerOff', () async {
      final object = createMockRemoteObject();
      final manager = SystemdSessionManager(object: object);
      await manager.powerOff(true);
      verify(object.callMethod(
              managerName, 'PowerOff', [const DBusBoolean(true)],
              replySignature: DBusSignature('')))
          .called(1);
    });

    test('Reboot', () async {
      final object = createMockRemoteObject();
      final manager = SystemdSessionManager(object: object);
      await manager.reboot(true);
      verify(object.callMethod(managerName, 'Reboot', [const DBusBoolean(true)],
              replySignature: DBusSignature('')))
          .called(1);
    });

    test('Suspend', () async {
      final object = createMockRemoteObject();
      final manager = SystemdSessionManager(object: object);
      await manager.suspend(true);
      verify(object.callMethod(
              managerName, 'Suspend', [const DBusBoolean(true)],
              replySignature: DBusSignature('')))
          .called(1);
    });

    test('CanHalt', () async {
      final object = createMockRemoteObject(canHalt: 'no');
      final manager = SystemdSessionManager(object: object);
      final canReboot = await manager.canHalt();
      verify(object.callMethod(managerName, 'CanHalt', [],
              replySignature: DBusSignature('s')))
          .called(1);
      expect(canReboot, 'no');
    });

    test('CanHibernate', () async {
      final object = createMockRemoteObject(canHibernate: 'no');
      final manager = SystemdSessionManager(object: object);
      final canReboot = await manager.canHibernate();
      verify(object.callMethod(managerName, 'CanHibernate', [],
              replySignature: DBusSignature('s')))
          .called(1);
      expect(canReboot, 'no');
    });

    test('CanPowerOff', () async {
      final object = createMockRemoteObject(canPowerOff: 'no');
      final manager = SystemdSessionManager(object: object);
      final canReboot = await manager.canPowerOff();
      verify(object.callMethod(managerName, 'CanPowerOff', [],
              replySignature: DBusSignature('s')))
          .called(1);
      expect(canReboot, 'no');
    });

    test('CanReboot', () async {
      final object = createMockRemoteObject(canReboot: 'no');
      final manager = SystemdSessionManager(object: object);
      final canReboot = await manager.canReboot();
      verify(object.callMethod(managerName, 'CanReboot', [],
              replySignature: DBusSignature('s')))
          .called(1);
      expect(canReboot, 'no');
    });

    test('CanSuspend', () async {
      final object = createMockRemoteObject(canSuspend: 'no');
      final manager = SystemdSessionManager(object: object);
      final canReboot = await manager.canSuspend();
      verify(object.callMethod(managerName, 'CanSuspend', [],
              replySignature: DBusSignature('s')))
          .called(1);
      expect(canReboot, 'no');
    });
  });
  group('simple API', () {
    test('logout', () async {
      final dbusManager = MockSystemdSessionManager();
      final session = MockSystemdSession();
      when(session.active).thenAnswer((_) => Future.value(true));
      when(dbusManager.listSessions())
          .thenAnswer((_) => Future.value([session]));
      final simpleManager = SystemdSimpleSessionManager(manager: dbusManager);
      await simpleManager.logout();
      verifyInOrder([
        dbusManager.connect(),
        dbusManager.listSessions(),
        session.terminate(),
        dbusManager.close(),
      ]);
    });
    test('reboot', () async {
      final dbusManager = MockSystemdSessionManager();
      final simpleManager = SystemdSimpleSessionManager(manager: dbusManager);
      await simpleManager.reboot();
      verifyInOrder([
        dbusManager.connect(),
        dbusManager.reboot(true),
        dbusManager.close(),
      ]);
    });
    test('shutdown', () async {
      final dbusManager = MockSystemdSessionManager();
      final simpleManager = SystemdSimpleSessionManager(manager: dbusManager);
      await simpleManager.shutdown();
      verifyInOrder([
        dbusManager.connect(),
        dbusManager.powerOff(true),
        dbusManager.close(),
      ]);
    });
  });
}

MockDBusRemoteObject createMockRemoteObject({
  Stream<DBusPropertiesChangedSignal>? propertiesChanged,
  Map<String, DBusValue>? properties,
  String canHalt = 'yes',
  String canHibernate = 'yes',
  String canPowerOff = 'yes',
  String canReboot = 'yes',
  String canSuspend = 'yes',
}) {
  final dbus = MockDBusClient();
  final object = MockDBusRemoteObject();
  final managerName = SystemdSessionManager.managerName;
  when(object.client).thenReturn(dbus);
  when(object.propertiesChanged)
      .thenAnswer((_) => propertiesChanged ?? const Stream.empty());
  when(object.getAllProperties(managerName))
      .thenAnswer((_) async => properties ?? {});
  when(object.callMethod(managerName, 'Halt', any,
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(managerName, 'Hibernate', any,
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(managerName, 'PowerOff', any,
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(managerName, 'Reboot', any,
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(managerName, 'Suspend', any,
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(managerName, 'CanHalt', [],
          replySignature: DBusSignature('s')))
      .thenAnswer(
          (_) async => DBusMethodSuccessResponse([DBusString(canHalt)]));
  when(object.callMethod(managerName, 'CanHibernate', [],
          replySignature: DBusSignature('s')))
      .thenAnswer(
          (_) async => DBusMethodSuccessResponse([DBusString(canHibernate)]));
  when(object.callMethod(managerName, 'CanReboot', [],
          replySignature: DBusSignature('s')))
      .thenAnswer(
          (_) async => DBusMethodSuccessResponse([DBusString(canReboot)]));
  when(object.callMethod(managerName, 'CanPowerOff', [],
          replySignature: DBusSignature('s')))
      .thenAnswer(
          (_) async => DBusMethodSuccessResponse([DBusString(canPowerOff)]));
  when(object.callMethod(managerName, 'CanSuspend', [],
          replySignature: DBusSignature('s')))
      .thenAnswer(
          (_) async => DBusMethodSuccessResponse([DBusString(canSuspend)]));
  return object;
}
