import 'package:dbus/dbus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:ubuntu_session/ubuntu_session.dart';

import 'systemd_session_manager_test.mocks.dart';

@GenerateMocks([DBusClient, DBusRemoteObject])
void main() {
  final busName = SystemdSessionManager.busName;

  test('connect and disconnect', () async {
    final object = createMockRemoteObject();
    final bus = object.client as MockDBusClient;

    final manager = SystemdSessionManager(object: object);
    await manager.connect();
    verify(object.getAllProperties(busName)).called(1);

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

  test('halt', () async {
    final object = createMockRemoteObject();
    final manager = SystemdSessionManager(object: object);
    await manager.halt(true);
    verify(object.callMethod(busName, 'Halt', [const DBusBoolean(true)],
            replySignature: DBusSignature('')))
        .called(1);
  });

  test('hibernate', () async {
    final object = createMockRemoteObject();
    final manager = SystemdSessionManager(object: object);
    await manager.hibernate(true);
    verify(object.callMethod(busName, 'Hibernate', [const DBusBoolean(true)],
            replySignature: DBusSignature('')))
        .called(1);
  });

  test('power off', () async {
    final object = createMockRemoteObject();
    final manager = SystemdSessionManager(object: object);
    await manager.powerOff(true);
    verify(object.callMethod(busName, 'PowerOff', [const DBusBoolean(true)],
            replySignature: DBusSignature('')))
        .called(1);
  });

  test('reboot', () async {
    final object = createMockRemoteObject();
    final manager = SystemdSessionManager(object: object);
    await manager.reboot(true);
    verify(object.callMethod(busName, 'Reboot', [const DBusBoolean(true)],
            replySignature: DBusSignature('')))
        .called(1);
  });

  test('suspend', () async {
    final object = createMockRemoteObject();
    final manager = SystemdSessionManager(object: object);
    await manager.suspend(true);
    verify(object.callMethod(busName, 'Suspend', [const DBusBoolean(true)],
            replySignature: DBusSignature('')))
        .called(1);
  });

  test('can halt', () async {
    final object = createMockRemoteObject(canHalt: 'no');
    final manager = SystemdSessionManager(object: object);
    final canReboot = await manager.canHalt();
    verify(object.callMethod(busName, 'CanHalt', [],
            replySignature: DBusSignature('s')))
        .called(1);
    expect(canReboot, 'no');
  });

  test('can hibernate', () async {
    final object = createMockRemoteObject(canHibernate: 'no');
    final manager = SystemdSessionManager(object: object);
    final canReboot = await manager.canHibernate();
    verify(object.callMethod(busName, 'CanHibernate', [],
            replySignature: DBusSignature('s')))
        .called(1);
    expect(canReboot, 'no');
  });

  test('can power off', () async {
    final object = createMockRemoteObject(canPowerOff: 'no');
    final manager = SystemdSessionManager(object: object);
    final canReboot = await manager.canPowerOff();
    verify(object.callMethod(busName, 'CanPowerOff', [],
            replySignature: DBusSignature('s')))
        .called(1);
    expect(canReboot, 'no');
  });

  test('can reboot', () async {
    final object = createMockRemoteObject(canReboot: 'no');
    final manager = SystemdSessionManager(object: object);
    final canReboot = await manager.canReboot();
    verify(object.callMethod(busName, 'CanReboot', [],
            replySignature: DBusSignature('s')))
        .called(1);
    expect(canReboot, 'no');
  });

  test('can suspend', () async {
    final object = createMockRemoteObject(canSuspend: 'no');
    final manager = SystemdSessionManager(object: object);
    final canReboot = await manager.canSuspend();
    verify(object.callMethod(busName, 'CanSuspend', [],
            replySignature: DBusSignature('s')))
        .called(1);
    expect(canReboot, 'no');
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
  final busName = SystemdSessionManager.busName;
  when(object.client).thenReturn(dbus);
  when(object.propertiesChanged)
      .thenAnswer((_) => propertiesChanged ?? const Stream.empty());
  when(object.getAllProperties(busName))
      .thenAnswer((_) async => properties ?? {});
  when(object.callMethod(busName, 'Halt', any,
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(busName, 'Hibernate', any,
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(busName, 'PowerOff', any,
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(busName, 'Reboot', any,
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(busName, 'Suspend', any,
          replySignature: DBusSignature('')))
      .thenAnswer((_) async => DBusMethodSuccessResponse());
  when(object.callMethod(busName, 'CanHalt', [],
          replySignature: DBusSignature('s')))
      .thenAnswer(
          (_) async => DBusMethodSuccessResponse([DBusString(canHalt)]));
  when(object.callMethod(busName, 'CanHibernate', [],
          replySignature: DBusSignature('s')))
      .thenAnswer(
          (_) async => DBusMethodSuccessResponse([DBusString(canHibernate)]));
  when(object.callMethod(busName, 'CanReboot', [],
          replySignature: DBusSignature('s')))
      .thenAnswer(
          (_) async => DBusMethodSuccessResponse([DBusString(canReboot)]));
  when(object.callMethod(busName, 'CanPowerOff', [],
          replySignature: DBusSignature('s')))
      .thenAnswer(
          (_) async => DBusMethodSuccessResponse([DBusString(canPowerOff)]));
  when(object.callMethod(busName, 'CanSuspend', [],
          replySignature: DBusSignature('s')))
      .thenAnswer(
          (_) async => DBusMethodSuccessResponse([DBusString(canSuspend)]));
  return object;
}
