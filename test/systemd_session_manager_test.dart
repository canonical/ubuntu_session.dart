import 'dart:io';

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
      await manager.connect();
      await manager.halt(true);
      verify(object.callMethod(managerName, 'Halt', [const DBusBoolean(true)],
              replySignature: DBusSignature('')))
          .called(1);
      await manager.close();
    });

    test('Hibernate', () async {
      final object = createMockRemoteObject();
      final manager = SystemdSessionManager(object: object);
      await manager.connect();
      await manager.hibernate(true);
      verify(object.callMethod(
              managerName, 'Hibernate', [const DBusBoolean(true)],
              replySignature: DBusSignature('')))
          .called(1);
      await manager.close();
    });

    test('ListSessions', () async {
      final sessionId = '13';
      final userId = 1000;
      final userName = 'testname';
      final seatId = 'seat0';
      final sessionObjectpath = '/org/freedesktop/login1/session/_1337';
      final object = createMockRemoteObject(sessions: [
        DBusStruct([
          DBusString(sessionId),
          DBusUint32(userId),
          DBusString(userName),
          DBusString(seatId),
          DBusObjectPath(sessionObjectpath),
        ])
      ]);
      final manager = SystemdSessionManager(object: object);
      await manager.connect();
      final sessions = await manager.listSessions();
      verify(object.callMethod(managerName, 'ListSessions', [],
          replySignature: DBusSignature.array(
            DBusSignature.struct([
              DBusSignature('s'),
              DBusSignature('u'),
              DBusSignature('s'),
              DBusSignature('s'),
              DBusSignature('o'),
            ]),
          ))).called(1);
      expect(sessions.length, 1);
      expect(sessions.first.toString(), 'SystemdClient($sessionObjectpath');
    });

    test('PowerOff', () async {
      final object = createMockRemoteObject();
      final manager = SystemdSessionManager(object: object);
      await manager.connect();
      await manager.powerOff(true);
      verify(object.callMethod(
              managerName, 'PowerOff', [const DBusBoolean(true)],
              replySignature: DBusSignature('')))
          .called(1);
      await manager.close();
    });

    test('Reboot', () async {
      final object = createMockRemoteObject();
      final manager = SystemdSessionManager(object: object);
      await manager.connect();
      await manager.reboot(true);
      verify(object.callMethod(managerName, 'Reboot', [const DBusBoolean(true)],
              replySignature: DBusSignature('')))
          .called(1);
      await manager.close();
    });

    test('Suspend', () async {
      final object = createMockRemoteObject();
      final manager = SystemdSessionManager(object: object);
      await manager.connect();
      await manager.suspend(true);
      verify(object.callMethod(
              managerName, 'Suspend', [const DBusBoolean(true)],
              replySignature: DBusSignature('')))
          .called(1);
      await manager.close();
    });

    test('CanHalt', () async {
      final object = createMockRemoteObject(canHalt: 'no');
      final manager = SystemdSessionManager(object: object);
      await manager.connect();
      final canReboot = await manager.canHalt();
      verify(object.callMethod(managerName, 'CanHalt', [],
              replySignature: DBusSignature('s')))
          .called(1);
      expect(canReboot, 'no');
      await manager.close();
    });

    test('CanHibernate', () async {
      final object = createMockRemoteObject(canHibernate: 'no');
      final manager = SystemdSessionManager(object: object);
      await manager.connect();
      final canReboot = await manager.canHibernate();
      verify(object.callMethod(managerName, 'CanHibernate', [],
              replySignature: DBusSignature('s')))
          .called(1);
      expect(canReboot, 'no');
      await manager.close();
    });

    test('CanPowerOff', () async {
      final object = createMockRemoteObject(canPowerOff: 'no');
      final manager = SystemdSessionManager(object: object);
      await manager.connect();
      final canReboot = await manager.canPowerOff();
      verify(object.callMethod(managerName, 'CanPowerOff', [],
              replySignature: DBusSignature('s')))
          .called(1);
      expect(canReboot, 'no');
      await manager.close();
    });

    test('CanReboot', () async {
      final object = createMockRemoteObject(canReboot: 'no');
      final manager = SystemdSessionManager(object: object);
      await manager.connect();
      final canReboot = await manager.canReboot();
      verify(object.callMethod(managerName, 'CanReboot', [],
              replySignature: DBusSignature('s')))
          .called(1);
      expect(canReboot, 'no');
      await manager.close();
    });

    test('CanSuspend', () async {
      final object = createMockRemoteObject(canSuspend: 'no');
      final manager = SystemdSessionManager(object: object);
      await manager.connect();
      final canReboot = await manager.canSuspend();
      verify(object.callMethod(managerName, 'CanSuspend', [],
              replySignature: DBusSignature('s')))
          .called(1);
      expect(canReboot, 'no');
      await manager.close();
    });

    test('Inhibit', () async {
      final object = createMockRemoteObject();
      final manager = SystemdSessionManager(object: object);
      await manager.connect();
      final fd = await manager.inhibit(
        what: {
          SystemdInhibitionFlag.handlePowerKey,
          SystemdInhibitionFlag.idle
        },
        who: 'who',
        why: 'why',
        mode: SystemdInhibitionMode.block,
      );
      expect(fd, isA<ResourceHandle>());
      verify(object.callMethod(
              managerName,
              'Inhibit',
              [
                const DBusString('handle-power-key:idle'),
                const DBusString('who'),
                const DBusString('why'),
                const DBusString('block'),
              ],
              replySignature: DBusSignature('h')))
          .called(1);
      await manager.close();
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
  List<DBusValue>? sessions,
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

  final sessionSignature = DBusSignature.struct([
    DBusSignature('s'),
    DBusSignature('u'),
    DBusSignature('s'),
    DBusSignature('s'),
    DBusSignature('o')
  ]);
  when(object.callMethod(managerName, 'ListSessions', [],
          replySignature: DBusSignature.array(sessionSignature)))
      .thenAnswer((_) async => DBusMethodSuccessResponse(
          [DBusArray(sessionSignature, sessions ?? [])]));
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
  when(object.callMethod(managerName, 'Inhibit', any,
          replySignature: DBusSignature('h')))
      .thenAnswer((_) async => DBusMethodSuccessResponse(
          [DBusUnixFd(ResourceHandle.fromStdin(stdin))]));
  return object;
}
