// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clientes_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredClientesHash() => r'dac301e6f23a8c24f0b6e175874b8b39ffd2f7c9';

/// See also [filteredClientes].
@ProviderFor(filteredClientes)
final filteredClientesProvider =
    AutoDisposeProvider<List<ClienteModel>>.internal(
      filteredClientes,
      name: r'filteredClientesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$filteredClientesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredClientesRef = AutoDisposeProviderRef<List<ClienteModel>>;
String _$clientesCurrentFilterHash() =>
    r'8a19c3bf821710b56451a84ce0b2a1440fa99053';

/// See also [ClientesCurrentFilter].
@ProviderFor(ClientesCurrentFilter)
final clientesCurrentFilterProvider =
    NotifierProvider<ClientesCurrentFilter, FilterType>.internal(
      ClientesCurrentFilter.new,
      name: r'clientesCurrentFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$clientesCurrentFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ClientesCurrentFilter = Notifier<FilterType>;
String _$clientesHash() => r'0481d75ff1ba9104548e2b8420b21f17d9d07f73';

/// See also [Clientes].
@ProviderFor(Clientes)
final clientesProvider =
    AsyncNotifierProvider<Clientes, List<ClienteModel>>.internal(
      Clientes.new,
      name: r'clientesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product') ? null : _$clientesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Clientes = AsyncNotifier<List<ClienteModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
