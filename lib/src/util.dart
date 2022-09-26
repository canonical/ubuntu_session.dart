import 'package:dbus/dbus.dart';

extension DbusProperties on Map<String, DBusValue> {
  T? get<T>(String key) => this[key]?.toNative() as T?;
}
