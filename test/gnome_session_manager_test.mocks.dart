// Mocks generated by Mockito 5.3.2 from annotations
// in ubuntu_session/test/gnome_session_manager_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:dbus/dbus.dart' as _i8;
import 'package:dbus/src/dbus_client.dart' as _i2;
import 'package:dbus/src/dbus_introspect.dart' as _i5;
import 'package:dbus/src/dbus_method_response.dart' as _i3;
import 'package:dbus/src/dbus_object.dart' as _i7;
import 'package:dbus/src/dbus_value.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:ubuntu_session/src/gnome_session_manager.dart' as _i9;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDBusProcessCredentials_0 extends _i1.SmartFake
    implements _i2.DBusProcessCredentials {
  _FakeDBusProcessCredentials_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDBusMethodSuccessResponse_1 extends _i1.SmartFake
    implements _i3.DBusMethodSuccessResponse {
  _FakeDBusMethodSuccessResponse_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDBusClient_2 extends _i1.SmartFake implements _i2.DBusClient {
  _FakeDBusClient_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDBusObjectPath_3 extends _i1.SmartFake
    implements _i4.DBusObjectPath {
  _FakeDBusObjectPath_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDBusIntrospectNode_4 extends _i1.SmartFake
    implements _i5.DBusIntrospectNode {
  _FakeDBusIntrospectNode_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDBusValue_5 extends _i1.SmartFake implements _i4.DBusValue {
  _FakeDBusValue_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [DBusClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockDBusClient extends _i1.Mock implements _i2.DBusClient {
  MockDBusClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get introspectable => (super.noSuchMethod(
        Invocation.getter(#introspectable),
        returnValue: false,
      ) as bool);
  @override
  String get uniqueName => (super.noSuchMethod(
        Invocation.getter(#uniqueName),
        returnValue: '',
      ) as String);
  @override
  Iterable<String> get ownedNames => (super.noSuchMethod(
        Invocation.getter(#ownedNames),
        returnValue: <String>[],
      ) as Iterable<String>);
  @override
  _i6.Stream<String> get nameAcquired => (super.noSuchMethod(
        Invocation.getter(#nameAcquired),
        returnValue: _i6.Stream<String>.empty(),
      ) as _i6.Stream<String>);
  @override
  _i6.Stream<String> get nameLost => (super.noSuchMethod(
        Invocation.getter(#nameLost),
        returnValue: _i6.Stream<String>.empty(),
      ) as _i6.Stream<String>);
  @override
  _i6.Stream<_i2.DBusNameOwnerChangedEvent> get nameOwnerChanged =>
      (super.noSuchMethod(
        Invocation.getter(#nameOwnerChanged),
        returnValue: _i6.Stream<_i2.DBusNameOwnerChangedEvent>.empty(),
      ) as _i6.Stream<_i2.DBusNameOwnerChangedEvent>);
  @override
  _i6.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<_i2.DBusRequestNameReply> requestName(
    String? name, {
    Set<_i2.DBusRequestNameFlag>? flags = const {},
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #requestName,
          [name],
          {#flags: flags},
        ),
        returnValue: _i6.Future<_i2.DBusRequestNameReply>.value(
            _i2.DBusRequestNameReply.primaryOwner),
      ) as _i6.Future<_i2.DBusRequestNameReply>);
  @override
  _i6.Future<_i2.DBusReleaseNameReply> releaseName(String? name) =>
      (super.noSuchMethod(
        Invocation.method(
          #releaseName,
          [name],
        ),
        returnValue: _i6.Future<_i2.DBusReleaseNameReply>.value(
            _i2.DBusReleaseNameReply.released),
      ) as _i6.Future<_i2.DBusReleaseNameReply>);
  @override
  _i6.Future<List<String>> listQueuedOwners(String? name) =>
      (super.noSuchMethod(
        Invocation.method(
          #listQueuedOwners,
          [name],
        ),
        returnValue: _i6.Future<List<String>>.value(<String>[]),
      ) as _i6.Future<List<String>>);
  @override
  _i6.Future<List<String>> listNames() => (super.noSuchMethod(
        Invocation.method(
          #listNames,
          [],
        ),
        returnValue: _i6.Future<List<String>>.value(<String>[]),
      ) as _i6.Future<List<String>>);
  @override
  _i6.Future<List<String>> listActivatableNames() => (super.noSuchMethod(
        Invocation.method(
          #listActivatableNames,
          [],
        ),
        returnValue: _i6.Future<List<String>>.value(<String>[]),
      ) as _i6.Future<List<String>>);
  @override
  _i6.Future<_i2.DBusStartServiceByNameReply> startServiceByName(
          String? name) =>
      (super.noSuchMethod(
        Invocation.method(
          #startServiceByName,
          [name],
        ),
        returnValue: _i6.Future<_i2.DBusStartServiceByNameReply>.value(
            _i2.DBusStartServiceByNameReply.success),
      ) as _i6.Future<_i2.DBusStartServiceByNameReply>);
  @override
  _i6.Future<bool> nameHasOwner(String? name) => (super.noSuchMethod(
        Invocation.method(
          #nameHasOwner,
          [name],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<String?> getNameOwner(String? name) => (super.noSuchMethod(
        Invocation.method(
          #getNameOwner,
          [name],
        ),
        returnValue: _i6.Future<String?>.value(),
      ) as _i6.Future<String?>);
  @override
  _i6.Future<int> getConnectionUnixUser(String? name) => (super.noSuchMethod(
        Invocation.method(
          #getConnectionUnixUser,
          [name],
        ),
        returnValue: _i6.Future<int>.value(0),
      ) as _i6.Future<int>);
  @override
  _i6.Future<int> getConnectionUnixProcessId(String? name) =>
      (super.noSuchMethod(
        Invocation.method(
          #getConnectionUnixProcessId,
          [name],
        ),
        returnValue: _i6.Future<int>.value(0),
      ) as _i6.Future<int>);
  @override
  _i6.Future<_i2.DBusProcessCredentials> getConnectionCredentials(
          String? name) =>
      (super.noSuchMethod(
        Invocation.method(
          #getConnectionCredentials,
          [name],
        ),
        returnValue: _i6.Future<_i2.DBusProcessCredentials>.value(
            _FakeDBusProcessCredentials_0(
          this,
          Invocation.method(
            #getConnectionCredentials,
            [name],
          ),
        )),
      ) as _i6.Future<_i2.DBusProcessCredentials>);
  @override
  _i6.Future<String> getId() => (super.noSuchMethod(
        Invocation.method(
          #getId,
          [],
        ),
        returnValue: _i6.Future<String>.value(''),
      ) as _i6.Future<String>);
  @override
  _i6.Future<void> ping([String? destination = r'org.freedesktop.DBus']) =>
      (super.noSuchMethod(
        Invocation.method(
          #ping,
          [destination],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<String> getMachineId(
          [String? destination = r'org.freedesktop.DBus']) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMachineId,
          [destination],
        ),
        returnValue: _i6.Future<String>.value(''),
      ) as _i6.Future<String>);
  @override
  _i6.Future<_i3.DBusMethodSuccessResponse> callMethod({
    String? destination,
    required _i4.DBusObjectPath? path,
    String? interface,
    required String? name,
    Iterable<_i4.DBusValue>? values = const [],
    _i4.DBusSignature? replySignature,
    bool? noReplyExpected = false,
    bool? noAutoStart = false,
    bool? allowInteractiveAuthorization = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #callMethod,
          [],
          {
            #destination: destination,
            #path: path,
            #interface: interface,
            #name: name,
            #values: values,
            #replySignature: replySignature,
            #noReplyExpected: noReplyExpected,
            #noAutoStart: noAutoStart,
            #allowInteractiveAuthorization: allowInteractiveAuthorization,
          },
        ),
        returnValue: _i6.Future<_i3.DBusMethodSuccessResponse>.value(
            _FakeDBusMethodSuccessResponse_1(
          this,
          Invocation.method(
            #callMethod,
            [],
            {
              #destination: destination,
              #path: path,
              #interface: interface,
              #name: name,
              #values: values,
              #replySignature: replySignature,
              #noReplyExpected: noReplyExpected,
              #noAutoStart: noAutoStart,
              #allowInteractiveAuthorization: allowInteractiveAuthorization,
            },
          ),
        )),
      ) as _i6.Future<_i3.DBusMethodSuccessResponse>);
  @override
  _i6.Future<void> emitSignal({
    String? destination,
    required _i4.DBusObjectPath? path,
    required String? interface,
    required String? name,
    Iterable<_i4.DBusValue>? values = const [],
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #emitSignal,
          [],
          {
            #destination: destination,
            #path: path,
            #interface: interface,
            #name: name,
            #values: values,
          },
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> registerObject(_i7.DBusObject? object) =>
      (super.noSuchMethod(
        Invocation.method(
          #registerObject,
          [object],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> unregisterObject(_i7.DBusObject? object) =>
      (super.noSuchMethod(
        Invocation.method(
          #unregisterObject,
          [object],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}

/// A class which mocks [DBusRemoteObject].
///
/// See the documentation for Mockito's code generation for more information.
class MockDBusRemoteObject extends _i1.Mock implements _i8.DBusRemoteObject {
  MockDBusRemoteObject() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.DBusClient get client => (super.noSuchMethod(
        Invocation.getter(#client),
        returnValue: _FakeDBusClient_2(
          this,
          Invocation.getter(#client),
        ),
      ) as _i2.DBusClient);
  @override
  String get name => (super.noSuchMethod(
        Invocation.getter(#name),
        returnValue: '',
      ) as String);
  @override
  _i4.DBusObjectPath get path => (super.noSuchMethod(
        Invocation.getter(#path),
        returnValue: _FakeDBusObjectPath_3(
          this,
          Invocation.getter(#path),
        ),
      ) as _i4.DBusObjectPath);
  @override
  _i6.Stream<_i8.DBusPropertiesChangedSignal> get propertiesChanged =>
      (super.noSuchMethod(
        Invocation.getter(#propertiesChanged),
        returnValue: _i6.Stream<_i8.DBusPropertiesChangedSignal>.empty(),
      ) as _i6.Stream<_i8.DBusPropertiesChangedSignal>);
  @override
  set propertiesChanged(
          _i6.Stream<_i8.DBusPropertiesChangedSignal>? _propertiesChanged) =>
      super.noSuchMethod(
        Invocation.setter(
          #propertiesChanged,
          _propertiesChanged,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i6.Future<_i5.DBusIntrospectNode> introspect() => (super.noSuchMethod(
        Invocation.method(
          #introspect,
          [],
        ),
        returnValue:
            _i6.Future<_i5.DBusIntrospectNode>.value(_FakeDBusIntrospectNode_4(
          this,
          Invocation.method(
            #introspect,
            [],
          ),
        )),
      ) as _i6.Future<_i5.DBusIntrospectNode>);
  @override
  _i6.Future<_i4.DBusValue> getProperty(
    String? interface,
    String? name, {
    _i4.DBusSignature? signature,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getProperty,
          [
            interface,
            name,
          ],
          {#signature: signature},
        ),
        returnValue: _i6.Future<_i4.DBusValue>.value(_FakeDBusValue_5(
          this,
          Invocation.method(
            #getProperty,
            [
              interface,
              name,
            ],
            {#signature: signature},
          ),
        )),
      ) as _i6.Future<_i4.DBusValue>);
  @override
  _i6.Future<Map<String, _i4.DBusValue>> getAllProperties(String? interface) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllProperties,
          [interface],
        ),
        returnValue: _i6.Future<Map<String, _i4.DBusValue>>.value(
            <String, _i4.DBusValue>{}),
      ) as _i6.Future<Map<String, _i4.DBusValue>>);
  @override
  _i6.Future<void> setProperty(
    String? interface,
    String? name,
    _i4.DBusValue? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setProperty,
          [
            interface,
            name,
            value,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<_i3.DBusMethodSuccessResponse> callMethod(
    String? interface,
    String? name,
    Iterable<_i4.DBusValue>? values, {
    _i4.DBusSignature? replySignature,
    bool? noReplyExpected = false,
    bool? noAutoStart = false,
    bool? allowInteractiveAuthorization = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #callMethod,
          [
            interface,
            name,
            values,
          ],
          {
            #replySignature: replySignature,
            #noReplyExpected: noReplyExpected,
            #noAutoStart: noAutoStart,
            #allowInteractiveAuthorization: allowInteractiveAuthorization,
          },
        ),
        returnValue: _i6.Future<_i3.DBusMethodSuccessResponse>.value(
            _FakeDBusMethodSuccessResponse_1(
          this,
          Invocation.method(
            #callMethod,
            [
              interface,
              name,
              values,
            ],
            {
              #replySignature: replySignature,
              #noReplyExpected: noReplyExpected,
              #noAutoStart: noAutoStart,
              #allowInteractiveAuthorization: allowInteractiveAuthorization,
            },
          ),
        )),
      ) as _i6.Future<_i3.DBusMethodSuccessResponse>);
}

/// A class which mocks [GnomeSessionManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockGnomeSessionManager extends _i1.Mock
    implements _i9.GnomeSessionManager {
  MockGnomeSessionManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get sessionIsActive => (super.noSuchMethod(
        Invocation.getter(#sessionIsActive),
        returnValue: false,
      ) as bool);
  @override
  String get sessionName => (super.noSuchMethod(
        Invocation.getter(#sessionName),
        returnValue: '',
      ) as String);
  @override
  _i6.Stream<List<String>> get propertiesChanged => (super.noSuchMethod(
        Invocation.getter(#propertiesChanged),
        returnValue: _i6.Stream<List<String>>.empty(),
      ) as _i6.Stream<List<String>>);
  @override
  _i6.Future<void> logout({Set<_i9.GnomeLogoutMode>? mode = const {}}) =>
      (super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
          {#mode: mode},
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> reboot() => (super.noSuchMethod(
        Invocation.method(
          #reboot,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> shutdown() => (super.noSuchMethod(
        Invocation.method(
          #shutdown,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<bool> canShutdown() => (super.noSuchMethod(
        Invocation.method(
          #canShutdown,
          [],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<bool> isSessionRunning() => (super.noSuchMethod(
        Invocation.method(
          #isSessionRunning,
          [],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<void> connect() => (super.noSuchMethod(
        Invocation.method(
          #connect,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}
