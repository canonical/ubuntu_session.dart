import 'dart:async';

import 'package:dbus/dbus.dart';
import 'package:meta/meta.dart';

import 'util.dart';

/// The client that connects to the SystemD Session Manager
class SystemdSessionManager {
  SystemdSessionManager({
    DBusClient? bus,
    @visibleForTesting DBusRemoteObject? object,
  })  : _bus = bus,
        _object = object ?? _createRemoteObject(bus);

  static DBusRemoteObject _createRemoteObject(DBusClient? bus) {
    return DBusRemoteObject(
      bus ?? DBusClient.session(),
      name: busName,
      path: DBusObjectPath(objectPath),
    );
  }

  static final String busName = 'org.freedesktop.login1.Manager';
  static final String objectPath = '/org/freedesktop/login1';

  final DBusClient? _bus;
  final DBusRemoteObject _object;
  final _properties = <String, DBusValue>{};
  final _propertyController = StreamController<List<String>>.broadcast();
  StreamSubscription? _propertySubscription;

  bool get onExternalPower => _getProperty('OnExternalPower', false);

  /// Halt the system.
  Future<void> halt(bool interactive) {
    return _object.callMethod(busName, 'Halt', [DBusBoolean(interactive)],
        replySignature: DBusSignature(''));
  }

  /// Hibernate the system.
  Future<void> hibernate(bool interactive) {
    return _object.callMethod(busName, 'Hibernate', [DBusBoolean(interactive)],
        replySignature: DBusSignature(''));
  }

  /// Power off the system.
  Future<void> powerOff(bool interactive) {
    return _object.callMethod(busName, 'PowerOff', [DBusBoolean(interactive)],
        replySignature: DBusSignature(''));
  }

  /// Reboot the system.
  Future<void> reboot(bool interactive) {
    return _object.callMethod(busName, 'Reboot', [DBusBoolean(interactive)],
        replySignature: DBusSignature(''));
  }

  /// Suspend the system.
  Future<void> suspend(bool interactive) {
    return _object.callMethod(busName, 'Suspend', [DBusBoolean(interactive)],
        replySignature: DBusSignature(''));
  }

  Future<String> canHalt() {
    return _object
        .callMethod(busName, 'CanHalt', [], replySignature: DBusSignature('s'))
        .then((response) => response.values.first.asString());
  }

  Future<String> canHibernate() {
    return _object
        .callMethod(busName, 'CanHibernate', [],
            replySignature: DBusSignature('s'))
        .then((response) => response.values.first.asString());
  }

  Future<String> canPowerOff() {
    return _object
        .callMethod(busName, 'CanPowerOff', [],
            replySignature: DBusSignature('s'))
        .then((response) => response.values.first.asString());
  }

  Future<String> canSuspend() {
    return _object
        .callMethod(busName, 'CanSuspend', [],
            replySignature: DBusSignature('s'))
        .then((response) => response.values.first.asString());
  }

  Future<String> canReboot() {
    return _object
        .callMethod(busName, 'CanReboot', [],
            replySignature: DBusSignature('s'))
        .then((response) => response.values.first.asString());
  }

  /// Connects to the Session Manager service.
  Future<void> connect() async {
    // Already connected
    if (_propertySubscription != null) {
      return;
    }
    _propertySubscription ??= _object.propertiesChanged.listen((signal) {
      if (signal.propertiesInterface == busName) {
        _updateProperties(signal.changedProperties);
      }
    });
    return _object.getAllProperties(busName).then(_updateProperties);
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
