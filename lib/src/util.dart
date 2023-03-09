import 'package:dbus/dbus.dart';

extension DbusProperties on Map<String, DBusValue> {
  T? get<T>(String key) => this[key]?.toNative() as T?;
}

int encodeEnum(Set<Enum> flags) {
  var value = 0;
  for (final f in flags) {
    value |= 1 << f.index;
  }
  return value;
}
