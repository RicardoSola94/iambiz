// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_movements_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inventoryMovementsHash() =>
    r'c358dac048458bff3570686116004df5e9d434b4';

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

abstract class _$InventoryMovements
    extends BuildlessAsyncNotifier<List<InventoryMovement_model>> {
  late final String itemId;

  FutureOr<List<InventoryMovement_model>> build(String itemId);
}

/// See also [InventoryMovements].
@ProviderFor(InventoryMovements)
const inventoryMovementsProvider = InventoryMovementsFamily();

/// See also [InventoryMovements].
class InventoryMovementsFamily
    extends Family<AsyncValue<List<InventoryMovement_model>>> {
  /// See also [InventoryMovements].
  const InventoryMovementsFamily();

  /// See also [InventoryMovements].
  InventoryMovementsProvider call(String itemId) {
    return InventoryMovementsProvider(itemId);
  }

  @override
  InventoryMovementsProvider getProviderOverride(
    covariant InventoryMovementsProvider provider,
  ) {
    return call(provider.itemId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'inventoryMovementsProvider';
}

/// See also [InventoryMovements].
class InventoryMovementsProvider
    extends
        AsyncNotifierProviderImpl<
          InventoryMovements,
          List<InventoryMovement_model>
        > {
  /// See also [InventoryMovements].
  InventoryMovementsProvider(String itemId)
    : this._internal(
        () => InventoryMovements()..itemId = itemId,
        from: inventoryMovementsProvider,
        name: r'inventoryMovementsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$inventoryMovementsHash,
        dependencies: InventoryMovementsFamily._dependencies,
        allTransitiveDependencies:
            InventoryMovementsFamily._allTransitiveDependencies,
        itemId: itemId,
      );

  InventoryMovementsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
  }) : super.internal();

  final String itemId;

  @override
  FutureOr<List<InventoryMovement_model>> runNotifierBuild(
    covariant InventoryMovements notifier,
  ) {
    return notifier.build(itemId);
  }

  @override
  Override overrideWith(InventoryMovements Function() create) {
    return ProviderOverride(
      origin: this,
      override: InventoryMovementsProvider._internal(
        () => create()..itemId = itemId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<
    InventoryMovements,
    List<InventoryMovement_model>
  >
  createElement() {
    return _InventoryMovementsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryMovementsProvider && other.itemId == itemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InventoryMovementsRef
    on AsyncNotifierProviderRef<List<InventoryMovement_model>> {
  /// The parameter `itemId` of this provider.
  String get itemId;
}

class _InventoryMovementsProviderElement
    extends
        AsyncNotifierProviderElement<
          InventoryMovements,
          List<InventoryMovement_model>
        >
    with InventoryMovementsRef {
  _InventoryMovementsProviderElement(super.provider);

  @override
  String get itemId => (origin as InventoryMovementsProvider).itemId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
