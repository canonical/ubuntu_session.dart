import 'dart:async';

import 'package:dbus/dbus.dart';
import 'package:meta/meta.dart';

import 'constants.dart';
import 'util.dart';

class SessionManager {
  SessionManager({
    DBusClient? bus,
    @visibleForTesting DBusRemoteObject? object,
  })  : _bus = bus,
        _object = object ?? _createRemoteObject(bus);

  static DBusRemoteObject _createRemoteObject(DBusClient? bus) {
    return DBusRemoteObject(
      bus ?? DBusClient.session(),
      name: kBus,
      path: DBusObjectPath('/org/gnome/SessionManager'),
    );
  }

  final DBusClient? _bus;
  final DBusRemoteObject _object;
  final _properties = <String, DBusValue>{};
  final _propertyController = StreamController<List<String>>.broadcast();
  StreamSubscription? _propertySubscription;

  /// If true, the session is currently in the foreground and available for user
  /// input.
  bool get sessionIsActive => _getProperty('SessionIsActive', false);

  /// The name of the session that has been loaded.
  String get sessionName => _getProperty('SessionName', '');

  /// Connects to the Session Manager service.
  Future<void> connect() {
    _propertySubscription ??= _object.propertiesChanged.listen((signal) {
      if (signal.propertiesInterface == kBus) {
        _updateProperties(signal.changedProperties);
      }
    });
    return _object.getAllProperties(kBus).then(_updateProperties);
  }

  /// Closes connection to the Session Manager service.
  Future<void> close() async {
    await _propertySubscription?.cancel();
    _propertySubscription = null;
    if (_bus == null) {
      await _object.client.close();
    }
  }

  T _getProperty<T>(String name, T defaultValue) {
    return _properties.get(name) ?? defaultValue;
  }

  void _updateProperties(Map<String, DBusValue> properties) {
    _properties.addAll(properties);
    _propertyController.add(properties.keys.toList());
  }
}
