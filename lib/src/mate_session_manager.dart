import 'dart:async';

import 'package:dbus/dbus.dart';
import 'package:meta/meta.dart';

import 'simple_session_manager.dart';
import 'util.dart';

enum MateLogoutMode {
  /// Normal
  normal,

  /// No confirmation interface should be shown.
  noConfirm,

  /// Forcefully logout. No confirmation will be shown and any inhibitors will
  /// be ignored.
  force,
}

/// The client that connects to the MATE Session Manager
class MateSessionManager {
  MateSessionManager({
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

  static final String busName = 'org.gnome.SessionManager';
  static final String managerName = busName;
  static final String objectPath = '/org/gnome/SessionManager';

  final DBusClient? _bus;
  final DBusRemoteObject _object;
  final _properties = <String, DBusValue>{};
  final _propertyController = StreamController<List<String>>.broadcast();
  StreamSubscription? _propertySubscription;

  /// The name of the renderer.
  String get renderer => _getProperty('Renderer', '');

  /// Request a logout dialog.
  Future<void> logout({MateLogoutMode mode = MateLogoutMode.normal}) {
    return _object.callMethod(managerName, 'Logout', [DBusUint32(mode.index)],
        replySignature: DBusSignature(''));
  }

  /// Request a reboot/shutdown dialog.
  Future<void> shutdown() {
    return _object.callMethod(managerName, 'Shutdown', [],
        replySignature: DBusSignature(''));
  }

  /// True if shutdown is available to the user, false otherwise
  Future<bool> canShutdown() async {
    return _object
        .callMethod(managerName, 'CanShutdown', [],
            replySignature: DBusSignature('b'))
        .then((response) => response.values.first.asBoolean());
  }

  /// True if the session has entered the Running phase, false otherwise
  Future<bool> isSessionRunning() async {
    return _object
        .callMethod(managerName, 'IsSessionRunning', [],
            replySignature: DBusSignature('b'))
        .then((response) => response.values.first.asBoolean());
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

class MateSimpleSessionManager implements SimpleSessionManager {
  MateSimpleSessionManager({MateSessionManager? manager})
      : _manager = manager ?? MateSessionManager();

  final MateSessionManager _manager;

  @override
  Future<void> logout() async {
    await _manager.connect();
    await _manager.logout();
    await _manager.close();
  }

  @override
  Future<void> reboot() async {
    await _manager.connect();
    await _manager.shutdown();
    await _manager.close();
  }

  @override
  Future<void> shutdown() async {
    await _manager.connect();
    await _manager.shutdown();
    await _manager.close();
  }
}
