// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userDataHash() => r'ab04a6ce3488eed3a8072d7001b0a7c979e477fb';

/// See also [userData].
@ProviderFor(userData)
final userDataProvider = FutureProvider<UserModel?>.internal(
  userData,
  name: r'userDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserDataRef = FutureProviderRef<UserModel?>;
String _$userNameHash() => r'4707a14dd61ddefce15c9f30dc13a4e5983f00cc';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userName].
@ProviderFor(userName)
const userNameProvider = UserNameFamily();

/// See also [userName].
class UserNameFamily extends Family<AsyncValue<String>> {
  /// See also [userName].
  const UserNameFamily();

  /// See also [userName].
  UserNameProvider call(int id) {
    return UserNameProvider(id);
  }

  @override
  UserNameProvider getProviderOverride(covariant UserNameProvider provider) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userNameProvider';
}

/// See also [userName].
class UserNameProvider extends FutureProvider<String> {
  /// See also [userName].
  UserNameProvider(int id)
    : this._internal(
        (ref) => userName(ref as UserNameRef, id),
        from: userNameProvider,
        name: r'userNameProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$userNameHash,
        dependencies: UserNameFamily._dependencies,
        allTransitiveDependencies: UserNameFamily._allTransitiveDependencies,
        id: id,
      );

  UserNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<String> Function(UserNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserNameProvider._internal(
        (ref) => create(ref as UserNameRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  FutureProviderElement<String> createElement() {
    return _UserNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserNameProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserNameRef on FutureProviderRef<String> {
  /// The parameter `id` of this provider.
  int get id;
}

class _UserNameProviderElement extends FutureProviderElement<String>
    with UserNameRef {
  _UserNameProviderElement(super.provider);

  @override
  int get id => (origin as UserNameProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
