import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iambiz/domain/entities/clientes/clientes_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clientes_providers.g.dart';

enum FilterType { all, completed, pending }

@Riverpod(keepAlive: true)
class ClientesCurrentFilter extends _$ClientesCurrentFilter {
  @override
  FilterType build() => FilterType.all;

  void setCurrentFilter(FilterType newFilter) {
    print('Nuevo filtro seleccionado: $newFilter');
    state = newFilter;
  }
}

@Riverpod(keepAlive: true)
class Clientes extends _$Clientes {
  @override
  Future<List<ClienteModel>> build() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    await Future.delayed(const Duration(seconds: 1));

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('clientes')
            .get();

    return snapshot.docs
        .map((doc) => ClienteModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addCliente(ClienteModel cliente) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    state = const AsyncLoading();
    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('clientes')
        .add(cliente.toMap());

    final newCliente = cliente.copyWith(id: docRef.id);

    // Actualiza el estado con el nuevo cliente
    state = AsyncData([...state.value ?? [], newCliente]);
  }

  Future<void> updateCliente(ClienteModel cliente) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    state = const AsyncLoading();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('clientes')
        .doc(cliente.id)
        .update(cliente.toMap());

    state = AsyncData([
      for (final c in state.value ?? [])
        if (c.id == cliente.id) cliente else c,
    ]);
  }

  Future<void> deleteCliente(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    state = const AsyncLoading();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('clientes')
        .doc(id)
        .delete();

    state = AsyncData((state.value ?? []).where((c) => c.id != id).toList());
  }
}

@riverpod
List<ClienteModel> filteredClientes(Ref ref) {
  final filter = ref.watch(clientesCurrentFilterProvider);
  final clientesAsync = ref.watch(clientesProvider);

  return clientesAsync.maybeWhen(
    data: (clientes) {
      switch (filter) {
        case FilterType.completed:
          return clientes.where((c) => c.estado == 'activo').toList();
        case FilterType.pending:
          return clientes.where((c) => c.estado == 'inactivo').toList();
        case FilterType.all:
          return clientes;
      }
    },
    orElse: () => [],
  );
}
