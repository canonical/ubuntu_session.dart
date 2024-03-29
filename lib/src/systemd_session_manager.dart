import 'dart:async';
import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:meta/meta.dart';

import 'simple_session_manager.dart';
import 'util.dart';

enum SystemdInhibitionFlag {
  /// Inhibit system power-off and reboot
  shutdown,

  /// Inhibit suspend and hibernation
  sleep,

  /// Inhibit that the system goes into idle mode
  idle,

  /// Inhibit low-level handling of the hardware power key
  handlePowerKey,

  /// Inhibit low-level handling of the hardware suspend key
  handleSuspendKey,

  /// Inhibit low-level handling of the hardware hibernate key
  handleHibernateKey,

  /// Inhibit low-level handling of the hardware lid switch
  handleLidSwitch;

  @override
  String toString() {
    switch (this) {
      case SystemdInhibitionFlag.shutdown:
        return 'shutdown';
      case SystemdInhibitionFlag.sleep:
        return 'sleep';
      case SystemdInhibitionFlag.idle:
        return 'idle';
      case SystemdInhibitionFlag.handlePowerKey:
        return 'handle-power-key';
      case SystemdInhibitionFlag.handleSuspendKey:
        return 'handle-suspend-key';
      case SystemdInhibitionFlag.handleHibernateKey:
        return 'handle-hibernate-key';
      case SystemdInhibitionFlag.handleLidSwitch:
        return 'handle-lid-switch';
    }
  }
}

enum SystemdInhibitionMode {
  block,
  delay;

  @override
  String toString() {
    switch (this) {
      case SystemdInhibitionMode.block:
        return 'block';
      case SystemdInhibitionMode.delay:
        return 'delay';
    }
  }
}

/// The client that connects to the SystemD Session Manager
class SystemdSessionManager {
  SystemdSessionManager({
    DBusClient? bus,
    @visibleForTesting DBusRemoteObject? object,
  })  : _bus = bus,
        _object = object ?? _createRemoteObject(bus);

  static DBusRemoteObject _createRemoteObject(DBusClient? bus) {
    return DBusRemoteObject(
      bus ?? DBusClient.system(),
      name: busName,
      path: DBusObjectPath(objectPath),
    );
  }

  static final String busName = 'org.freedesktop.login1';
  static final String managerName = 'org.freedesktop.login1.Manager';
  static final String objectPath = '/org/freedesktop/login1';

  final DBusClient? _bus;
  final DBusRemoteObject _object;
  final _properties = <String, DBusValue>{};
  final _propertyController = StreamController<List<String>>.broadcast();
  StreamSubscription? _propertySubscription;

  bool get onExternalPower => _getProperty('OnExternalPower', false);

  /// Halt the system.
  Future<void> halt(bool interactive) {
    return _object.callMethod(managerName, 'Halt', [DBusBoolean(interactive)],
        replySignature: DBusSignature(''));
  }

  /// Hibernate the system.
  Future<void> hibernate(bool interactive) {
    return _object.callMethod(
        managerName, 'Hibernate', [DBusBoolean(interactive)],
        replySignature: DBusSignature(''));
  }

  Future<Iterable<SystemdSession>> listSessions() async {
    final response = await _object
        .callMethod(managerName, 'ListSessions', [],
            replySignature: DBusSignature.array(
              DBusSignature.struct([
                DBusSignature('s'),
                DBusSignature('u'),
                DBusSignature('s'),
                DBusSignature('s'),
                DBusSignature('o'),
              ]),
            ))
        .then((response) => response.values.first.asArray());
    final sessions = response.map(
      (e) => SystemdSession(
        DBusRemoteObject(
          _object.client,
          name: busName,
          path: e.asStruct()[4].asObjectPath(),
        ),
      ),
    );
    return sessions;
  }

  /// Power off the system.
  Future<void> powerOff(bool interactive) {
    return _object.callMethod(
        managerName, 'PowerOff', [DBusBoolean(interactive)],
        replySignature: DBusSignature(''));
  }

  /// Reboot the system.
  Future<void> reboot(bool interactive) {
    return _object.callMethod(managerName, 'Reboot', [DBusBoolean(interactive)],
        replySignature: DBusSignature(''));
  }

  /// Suspend the system.
  Future<void> suspend(bool interactive) {
    return _object.callMethod(
        managerName, 'Suspend', [DBusBoolean(interactive)],
        replySignature: DBusSignature(''));
  }

  Future<String> canHalt() {
    return _object
        .callMethod(managerName, 'CanHalt', [],
            replySignature: DBusSignature('s'))
        .then((response) => response.values.first.asString());
  }

  Future<String> canHibernate() {
    return _object
        .callMethod(managerName, 'CanHibernate', [],
            replySignature: DBusSignature('s'))
        .then((response) => response.values.first.asString());
  }

  Future<String> canPowerOff() {
    return _object
        .callMethod(managerName, 'CanPowerOff', [],
            replySignature: DBusSignature('s'))
        .then((response) => response.values.first.asString());
  }

  Future<String> canSuspend() {
    return _object
        .callMethod(managerName, 'CanSuspend', [],
            replySignature: DBusSignature('s'))
        .then((response) => response.values.first.asString());
  }

  Future<String> canReboot() {
    return _object
        .callMethod(managerName, 'CanReboot', [],
            replySignature: DBusSignature('s'))
        .then((response) => response.values.first.asString());
  }

  /// Create an inhibition lock.
  Future<ResourceHandle> inhibit({
    required Set<SystemdInhibitionFlag> what,
    required String who,
    required String why,
    required SystemdInhibitionMode mode,
  }) async {
    return _object
        .callMethod(
            managerName,
            'Inhibit',
            [
              DBusString(what.join(':')),
              DBusString(who),
              DBusString(why),
              DBusString(mode.name),
            ],
            replySignature: DBusSignature('h'))
        .then((response) => response.values.first.asUnixFd());
  }

  /// Connects to the Session Manager service.
  Future<void> connect() async {
    // Already connected
    if (_propertySubscription != null) {
      return;
    }
    _propertySubscription ??= _object.propertiesChanged.listen((signal) {
      if (signal.propertiesInterface == managerName) {
        _updateProperties(signal.changedProperties);
      }
    });
    return _object.getAllProperties(managerName).then(_updateProperties);
  }

  /// Closes connection to the Session Manager service.
  Future<void> close() async {
    await _propertySubscription?.cancel();
    _propertySubscription = null;
    if (_bus == null) {
      await _object.client.close();
    }
  }

  /// Stream of property names as they change.
  Stream<List<String>> get propertiesChanged => _propertyController.stream;

  T _getProperty<T>(String name, T defaultValue) {
    return _properties.get(name) ?? defaultValue;
  }

  void _updateProperties(Map<String, DBusValue> properties) {
    _properties.addAll(properties);
    _propertyController.add(properties.keys.toList());
  }
}

class SystemdSimpleSessionManager implements SimpleSessionManager {
  SystemdSimpleSessionManager({SystemdSessionManager? manager})
      : _manager = manager ?? SystemdSessionManager();

  final SystemdSessionManager _manager;

  @override
  Future<void> logout() async {
    await _manager.connect();
    await _manager.listSessions();
    final sessions = await _manager.listSessions();
    for (final session in sessions) {
      if (await session.active) await session.terminate();
    }
    await _manager.close();
  }

  @override
  Future<void> reboot() async {
    await _manager.connect();
    await _manager.reboot(true);
    await _manager.close();
  }

  @override
  Future<void> shutdown() async {
    await _manager.connect();
    await _manager.powerOff(true);
    await _manager.close();
  }
}

class SystemdSession {
  SystemdSession(this._object);
  final DBusRemoteObject _object;

  static final String sessionName = 'org.freedesktop.login1.Session';

  Future<String> get id async =>
      (await _object.getProperty(sessionName, 'Id')).asString();
  Future<bool> get active async =>
      (await _object.getProperty(sessionName, 'Active')).asBoolean();
  Future<void> lock() => _object.callMethod(sessionName, 'Lock', [],
      replySignature: DBusSignature(''));
  Future<void> terminate() => _object.callMethod(sessionName, 'Terminate', [],
      replySignature: DBusSignature(''));

  @override
  String toString() {
    return 'SystemdClient(${_object.path.value}';
  }
}
